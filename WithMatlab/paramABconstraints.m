%
% The code is courtesy of Nicholas Badcock, Dorothy Bishop, and Mihaela Duta  [mailto:nicholas.badcock@psy.ox.ac.uk]
%
function [c,ceq]=paramABconstraints(param)
c=[param(3)+param(4)-1; % g + d >=0
    -param(3)-param(4)]; %  g + d <=1
ceq=0;
