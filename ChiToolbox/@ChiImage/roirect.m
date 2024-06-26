function obj = roirect(varargin)

% roirect  Rectangular region of interest (ROI)
% 
% Syntax
%   roirect();
%   roi = roirect();
%
% Description
%   roirect() allows the user to draw a rectangle on the image and retain
%   only those pixels within. 
%
%   roi = roirect() create a clone of the image and copies the region of
%   interest into it.
%
% Notes
%   If an image is not currently displayed, a total signal image is used
%   (see the display function for details). 
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   roipoly roifreehand display crop imagesc.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox

%   Rectangular roi so returns an image


this = varargin{1};

if nargout
    obj = this.clone();
    % Not a great approach, but quite generic. 
    % Prevents errors if the function name changes. 
    command = [mfilename, '(obj,varargin{2:end});'];
    eval(command);  
else
    % We are expecting to modify this object in situ
    
    % Determine the current figure window or create one
    fig = get(groot,'CurrentFigure');
    if isempty(fig)
        fig = this.display();
    end
    
    % Allow the user to draw a rectangle on the figure
    shape = imrect(fig.CurrentAxes);
    if ~isempty(shape)
        % The user drew a rectangle so remove all pixels outside it. 
        pixelmask = shape.createMask();
        
        mask = ChiMask(pixelmask);
        if (mask.numtrue == 0)
            err = MException(['CHI:',mfilename,':IOError'], ...
            'No region selected.');
            throw(err);
        end

        % Determine the limits of the rectangle. imroi.getPosition doesn't
        % quite cut it, so rolling my own. 
        [y1,x1] = find(pixelmask,1,'first');
        [y2,x2] = find(pixelmask,1,'last');
        width = x2 - x1 + 1;
        height = y2 - y1 + 1;

        pixelmask = reshape(pixelmask, this.numpixels,1);

        this.data = this.data(pixelmask,:);
        this.xpixels = width;
        this.ypixels = height;
        historyString = sprintf('ROI selection at [x1,x2,y1,y2] = [%d,%d,%d,%d].', x1,x2,y1,y2);
        this.history.add(historyString);
    end
    
end

end
