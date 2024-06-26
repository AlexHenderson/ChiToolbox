function obj = peakdetect(varargin)

% peakdetect  Identifies peaks in the data.
%
% Syntax
%   peakdetect();
%   peakdetect(____,'vis');
%   peakdetect(____,'numpeaks', pks);
%   peakdetect(____,'peaktable', pktable);
%   modified = peakdetect(____);
%
% Description
%   peakdetect() detects peaks in the data and reduces the data to
%   centroids using default values (see below). 
% 
%   peakdetect(____,'vis') display a window overlaying the data with the
%   detected centroids. Default is not to display the plot. 
% 
%   peakdetect(____,'numpeaks', pks) returns a subset of the peak table
%   containing the pks most intense peaks detected. If pks == -1, all
%   detected peaks are returned. Default is 500. 
% 
%   peakdetect(____,'peaktable', pktable) uses the previously generated
%   peak table pktable to define the peak limits for these data. Peak
%   tables are available as a property of any mass spectrum, collection or
%   image where peak detection has been performed.
% 
%   modified = peakdetect(____) first creates a clone of the object, then
%   detects peaks in the clone. The original object is not modified.
%
%   Default values are:
%     gsigma = 5, the standard deviation of the Gaussian kernel function;
%     gwindow = 30, the width the Gaussian kernel function;
%     d2window = 21, the width of the second derivative window;
%     numpeaks = 500, limits detected peaks to the Nth most intense;
%
% Notes
%   The peak detection process is as follows:
%     1. The total ion spectrum is calculated. In the case of a
%        ChiSpectrum, this is simply the entire dataset;
%     2. The total ion spectrum is smoothed using a Gaussian filter kernel;
%     3. The second derivative of the smoothed spectrum is calculated;
%     4. Any positive-going features of the second derivative are discarded
%        and the derivative is inverted;
%     5. Any partial peak appearing at the beginning, or end, of the total
%        ion spectrum is discarded;
%     6. The peak limits are determined to be the non-zero regions of the
%        cropped derivative;
%     7. The peak limits are applied to the untreated total ion spectrum
%        and their centroids calculated;
%     8. The peak limits are then applied to the original data set in full
%        and the sum of the data points for each peak region is written to
%        the output object. The centroids of the peak positions in the
%        total ion spectrum become the new mass positions for each of these
%        peaks. 
%     
% Copyright (c) 2018-2023, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   utilities.centroid utilities.secondderiv.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


this = varargin{1};

if this.iscentroided
    err = MException(['CHI:', mfilename, ':InputError'], ...
        'These data have already been peak detected.');
    throw(err);
end
    
if nargout
    obj = this.clone();
    command = [mfilename, '(obj,varargin{2:end});'];
    eval(command);  
