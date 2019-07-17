function varargout = compare(this,varargin)

% compare  Performs a cosine match of each iteration against the final corrected data
%
% Syntax
%   output = compare();
%   output = compare(which);
%   output = compare(____,'nofig');
%
% Description
%   output = compare() performs a comparison of the original data*, and
%   each iteration, against the final corrected data. If the original data
%   is a ChiIRSpectralCollection, the first spectrum is used. For a
%   ChiImage this is the top, left pixel. output is a two column matrix
%   where the first column is the iteration number (zero for the origianl
%   data*). The second column is the comparison value. See below for
%   details. A figure is produced showing the trend of subsequent
%   iterations. 
% 
%   output = compare(which) performs the comparison using the chosen
%   spectrum 'which'. For a ChiSpectrum this has no effect. 
% 
%   output = compare(____,'nofig') perform the comparison, but does not
%   generate the figure. 
% 
% Notes
%   The comparison method is a cosine match, sometimes called the dot
%   product. Here we consider each spectrum as a vector and measure the
%   angle between them. The output is the cosine of this angle. Therefore,
%   if two spectra are very similar they will have a small vector angle and
%   consequently a cosine match of near 1. A paper discussing this is
%     'Optimization and Testing of Mass Spectral Library Search Algorithms
%     for Compound Identification' by S.E. Stein and D.R. Scott 
%     Journal of the American Society for Mass Spectrometry 5 (1994) 
%      859-866 DOI: 10.1016/1044-0305(94)87009-8
% 
%   We compare each iteration against the final, corrected spectrum. In
%   addition we compare the original data against the final corrected
%   spectrum and call this iteration 0. In order to compare the original
%   data with the corrected data it is necessary to perform the same
%   pre-processing steps used by the RMieS correction, stopping before the
%   first Mie correction step. Therefore iteration 0 is slightly modified
%   with respect to the original data.
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   utilities.cosinematch rmies

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox
    
    
%% Which spectrum should we use to match against?
which = 0;
argposition = find(cellfun(@(x) isnumeric(x) , varargin));
if argposition
    % We have one or more spectra selected
    if (length(argposition) == 1)
        % A single spectrum was selected
        which = varargin{argposition};
    else
        % We have multiple spectra selected, or co-ordinates in an image
        if isa(this.iteration{1},'ChiImage')
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
        if ~isa(this.iteration{1},'ChiSpectrum') 
            utilities.warningnobacktrace('Using first spectrum in collection');
        end
    end
end

%% Do we need a figure?
showfigure = true;
argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    showfigure = false;
    varargin(argposition) = [];
end

%% Anything left over?
if ~isempty(varargin)
    err = MException(['CHI:',mfilename,':UnknownInput'], ...
        ['Unrecognised input: ',utilities.tostring(varargin{1}) ,'.']);
    throw(err);
end    
    
%% Do the comparison    
    numiter = this.numiterations;
    numchans = this.iteration{1}.numchannels;

    % Build a raw space for the iteration results. 
    % The first spectrum will be the original. 
    library = zeros(numiter+1,numchans);
        
    if isa(this.iteration{1},'ChiSpectrum')

        % Insert the original data into the library
        library(1,:) = this.original.data;
        
        % Populate this library with the iteration spectra
        for i = 1:numiter
            library(i+1,:) = this.iteration{i}.data;
        end

        % Extract the data from the last iteration
        finalspectrum = this.iteration{end}.data;
            
        % Do a cosine match
        result = utilities.cosinematch(library,finalspectrum);
        
    else
        % We have a spectral collection, or image, so identify the
        % requested spectrum within that collection for comparison

        % Insert the original data into the library
        library(1,:) = this.original.spectrumat(which).data;
        
        % Populate this library with the iteration spectra
        for i = 1:numiter
            library(i+1,:) = this.iteration{i}.spectrumat(which).data;
        end

        % Extract the data from the last iteration
        finalspectrum = this.iteration{end}.spectrumat(which).data;
            
        % Do a cosine match
        result = utilities.cosinematch(library,finalspectrum);
        
    end
    
    % Collect the output
    output = zeros(numiter+1,2);
    output(:,1) = 0:numiter;
    output(:,2) = result;

    % Display figure unless 'nofig' supplied by user
    if showfigure
        figure;
        plot(output(:,1),output(:,2),'o-');
        xticks(output(:,1));
        xlabel('RMieS iteration number');
        ylabel('cosine of vector angle');
        titletext = 'Cosine match of each iteration versus the final iteration';
        if ~isa(this.iteration{1},'ChiSpectrum')
            legend(['spectrum ',num2str(which)],'location','best');
        end
        title(titletext);
    end
    
    % Return results if requested
    if narargout
        varargout{1} = output;
    end
    
end
