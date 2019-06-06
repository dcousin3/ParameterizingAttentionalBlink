(* ::Package:: *)

(********************************************************)
(*						                                  	*)
(* ABFitting.m                                                   *)
(*                                                               *)
(*   (c) Denis Cousineau, 2003                                   *)
(*    updated for Mathematica version 8 and above, 2019          *)
(*						                                  	*)
(*   This package contains the tools for ABFitting.  	        *)
(*						                                       *)
(********************************************************)


(********************************************************)
(*	help functions 					*)
(********************************************************)

ABFitting::usage="The ABFitting modules provides some functions that are used in Mathematica for fitting the Attentional Blink 
curve using a parameterized function to avoid parameter correlation. 
To load this module, use:
\n\t << path\\ABFitting.m . 
\nThe functions available are AB, LL and FitAB. \nIt also provides tools for 
graphing the Attentional Blink curve. \nThe functions available are PlotABData and PlotABCurve. 
Use ? name for more information."

AB::usage="This equation provides a curve that has the approximate shape of an attentional blink. 
\n\t AB[lag, {l, b, c, d}]
\n where l is the lag-1 sparing parameter,
\n b is the widht parameter,
\n c is the heigth parameter, and
\n d is the depth parameter.
\nOne convenient way to illustrate 
this function is through the use of the Plot command. For example:
\n\t Plot[AB[x, {0.5, 1.0, .55, .35}], {x, 1, 8}]"

LL::usage="The logLikelihoond (LL) equation yields the log of the likelihood of the parameters given the data. The data must be a list 
of pairs of values, {lag, Percent correct at that lag}."

FitAB::usage="The FitAB procedure minimizes the -LL over the four parameters l,b,c,d given a data set.\n
Usage:\n
\t FitAB[data] where data is a list of pairs {lag, p(c)}.\n
\t FitAB[data, {startingpointL}, {startingpointB}, {startingpointC}, {startingpointD} ] 
gives starting points to the search of the form {low, hi} for each of the four parameters."

PlotABCurve::usage="This function plots the theoretical curve of
an attentional blink given a set of parameters."

PlotABData::usage="This function plots the empirical data given 
a list of pairs {lag, percent correct}."

(********************************************************)
(*	The ABFitting functions 			*)
(********************************************************)

BadFit = 10^6;

(* the AB curve, for ploting purposes *)
AB[x_, {l_, b_, c_, d_}] := BadFit  /; c <= 0 || c >= 1
AB[x_, {l_, b_, c_, d_}] := BadFit  /; d <= 0 || d >= 1
AB[x_, {l_, b_, c_, d_}] := BadFit  /; c + d > 1
AB[x_, {l_, b_, c_, d_}] := BadFit  /; Exp[b]  <= 0.75  
AB[x_, {l_, b_, c_, d_}] := BadFit  /; l > 1 || l < 0
AB[x_, {l_, b_, c_, d_}] := d ( 1 - Exp[-(Log[x - 1 + l Exp[b] ] - b )^2]) + c


(* the same AB curve in a single equation *)
AB[x_, {l_, b_, c_, d_}] := 
  If[c <= 0 || c > 1 || d <= 0 || d > 1 || c + d > 1 || Exp[b] <= 0.75   || l < 0 || l > 1 , 
	BadFit, 
	d ( 1 - Exp[-(Log[x - 1 + l Exp[b] ] - b )^2]) + c
  ]

(* the likelihood function to be minimized *)
LL[data_, theta_] := Sum[
	data[[i, 2]] Log[AB[data[[i, 1]], theta]] + 
	(1 - data[[i, 2]]) Log[1 - AB[data[[i, 1]], theta]],
	{i, 1, Length[data]}
];

FitAB[data_, rangeL_:{0.1,0.9}, rangeB_:{-0.3, 0.1},rangeC_:{-0.1,+0.1},rangeD_:{-0.1,+0.1}] := 
Module[{hi, lo},
    (*starting point heuristics*)
    lo = Min[data[[All,2]]];
    hi = Max[data[[All,2]]] - Min[data[[All,2]]];

    (*minimization per se*)
    NMaximize[{
		LL[data, {l, b, c, d}],
        0 <= l <= 1 &&  0<= c <=  1 && 0 <= d <= 1 && c + d <= 1 && b > -0.3
    },{
        {l,                rangeL[[1]],                   rangeL[[2]]},
        {b,                rangeB[[1]],                   rangeB[[2]]},
        {c, Max[0.001,lo + rangeC[[1]] ],            lo + rangeC[[2]]},
        {d,           hi + rangeD[[1]],   Min[0.999, hi + rangeD[[2]] ]}
    }
    ]
]


(********************************************************)
(*	The Ploting functions 			*)
(********************************************************)

PlotABCurve[ theta_List, opt___] := 
  Plot[ AB[x, theta ], {x, 1, 8}, 
    PlotRange -> {{0, 9}, {0, 1}}, opt,
    PlotStyle -> {Thickness[0.0125], Dashing[{0.01, 0.03}]}
];

PlotABData[data_List, opt___] := 
  ListPlot[ data, 
    opt, 
    Joined -> True, 
    PlotRange -> {{0, 9}, {0, 1}}, 
    PlotStyle -> {RGBColor[.4,.4,.4],Thickness[0.0125]}
];




(********************************************************)
(*	All done.					*)
(********************************************************)

Print["Module ABFitting w/ LogLikelihood reparameterized loaded correctly. Type ? ABFitting for more."];

