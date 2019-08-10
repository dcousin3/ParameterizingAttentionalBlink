# set the working directory to wherever the file FittingAB.R is stored
setwd("C:\\Users\\DenisCousineau\\Documents\\1_Publications\\Mes Articles\\_4_Publié (95x)\\21_a_30 (7x)\\21_Fitting AB_2006\\WithR")

# input the commands from the file FittingAB.R
source("FittingAB.R")

# lets load some data into a data frame
sampledata = read.csv(header = FALSE, 
col.names =c("Lag","Pc"),
text= "
1, 0.82 
2, 0.54
3, 0.76
4, 0.72
5, 0.83
6, 0.82
7, 0.86
8, 0.90
")
# column 1 (lag) is the separation between target 1 and target 2
# column 2 (Pc)  is percent correct for target 2
# These data are presumably from a single participant.

# a quick plot
 plot(sampledata, type = "b")

# If you have a set of parameters in mind, say
# l = 0.5, b = 1.0, c = 0.55, d = 0.35
# then this computes the log likehood of the data
# given these parameters. The number is negative but
# better fits are closer to zero than worse fits
LL(sampledata, 0.5, 1.0, .55, .35) 

# this makes a plot of the theoretical curves for 
# these parameters
oneAB <- function(x) {AB(x, l = 0.5, b = 1.0, c = 0.55, d = 0.35)}
curve(oneAB, xlim = c(1,8) )

# this is the most important use: searching the best parameters
sol <- fitAB(sampledata)
# you get the best-fitting parameters with 
sol$par
# and the fit with 
sol$value



