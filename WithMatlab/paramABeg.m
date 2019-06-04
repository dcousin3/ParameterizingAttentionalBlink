function varargout=paramABeg(varargin)
%% paramABeg
%
% simple example of matlab code for:
% Cousineau et al. (2006). Parametizing the Attentional Blink Effect.
% Candadian Journal of Experimental Psychology, 60, 175-189.
%
% The code is courtesy of Nicholas Badcock, Dorothy Bishop, and Mihaela Duta  [mailto:nicholas.badcock@psy.ox.ac.uk]
%
% [paramEst R2 predictedData]=paramABeg([xData],[yData]);
%
% no inputs required
%
xData=1:8;
yData=[.7 .5 .6 .7 .75 .8 .9 .9];
if nargin>0
    try
    xData=varargin{1};
    yData=varargin{2};
    catch err
        error('If using inputs, both xData (lags) and yData (observations) are required');
    end
end

[paramEst R2 predictedData]=paramABfit(xData,yData);
paramABplot(paramEst,xData,yData,'Example Cousineau et al. (2006) plot');

varargout{1}=paramEst;
varargout{2}=R2;
varargout{3}=predictedData;