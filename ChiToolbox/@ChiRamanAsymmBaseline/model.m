function obj = model(varargin)

% model  Asymmetric least squares baseline modelling GUI. 
%
% Syntax
%   model();
%   model(idx);
%   model(x,y);
%   model(func);
%   corrected = model(____);
%
% Description
%   model() opens a graphical interface to allow the modelling of an
%   asymmetric baseline to the data. If the dataset (parent) is a
%   SpectralCollection, or an Image then we use the median.
% 
%   model(idx) will use the spectrum defined by index number idx as the
%   example data to model (upper window).
% 
%   model(x,y) will use the pixel at coordinates (x,y) in a hyperspectal
%   image, as the example data to model. 
% 
%   model(func) accepts 'mean' or 'median' and that function is applied to
%   the data with the result used to model the data. 
% 
%   corrected = model(____) first creates a clone of the data then
%   optionally removes modelled baseline from the clone. See below for
%   details on the GUI usage. The original object retains the baseline
%   parameters, but the spectra are not modified.
% 
% GUI usage
%   The upper window shows the original data (as defined above) in blue and
%   the modelled baseline in red. The lower window shows what the data
%   would look like if the modelled baseline were removed.
% 
%   The values in the log10(Lambda), Asymmetry and Penalty boxes can be
%   altered to adjust the baseline shape. Click Update to redraw the axes
%   windows. Note that Penalty must be an integer value. 
%
%   Clicking Reset will revert the log10(Lambda), Asymmetry and Penalty
%   values to their defaults (6, 0.001 and 2 respectively). 
%
%   Clicking Subtract will fit the asymmetric least squares model to each
%   of the spectra in the data separately and then substract that modelled
%   baseline. Note that if a return value is supplied the baseline will be
%   subtracted from the cloned data, otherwise the original data will be
%   modified (see Decription above).
% 
%   Clicking the Cancel button will store the current model values, but
%   will not modify the data. If a return value is supplied this will be
%   set to an empty matrix ([]). 
%
% Notes
%   This code is based on a paper by Paul H. C. Eilers 
%   Analytical Chemistry 76 (2004) 404-411 
%   doi:https://doi.org/10.1021/ac034800e. 
%   The actual implementation is taken from
%   https://github.com/Biospec/cluster-toolbox-v2.0
% 
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   remove

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2018
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


this = varargin{1};
decided = false;

% Determine which spectrum to use as a display model
% We use a ChiRamanSpectrum to facilitate the plotting routines. 

% If we only hvae a single spectrum then we need not go any further
if isa(this.parent,'ChiSpectrum')
    this.datatomodel = this.parent;
    decided = true;
end

% If we have multiple spectra then we either need to choose one of them, or
% generate a summary of them all (mean or median). 
if ~decided
    spectrumclass = str2func(this.parent.spectrumclassname);
    switch nargin
        case 1
            % No specific data selected for model, so choose median
            this.datatomodel = spectrumclass(this.parent.xvals,median(this.parent.data),this.parent.reversex,this.parent.xlabel,this.parent.ylabel);
            utilities.warningnobacktrace('Using median of data');
            decided = true;
        case 2
            if ischar(varargin{2})
                if strcmpi(varargin{2}, 'mean')
                    this.datatomodel = spectrumclass(this.parent.xvals,mean(this.parent.data),this.parent.reversex,this.parent.xlabel,this.parent.ylabel);
                    decided = true;
                else
                    if strcmpi(varargin{2}, 'median')
                        this.datatomodel = spectrumclass(this.parent.xvals,median(this.parent.data),this.parent.reversex,this.parent.xlabel,this.parent.ylabel);
                        decided = true;
                    end
                end
            else
                if isnumeric(varargin{2})
                    this.datatomodel = this.parent.spectrumat(varargin{2});
                    decided = true;
                else
                    err = MException(['CHI:',mfilename,':InputError'], ...
                        'Cannot determine which data to model.');
                    throw(err);
                end
            end
        case 3
            if ~isa(this.parent,'ChiImage')
                err = MException(['CHI:',mfilename,':InputError'], ...
                    'Two parameters were provided for the model data, but this is not a ChiImage.');
                throw(err);
            else
                x = varargin{2};
                y = varargin{3};
                this.datatomodel = this.parent.spectrumat(x,y);
                decided = true;
            end
        otherwise
            err = MException(['CHI:',mfilename,':InputError'], ...
                'Cannot determine which data to model.');
            throw(err);
    end
end        
        
if ~decided
    err = MException(['CHI:',mfilename,':InputError'], ...
        'Cannot determine which data to model.');
    throw(err);
end


    % Default to making no change to the data
    this.acceptbaseline = false;

    % Generate a gui layout
    this.layoutgui();
    % Initialise the axes
    this.updatebutton_Callback([],[]);

    % Wait for the user to close the window, either by clicking one of 
    % Subtract/Cancel, or closing the window using the menu bar.
    waitfor(this.window);

    if this.acceptbaseline
        % The user clicked the Subtract button so remove the baseline(s)
        if nargout
            obj = this.remove();
        else
            this.remove();
        end
            
    else
        % If cancelled, then simply return an empty array
        obj = [];
    end
end
