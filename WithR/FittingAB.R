#' @title ParameterizingAttentionalBlink 

#' @description Estimate four parameters from percent corrects of an attentional blink task.
#'   The full reference is Cousineau, D., Charbonneau, D., & Jolicoeur, P. (2006)
#'   Canadian Journal of Experimental Psychology,
#'   Vol. 60, No. 3, 175-189 DOI: 10.1037/cjep2006017

#' @usage AB(lag, l, b, c, d) provides the predicted percent correct of an attentional blink at lag
#' @usage LL() yields the log of the likelihood of the parameters given the data. The data must be a list of pairs of values, {lag, Percent correct at that lag}.
#' @usage fitAB maximizes the LL over the four parameters l,b,c,d given a data set.
#'   fitAB(data) where data is a dataframe of pairs {lag, p(c)}.
#'   fitAB(data, c(loL,hiL), c(loB,hiB), c(loC,hiC), c(loD,hiD) )
#'     gives starting points to the search of the form {low, hi} for each of the four parameters.


#' @param l is the lag-1 sparing parameter
#' @param b is the widht parameter
#' @param c is the heigth parameter, and
#' @param d is the depth parameter;
#' @param data is a dataframe of percent correct as a function of lag

#' @return AB returns a predicted performance, LL the fit, and fitAB returns bestfitparameters and bestfit

BadFit <- 10^6;

AB <- function(x, l, b, c, d) { 
  if ( (l < 0) || (l > 1) || (exp(b) <= 0.75) || (c <= 0) || (c > 1) || (d <= 0) || (d > 1) || (c + d > 1) ) {
	BadFit
  } else {
	d * ( 1 - exp(-(log(x - 1 + l * exp(b) ) - b )^2)) + c
  }
}


LL <- function(data, l, b, c, d) {
    sum(
        data[, 2]       * log(    AB(data[, 1], l, b, c, d)) + 
        (1 - data[, 2]) * log(1 - AB(data[, 1], l, b, c, d))
    )
}


fitAB <- function(data, 
            rngL = c(+0.1, +0.9), rngB = c(-0.3, +0.1), 
            rngC = c(-0.1, +0.1), rngD = c(-0.1, +0.1) ) { 
    # required library
    require(stats)
    
    # constraints ui %*% c(l,c,b,d) >= ci
    ui  <- matrix(
        c(-1,0,0,0,+1,0,0,0,0,+1,0,0,0,0,-1,0,0,0,+1,0,0,0,0,-1,0,0,0,+1,0,0,-1,-1),
        byrow = TRUE, ncol = 4
    )
    ci  <- as.matrix(c(-1,0,-0.3,-1,0,-1,0,-1))

    # starting point heuristics
#    lo  <- min(data[,2]);
#    hi  <- max(data[,2]) - min(data[,2]);

    # define the objective function
    fct <- function(theta) {
        LL(data, l=theta[1], b=theta[2], c=theta[3], d=theta[4])
    }

    # minimization per se
    res <- constrOptim(
        theta = c(sum(rngL)/2, sum(rngB)/2, sum(rngC)/2+0.01, sum(rngD)/2+0.01),
        f     = fct, 
        ui    = ui,
        ci    = ci,
        control = list(trace = 0, fnscale = -1), # trace=0 for none
        method = "Nelder-Mead"
    )
    res
}    


