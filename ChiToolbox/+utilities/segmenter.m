function varargout = segmenter(xvals, varargin)


% Get form of x-axis: linear or quadratic
% Default to linear
xshape = 'linear';
argposition = find(cellfun(@(x) strcmpi(x, 'linear') , varargin));
if argposition
    xshape = varargin{argposition};
    varargin(argposition) = [];
end
% Check for quadratic shape
argposition = find(cellfun(@(x) strcmpi(x, 'quadratic') , varargin));
if argposition
    xshape = varargin{argposition};
    varargin(argposition) = []; %#ok<NASGU>
end

% Initialise segments. 
% We don't know how many we need, so just start with one
segments = zeros(1,2); % start -> end

% Determine the steps between the x-axis data points
% Default is linear
% For a linear axis the separation between the data points is roughly
% constant, so diff returns (almost exactly) the same value if there are no
% break points. If the x-axis is quadratic (for example in ToF-SIMS data,
% where the x-axis is linear in time, but quadratic in mass) we will have a
% slowly varying separation between the points. However, in a second order
% diff, these are (roughly) the same size. 
% I say 'roughly' because we're comparing floating point numbers, so the
% separations may not be EXACTLY the same, but VERY CLOSE. This is the
% reason for using the mode to determine the most frequently occurring
% data point separation, rather than specifying a particular value. 
switch lower(xshape)
    case 'linear'
        difference = diff(xvals,1);
    case 'quadratic'
        difference = diff(xvals,2);
    otherwise
        error('');
end        

% Find any separations that appear to be too large. 
% Here 'too large' means over 1.5 times the most frequently occuring
% separation
mostcommondifference = mode(difference);
disjoints = find(difference > (1.5 * mostcommondifference));

% If we have quadratic data we use the second derivative. Therefore the
% index values of teh disjoints are displaced by 1. 
if strcmpi(xshape, 'quadratic')
    disjoints = disjoints + 1;
end

% 'Begin at the beginning' (Lewis Carroll, Alice in Wonderland)
% Since any data cropped from the start of the spectra will not be present,
% the first data point must be the start of the first segment. 
segmentstart = 1;
for d = 1:length(disjoints)
    segmentstop = disjoints(d);
    segments(d,1) = segmentstart;
    segments(d,2) = segmentstop;
    segmentstart = segmentstop + 1; % Move to the start of the next segment
end

% Append the segment that starts at the last disjoint and continues to the
% end of the x-axis
segments(d+1,1) = segmentstart;
segments(d+1,2) = length(xvals);

%% Manage outputs
switch nargin
    case 1
        varargout{1} = segments;
    case 2
        varargout{1} = segments;
        varargout{2} = size(segments,1);    % Number of segments
end

end % function
