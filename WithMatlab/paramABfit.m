function varargout=paramABfit(xData,yData)
%% paramABfit
% from Cousineau et al. (2006). Parametizing the Attentional Blink Effect.
% Candadian Journal of Experimental Psychology, 60, 175-189.
%
% The code is courtesy of Nicholas Badcock, Dorothy Bishop, and Mihaela Duta  [mailto:nicholas.badcock@psy.ox.ac.uk]
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
%% inputs
% 
% xData = lag numbers e.g., [1 2 3 4 5 6 7 8] (note: not 100 200 etc.)
% yData = observed performance at each lag
%
%% outputs
%
% [paramEst R^2 predictedData]=paramABfit(xData,yData)
%  - varargout{1}=paramEst = [l b g d]
%  - varargout{2}=R^2
%  - varargout{3}=predictedData
%

%% >> starting
% starting heuristics:
%  set
%   - g to minimum performance
%   - d dif between min and max
% constant start values
% set
%   - l = 0.5
%   - b = 1.0

% standard starting variables
l=.5; % lag-1 sparing
b=min(xData); % width
g=min(yData); % minimum
d=max(yData)-min(yData); % amplitude
x0=[l b g d]; % starting estimate values

%% >> constraints:
% g: 0<= g <=1
% d: 0<= d <=1
% & 0<= d + g <=1
% l: 0<= l <=1
% b >.75*lag
bValue=min(xData);
bCount=1;
while bValue<=0
    bCount=bCount+1;
    bValue=xData(bCount);
end
lb=[0 log(.75*min(xData)) 0 0]; % lower bounds/constraints
ub=[1 inf 1 1]; % upper bounds/constraints

%% fit using fmincon and paramABconstraints
% paramABconstraints function ensures:
% 0<= d + g <=1
options = optimset('Display','off',              ...
    'TolX',1.e-8, 'TolFun',1.e-20, ...
    'MaxIter',1000);

paramEst = fmincon(@(x) paramABcurve(x,xData,yData,1), ...
    x0, [],[], [],[], lb,ub, ...
    'paramABconstraints', ...
    options);

%% fit statistic
% use R-squared
pred=paramABcurve(paramEst,xData,yData);

% SSE=sum((yData-pred).^2);
SST=sum((yData-mean(yData)).^2);
SSR=sum((pred-mean(pred)).^2);
R2=(SSR/SST); % explained variance

%% set output
varargout{1}=paramEst;
varargout{2}=R2;
varargout{3}=pred;