else    
    %% Set default parameters
    gsigma = 5;
    gwindow = 30;
    d2window = 21;
    numberlimit = 500;
    vis = false;
    peaktable = [];

    %% Get parameters from the user
    argposition = find(cellfun(@(x) strcmpi(x, 'peaktable') , varargin));
    if argposition
        % Remove the parameters from the argument list
        peaktable = varargin{argposition+1};
        varargin(argposition + 1) = [];
        varargin(argposition) = [];
    end
    
    argposition = find(cellfun(@(x) strcmpi(x, 'gsigma') , varargin));
    if argposition
        % Remove the parameters from the argument list
        gsigma = varargin{argposition+1};
        varargin(argposition + 1) = [];
        varargin(argposition) = [];
    end
    
    argposition = find(cellfun(@(x) strcmpi(x, 'gwindow') , varargin));
    if argposition
        % Remove the parameters from the argument list
        gwindow = varargin{argposition+1};
        varargin(argposition + 1) = [];
        varargin(argposition) = [];
    end
    
    argposition = find(cellfun(@(x) strcmpi(x, 'd2window') , varargin));
    if argposition
        % Remove the parameters from the argument list
        d2window = varargin{argposition+1};
        varargin(argposition + 1) = [];
        varargin(argposition) = [];
    end
    
    argposition = find(cellfun(@(x) strcmpi(x, 'numberlimit') , varargin));
    % Deprecated
    if argposition
        % Remove the parameters from the argument list
        numberlimit = varargin{argposition+1};
        varargin(argposition + 1) = [];
        varargin(argposition) = [];
    end

    argposition = find(cellfun(@(x) strcmpi(x, 'numpeaks') , varargin));
    if argposition
        % Remove the parameters from the argument list
        numberlimit = varargin{argposition+1};
        varargin(argposition + 1) = [];
        varargin(argposition) = [];
    end

    argposition = find(cellfun(@(x) strcmpi(x, 'numpks') , varargin));
    if argposition
        % Remove the parameters from the argument list
        numberlimit = varargin{argposition+1};
        varargin(argposition + 1) = [];
        varargin(argposition) = [];
    end

    argposition = find(cellfun(@(x) strcmpi(x, 'vis') , varargin));
    if argposition
        % Remove the parameters from the argument list
        vis = true;
        varargin(argposition) = [];
    end
    
    argposition = find(cellfun(@(x) strcmpi(x, 'viz') , varargin));
    if argposition
        % Remove the parameters from the argument list
        vis = true;
        varargin(argposition) = [];
    end
    
    if (length(varargin) > 2)
        utilities.warningnobacktrace(['Parameter ', num2str(varargin{2}), ' not understood']);
    end
    
    % peak table columns
    begincol = 1;
    endcol = 2;
    midpointcol = 3;
    centroidcol = 4;            % Channel closest to centroid
    areacol = 5;
    accuratecentroidcol = 6;    % Actual centroid assuming linear trend inside channel

    %% Identify some data to peak detect
    if isa(this, 'ChiSpectrum')
        spectrumtoworkon = this.data;
        original = this.clone();
    else
        spectrumtoworkon = mean(this.data);
        original = this.clone();
        original.mean;
    end
    
    % Ensure the spectrum we will peak detect is not sparse
    spectrumtoworkon = full(spectrumtoworkon);

    %% Apply peaklist if present
    if ~isempty(peaktable)
        numpeaks = size(peaktable,1);
    else
        %% Detect the peaks
        % Generate a Gaussian smoothing kernel
        % https://stackoverflow.com/questions/6992213/gaussian-filter-on-a-vector-in-matlab
        x = linspace(-gwindow/2, gwindow/2, gwindow);
        gaussFilter = exp(-x.^2 / (2 * gsigma^2));
        gaussFilter = gaussFilter / sum(gaussFilter);   % normalize

        % Smooth the spectrum using convolution
        convoluted = conv(spectrumtoworkon,gaussFilter,'same');

        % Take second derivative of the smoothed spectrum
        convoluted2nd = utilities.secondderiv(this.mass,convoluted,d2window);

        % Remove any positive going features
        convoluted2nd(convoluted2nd > 0) = 0;

        % Flip the derivative so the peaks point upwards
        convoluted2nd = -convoluted2nd;

        % Identify regions where the signal appears
        peakzones = logical(convoluted2nd);

        % Remove partial peaks at the start of the spectrum
        finished = false;
        idx = 1;
        while ~finished
            if (idx > length(peakzones))
                finished = true;
            else
                if peakzones(idx)
                    % on a peak, so set this channel to zero (false)
                    peakzones(idx) = false;
                else
                    % not on a peak, so we can stop now
                    finished = true;
                end
                idx = idx + 1;
            end
        end

        % Remove partial peaks at the end of the spectrum
        peakzones = fliplr(peakzones);
        finished = false;
        idx = 1;
        while ~finished
            if (idx > length(peakzones))
                finished = true;
            else
                if peakzones(idx)
                    % on a peak, so set this channel to zero (false)
                    peakzones(idx) = false;
                else
                    % not on a peak, so we can stop now
                    finished = true;
                end
                idx = idx + 1;
            end
        end
        peakzones = fliplr(peakzones);

        % Now we must have an even number of peak 'starts' and peak 'stops'

        % Identify the peak limits
        transitions = diff(peakzones);
        peakstart = find(transitions == 1) + 1;
        peakstop  = find(transitions == -1);
        numpeaks = length(peakstart);

        %% Create a location to put the results. Values are index coordinates
        peaktable = zeros(numpeaks,5);

        %% Populate the peak table
        peaktable(:,begincol) = peakstart';
        peaktable(:,endcol) = peakstop';

        % With these peak limits, identify the centres, centroids and areas
        peaktable(:,midpointcol) = round((peaktable(:,endcol) - peaktable(:,begincol)) / 2) + peaktable(:,begincol);

        for i = 1:numpeaks
            peaktable(i,centroidcol) = utilities.centroid(spectrumtoworkon,peaktable(i,begincol),peaktable(i,endcol));
            peaktable(i,areacol) = sum(spectrumtoworkon(peaktable(i,begincol):peaktable(i,endcol)),2);
        end

        %% Select the top N peaks
        if (numberlimit < 0)
            % Return all peaks
            numberlimit = numpeaks;
        end
        
        if (numberlimit < numpeaks)
            peaktable = sortrows(peaktable,areacol,'descend');
            peaktable = peaktable(1:numberlimit,:);
            peaktable = sortrows(peaktable,begincol,'ascend');
            numpeaks = numberlimit;
        end

    end
    
    %% Perform the selection across the entire data set
    datapeaks = zeros(this.numspectra,numpeaks);
    for i = 1:numpeaks
        datapeaks(:,i) = sum(this.data(:,peaktable(i,begincol):peaktable(i,endcol)),2);
    end
    this.data = datapeaks;
    this.xvals = this.xvals(peaktable(:,centroidcol));
    this.iscentroided = true;
    this.peaktable = peaktable;    
    
    %% Plot the results for the total spectrum if requested
    if vis
        original.featurenorm.plot;
        hold on
        this.featurenorm.plot('nofig','axes',gca);
        hold off

        title(['Top ', num2str(numpeaks), ' detected peaks']);
        xlabel('m/z (amu)');
        ylabel('normalised data')
        legend({'Data','Detected peaks'}, 'Location','best');
        utilities.tightxaxis;

        % Manage data cursor information
        figurehandle = gcf;
        cursor = datacursormode(figurehandle);
        set(cursor,'UpdateFcn',{@utilities.datacursor_6sf});
    end

end % new object required?

end % function
