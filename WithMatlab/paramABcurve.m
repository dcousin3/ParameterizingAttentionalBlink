function curveOut=paramABcurve(param,xData,yData,varargin)
%% paramABcurve
% from Cousineau et al. (2006). Parametizing the Attentional Blink Effect.
% Candadian Journal of Experimental Psychology, 60, 175-189.
%
% The code is courtesy of Nicholas Badcock, Dorothy Bishop, and Mihaela Duta  [mailto:nicholas.badcock@psy.ox.ac.uk]
%
% curveOut=paramABcurve(param,xData,yData,[])
%
% param = array of 4 parameter estimates [l b g d]
% xData = inter-target interval/lag array e.g. 1:8
% yData = AB performance estimates, proportion correct
%
% varargin = optional input,
% include anything here e.g. 1, and the log likelihood value will be
% returned.
% ==> this is required to run the paramABfit function
%
%% Equation
%  p(x|l,b,g,d)=d*(1-e^(-1*(log(x-1+l*e^b)-b)))+g;
%
% where:
% l = lag-1 sparing
% b = width of sparing to recovery
% g = minimum
% d = amplitude (e.g.,max-min)
%

l=param(1);
b=param(2);
g=param(3);
d=param(4);

y=d*(1-exp(-(log(xData-1+l*exp(b))-b).^2))+g;
curveOut=y;

if ~isempty(varargin)
ll=-sum(yData.*log(y)+(1-yData).*log(1-y));% log likelihood summed over all intervals
curveOut=ll;
end