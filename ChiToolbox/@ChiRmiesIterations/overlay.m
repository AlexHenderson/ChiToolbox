function overlay(this,varargin)

% overlay  Plots the evolution of the correction as a function of iteration
%
% Syntax
%   overlay();
%   overlay(which);
%   overlay(____,'nofig');
%   overlay(____,'offset',offset);
%
% Description
%   overlay() produces a plot of the corrected spectra as a function of
%   iteration number. The original data* s included for cvomparison. 
%   If the original data is a ChiIRSpectralCollection, the first spectrum
%   is used. For a ChiImage this is the top, left pixel.
% 
%   overlay(which) produces a plot using the chosen spectrum 'which'. For a
%   ChiSpectrum this has no effect.
% 
%   overlay(____,'nofig') produces a plot in the current active figure, or
%   creates a new figure if none is available
% 
%   overlay(____,'offset',offset) produces a plot where the spectra are
%   offset by adding the value offset to each spectrum in turn.
% 
% Notes
%   In order to plot the original data with the corrected data it is
%   necessary to perform the same pre-processing steps used by the RMieS
%   correction, stopping before the first Mie correction step. Therefore
%   iteration 0 is slightly modified with respect to the original data.
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   compare rmies

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox
    
    
%% Is an offset requested
% Needs to be run before the test for 'which' to absorb any offset value
% before determining which spectrum to manage
offset = 0;
argposition = find(cellfun(@(x) strcmpi(x, 'offset') , varargin));
if argposition
    offset = varargin{argposition+1};
    varargin(argposition+1) = [];
    varargin(argposition) = [];
end

%% Which spectral series should we use?
which = 0;
argposition = find(cellfun(@(x) isnumeric(x) , varargin));
if argposition
    % We have one or more spectra selected
    if (length(argposition) == 1)
        % A single spectrum was selected
        which = varargin{argposition};
    else
        % We have multiple spectra selected, or co-ordinates in an image
        if isa(this.iterations{1},'ChiImage')
            % We have an image, so co-ordinates are OK. Work out where
            % they point to in the data matrix. The user supplies (x,y), so
            % need to remember to swap the values to provide y first. 
            which = sub2ind([this.height,this.width],varargin{argposition(2)},varargin{argposition(1)}); % user supplies x,y
        else
            % Sorry, but we can only handle a single spectrum for comparison
            err = MException(['CHI:',mfilename,':UnknownInput'], ...
                'Multiple spectral identfiers were supplied, but data is not an image.');
            throw(err);
        end
            
    end
    varargin(argposition) = [];
else
    % Set a default of the first spectrum and warn the user if appropriate
    if ~which
        which = 1;
        if ~isa(this.iterations{1},'ChiSpectrum') 
            utilities.warningnobacktrace('Using first spectrum in collection');
        end
    end
end

%% Do we need a figure?
newfigure = true;
argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    newfigure = false;
    varargin(argposition) = [];
end

% %% Anything left over?
% if ~isempty(varargin)
%     err = MException(['CHI:',mfilename,':UnknownInput'], ...
%         ['Unrecognised input: ',utilities.tostring(varargin{1}) ,'.']);
%     throw(err);
% end    
    
%% Do the comparison    
    numiter = this.numiterations;
    numchans = this.iterations{1}.numchannels;

    % Build a raw space for the iteration results. 
    % The first spectrum will be the original. 
    library = zeros(numiter+1,numchans);
        
    if isa(this.iterations{1},'ChiSpectrum')

        % Insert the original data into the library
        library(1,:) = this.original.data;
        
        % Populate this library with the iteration spectra
        for i = 1:numiter
            library(i+1,:) = this.iterations{i}.data;
        end

    else
        % We have a spectral collection, or image, so identify the
        % requested spectrum within that collection for comparison

        % Insert the original data into the library
        library(1,:) = this.original.spectrumat(which).data;
        
        % Populate this library with the iteration spectra
        for i = 1:numiter
            library(i+1,:) = this.iterations{i}.spectrumat(which).data;
        end

    end

%% Add an offset
%     range = max(max(library)) - min(min(library));
    
    addon = 0;
    for i = 1:numiter+1
%         addon = (i-1) * (range/5);
%         addon = (i-1) + offset;
        addon = addon + offset;
        library(i,:) = library(i,:) + addon;
    end
    
%% Produce the plot
    if newfigure
        figure;
    end
    ax = gca;
    plot(ax,this.iterations{1}.xvals,library,varargin{:});
    if this.iterations{1}.reversex
        set(ax,'XDir','reverse');
    end
    axis(ax,'tight');
    xlabel(this.iterations{1}.xlabel);
    ylabeltext = this.iterations{1}.ylabel;
    ylabel([ylabeltext, ' (including an offset)']);
    title('Effect of increasing iterations');
end
