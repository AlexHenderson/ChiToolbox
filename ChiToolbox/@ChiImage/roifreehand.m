function varargout = roifreehand(varargin)

% roifreehand  Freehand region of interest (ROI)
% 
% Syntax
%   roi = roifreehand();
%   [roi,mask] = roifreehand();
%
% Description
%   roi = roifreehand() allows the user to draw a freehand shape on the
%   image and retain only those pixels within as a spectral collection.
%
%   [roi,mask] = roifreehand() returns the image mask of the generated
%   shape as a ChiMask.
%
% Notes
%   If an image is not currently displayed, a total signal image is used
%   (see the display function for details). 
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   roirect roipoly display crop imagesc.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


if ~nargout
    err = MException(['CHI:',mfilename,':IOError'], ...
        'Nowhere to put the output. Try something like: myroi = %s();',mfilename);
    throw(err);
end
    
this = varargin{1};

    % Determine the current figure window or create one
    fig = get(groot,'CurrentFigure');
    if isempty(fig)
        fig = this.display();
    end
    
    % Allow the user to draw a shape on the figure
    shape = imfreehand(fig.CurrentAxes);
    if ~isempty(shape)
        % The user drew a shape so remove all pixels outside it. 
        pixelmask = shape.createMask();
        
        mask = ChiMask(pixelmask);
        
        if (mask.numtrue == 0)
            err = MException(['CHI:',mfilename,':IOError'], ...
            'No region selected.');
            throw(err);
        end

        obj = this.applymask(mask);
        
        historyString = 'ROI selection using freehand shape';
        obj.history.add(historyString);
        mask.history.add(historyString);
        this.history.add(historyString);
        if ~isempty(this.filenames{1})
            historyString = ['Pixels extracted from: ', this.filenames{1}];
            obj.history.add(historyString);
            mask.history.add(historyString);
        end
        
        varargout{1} = obj.clone;
        varargout{2} = mask.clone;
            
    end
    
end % function
