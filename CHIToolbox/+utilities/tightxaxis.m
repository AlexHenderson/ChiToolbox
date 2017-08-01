function tightxaxis()

% tightxaxis  Makes the x-axis tight, but allows the y-axis to autoscale
%
% Syntax
%   tightxaxis();
%
% Description
%   tightxaxis() modifies the axes of a plot such that the y-axis will
%   autoscale, but the x-axis is tight.
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


% Taken from
% https://uk.mathworks.com/matlabcentral/answers/295700-how-to-use-the-tight-function-for-just-one-axis

    currentY = ylim(gca);   % retrieve auto y-limits
    axis tight;             % set tight range
    ylim(gca,currentY)      % restore y limits 

end
