function paramABplot(param,xData,yData,varargin)
%% paramABplot
%
% creates a plot of the inputted yData against the parameter curve
% created by the parameters.  Plot will pause - keypress will close the
% plot.
%
% from Cousineau et al. (2006). Parametizing the Attentional Blink Effect.
% Candadian Journal of Experimental Psychology, 60, 175-189.
%
% The code is courtesy of Nicholas Badcock, Dorothy Bishop, and Mihaela Duta  [mailto:nicholas.badcock@psy.ox.ac.uk]
%
% curveOut=paramABcurve(param,xData,yData,[plotLabel])
%
% param = array of 4 parameter estimates [l b g d]
% xData = inter-target interval/lag array e.g. 1:8
% yData = AB performance estimates, proportion correct
%
% varargin = optional input,
% plot label
%
%% Equation
%  p(x|l,b,g,d)=d*(1-e^(-1*(log(x-1+l*e^b)-b)))+g;
%
% where:
% l = lag-1 sparing
% b = width of sparing to recovery
% g = minimum
% d = amplitude (e.g.,max-min)

%% get varargin
plotLabel='';
if nargin>3
    plotLabel=varargin{1};
end

%% return predicted curve
predictedCurve=paramABcurve(param,xData,yData);

%% plot data
figId=figure; hold;
plot(xData,yData,'blue','LineWidth',2);
plot(xData,predictedCurve,'red');
title([plotLabel,' (Cousineau et al. AB fit)']);
legend('observed','predicted','Location','NorthWest');
textPos=[xData(length(xData)*.75) ...
    param(3)+param(4)*.25];
text(textPos(1),textPos(2),sprintf('%s\n%s\n%s\n%s\n',...
    ['Sparing = ',num2str(param(1))],...
    ['Width = ',num2str(param(2))],...
    ['Min = ',num2str(param(3))],...
    ['Amp = ',num2str(param(4))]));
disp('Press a key to continue');
pause;
close(figId);
