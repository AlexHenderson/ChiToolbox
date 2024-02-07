function tightxaxis(desiredaxes)

% tightxaxis  Makes the x-axis tight, but allows the y-axis to autoscale
%
% Syntax
%   tightxaxis();
%   tightxaxis(desiredaxis);
%
% Description
%   tightxaxis() modifies the axes of a plot such that the y-axis will
%   autoscale, but the x-axis is tight.
% 
%   tightxaxis(desiredaxes) modifies the desiredaxes. Defaults to gca. 
%
% Copyright (c) 2017-2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot, gca

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 2.0, August 2018
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox

% Taken from
% https://uk.mathworks.com/matlabcentral/answers/295700-how-to-use-the-tight-function-for-just-one-axis


    if ~exist('desiredaxes','var')
        desiredaxes = gca;
    end

    currentY = ylim(desiredaxes);   % retrieve auto y-limits
    axis(desiredaxes,'tight');      % set tight range
    ylim(desiredaxes,currentY)      % restore y limits 

end
