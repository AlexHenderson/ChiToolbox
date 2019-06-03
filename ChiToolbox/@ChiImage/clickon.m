function varargout = clickon(this, initialxval)

% clickon  Interactive examination of a hyperspectral data set
%
% Syntax
%   [xpos,ypos] = clickon();
%   [____] = clickon(initialxval);
%
% Description
%   [xpos,ypos] = clickon() opens a figure window displaying the total
%   signal image and the total signal spectrum as separate axes. If the
%   user clicks on the image, the spectrum of that pixel is displayed. If
%   the user clicks on the spectrum, the image at that x-value is
%   displayed. 
% 
%   Press any key to exit the interactive session. 
% 
%   If the session is ended after clicking on the image, xpos and ypos
%   indicate the coordinates of the pixel that was last clicked. If the
%   session is ended after clicking on the spectrum, xpos and ypos indicate
%   the x and y values, in x-axis and y-axis units, of the location that
%   was last clicked.
% 
%   [____] = clickon(initialxval) opens the figure window to display the
%   image at the initialxval position. 
% 
% Copyright (c) 2014-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiImage

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


%% Check initial value
if exist('initialxval','var')
    if ((initialxval > max(this.xvals)) || (initialxval < min(this.xvals)))
        err = MException(['CHI:',mfilename,':OutOfRange'], ...
            'Requested initial value is out of range');
        throw(err);
    end
end
    
%% Build the figure window
figurehandle = figure('Name','Press any key to return to MATLAB','NumberTitle','off'); %#ok<NASGU>
imageaxes = subplot(2,1,1);
spectrumaxes = subplot(2,1,2);

%% Initialise the image and spectral windows
if exist('initialxval','var')
    this.rangesum(initialxval).imagesc('axes',imageaxes,'nofig');
    title(imageaxes,['Image at ', num2str(initialxval),' ', this.xlabel]);
else
    this.totalimage.imagesc('axes',imageaxes,'nofig');
    title(imageaxes,'Total signal image');
end

this.totalspectrum.plot('axes',spectrumaxes,'nofig');
title(spectrumaxes,'Total signal spectrum');

%% Loop unless the user escapes the function
button = 1; % Initialise to not a mouse button or keyboard code
leftmousebutton = 1; % MATLAB defined

while (button == leftmousebutton)

    % Grab any mouse or keyboard event
    [xlocation,ylocation,button] = ginput(1);

    % Only respond to mouse events
    if (button == leftmousebutton)
        switch gca
            case imageaxes
                xpixel = floor(xlocation);
                ypixel = floor(ylocation);
                % Only respond if the mouse was over the image
                if ((xpixel > 0) && (xpixel < this.xpixels) && ...
                    (ypixel > 0) && (ypixel < this.ypixels))
                    
                    % Update the spectrum window with this pixel's spectrum
                    this.spectrumat(xpixel,ypixel).plot('axes',spectrumaxes, 'nofig');
                    title(spectrumaxes,['x=', num2str(xpixel),' y=', num2str(ypixel)]);

                    % Record values to send to user
                    xpos = xpixel;
                    ypos = ypixel;
                end

            case spectrumaxes
                limits = axis(spectrumaxes);
                xmin = limits(1,1);
                xmax = limits(1,2);
                ymin = limits(1,3);
                ymax = limits(1,4);
                % Only respond if the mouse was over the spectrum
                if ((xlocation >= xmin) && (xlocation <= xmax) && ...
                    (ylocation >= ymin) && (ylocation <= ymax))
%                     disp(['Position: ', this.xlabel, ' = ', num2str(xlocation), ', ', this.ylabel, ' = ', num2str(ylocation)]);
                    
                    % Update the image window with this x-value
                    this.imageat(xlocation).imagesc('axes',imageaxes, 'nofig');
                    title(imageaxes,[num2str(xlocation),' ', this.xlabelunit]);
                    
                    % Record values to send to user
                    xpos = xlocation;
                    ypos = ylocation;
                end
            otherwise
                disp('unknown axes');
        end
    end    
end

%% Report mouse coordinates, if requested. 
if nargout
    varargout{1} = xpos;
    varargout{2} = ypos;
end
        
end % function

