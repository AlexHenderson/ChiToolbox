function varargout=shadedErrorBarSegmented(x,y,errBar,varargin)
% generate continuous error bar area around a line plot
%
% function H=shadedErrorBarSegmented(x,y,errBar, ...)
%
% Purpose 
% Makes a 2-d line plot with a pretty shaded error bar made
% using patch. Error bar color is chosen automatically.
%
%
% Inputs (required)
% x - vector of x values [optional, can be left empty]
% y - vector of y values or a matrix of n observations by m cases
%     where m has length(x);
% errBar - if a vector we draw symmetric errorbars. If it has a size
%          of [2,length(x)] then we draw asymmetric error bars with
%          row 1 being the upper bar and row 2 being the lower bar
%          (with respect to y -- see demo). ** alternatively ** 
%          errBar can be a cellArray of two function handles. The 
%          first defines statistic the line should be and the second 
%          defines the error bar.
%
% Inputs (optional, param/value pairs)
% 'lineProps' - ['-k' by default] defines the properties of
%             the data line. e.g.:    
%             'or-', or {'-or','markerfacecolor',[1,0.2,0.2]}
% 'transparent' - [true  by default] if true, the shaded error
%               bar is made transparent. However, for a transparent
%               vector image you will need to save as PDF, not EPS,
%               and set the figure renderer to "painters". An EPS 
%               will only be transparent if you set the renderer 
%               to OpenGL, however this makes a raster image.
% 'patchSaturation'- [0.2 by default] The saturation of the patch color.
% 'linearity'- ['linear' by default] Whether the x-axis is linear or
%               quadratic. Options are 'linear' or 'quadratic'. 
%
% Outputs
% H - a structure of handles to the generated plot objects.
% handles - a structure of handles to the generated plot objects for each
%           segment
%
%
% Examples:
% y=randn(30,80); 
% x=1:size(y,2);
%
% 1)
% shadedErrorBar(x,mean(y,1),std(y),'lineProps','g');
%   If there are 'gaps' in the x-axis, the data will be plotted in
%   segments. This assumes the x-axis to be linear, which it is in this
%   case. If the x-axis were to be quadratic, use the 'quadratic' flag
%   shadedErrorBar(x,mean(y,1),std(y),'lineProps','g', 'quadratic');
% 
% 2)
% shadedErrorBar(x,y,{@median,@std},'lineProps',{'r-o','markerfacecolor','r'});
%
% 3)
% shadedErrorBar([],y,{@median,@(x) std(x)*1.96},'lineProps',{'r-o','markerfacecolor','k'});
%
% 4)
% Overlay two transparent lines:
% clf
% y=randn(30,80)*10; 
% x=(1:size(y,2))-40;
% shadedErrorBar(x,y,{@mean,@std},'lineProps','-r','transparent',1);
% hold on
% y=ones(30,1)*x; y=y+0.06*y.^2+randn(size(y))*10;
% shadedErrorBar(x,y,{@mean,@std},'lineProps','-b','transparent',1);
% hold off
% 
% Main code: Rob Campbell - November 2009
% Segmented plots added by Alex Henderson (alex.henderson@manchester.ac.uk), 2021


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parse input arguments
narginchk(3,inf)

params = inputParser;
params.CaseSensitive = false;
params.addParameter('lineProps', '-k', @(x) ischar(x) | iscell(x));
if (sum( size(ver('MATLAB'))) > 0  )
  params.addParameter('transparent', true, @(x) islogical(x) || x==0 || x==1);
elseif (sum( size(ver('Octave'))) > 0  )
  params.addParameter('transparent', false, @(x) islogical(x) || x==0 || x==1);
end
params.addParameter('patchSaturation', 0.2, @(x) isnumeric(x) && x>=0 && x<=1);

% Added options for segmentation of linear or quadratic x-axis data
linearityOptions = {'linear','quadratic'};
linearityDefault = 'linear';
params.addParameter('linearity', linearityDefault, @(x) any(validatestring(x,linearityOptions)));

params.parse(varargin{:});

%Extract values from the inputParser
lineProps =  params.Results.lineProps;
transparent =  params.Results.transparent;
patchSaturation = params.Results.patchSaturation;

linearity = params.Results.linearity;

if ~iscell(lineProps), lineProps={lineProps}; end


%Process y using function handles if needed to make the error bar dynamically
if iscell(errBar) 
    fun1=errBar{1};
    fun2=errBar{2};
    errBar=fun2(y);
    y=fun1(y);
else
    y=y(:).';
end

if isempty(x)
    x=1:length(y);
elseif sum( size(ver('MATLAB'))) > 0 
    x=x(:).';
end


%Make upper and lower error bars if only one was specified
if length(errBar)==length(errBar(:))
    errBar=repmat(errBar(:)',2,1);
else
    s=size(errBar);
    f=find(s==2);
    if isempty(f), error('errBar has the wrong size'), end
    if f==2, errBar=errBar'; end
end


% Check for correct x, errbar formats
x_size = size(x);

if (length(x) ~= length(errBar) && sum( size(ver('MATLAB'))) > 0 )
    error('length(x) must equal length(errBar)')
elseif( ( length(x) ~= length(errBar) && checkOctave_datestr(x) == false ) ...
            && sum( size(ver('Octave'))) > 0  )
    error('length(x) must equal length(errBar) or x must have valid datestr')
end


% Generate a segmented plot

%Log the hold status so we don't change
initialHoldStatus=ishold;
if ~initialHoldStatus, hold on,  end

% Determine the segments in the data
[segments, numsegments] = segmenter(x,linearity);

% Do the plotting of each segment in turn
handles = cell(1,numsegments);

if (numsegments == 1)
    % We only have a single segment, so just plot as usual
    handles{1,1} = makePlot(x,y,errBar,lineProps,transparent,patchSaturation);
else
    % Draw each segment in turn and record each set of handles 
    for seg = 1:numsegments
        hold on
        handles{1,seg} = makePlot(x(segments(seg,1):segments(seg,2)),y(segments(seg,1):segments(seg,2)),errBar(:,segments(seg,1):segments(seg,2)),lineProps,transparent,patchSaturation);
    end
    hold off
end

if ~initialHoldStatus, hold off, end

if nargout
    % Return a list of handles to the first segment 
    % to match Rob Campbell's original function
    varargout{1} = handles{1};
    % Optionally return handles to all the line segments
    if (nargout > 2)
        varargout{2} = handles;
    end
end

end % function shadedErrorBar


function H = makePlot(x,y,errBar,lineProps,transparent,patchSaturation)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Determine host application
    if (sum( size(ver('MATLAB'))) > 0  )
      hostName = 'MATLAB';
    elseif (sum(size(ver('Octave'))) > 0)
      hostName = 'Octave';
    end % if
    
    % Plot to get the parameters of the line
    if strcmpi(hostName,'MATLAB')
      H.mainLine=plot(x,y,lineProps{:});
      
    elseif strcimpi(hostName,'Octave')
      boolxDatestr = checkOctave_datestr(x);
      if boolxDatestr
        x = datenum(x);
        x = x(:).';
        H.mainLine=plot(x,y,lineProps{:});
        datetick(gca);
      else
        H.mainLine=plot(x,y,lineProps{:});
      end
    end


    % Tag the line so we can easily access it
    H.mainLine.Tag = 'shadedErrorBar_mainLine';


    % Work out the color of the shaded region and associated lines.
    % Here we have the option of choosing alpha or a de-saturated
    % solid colour for the patch surface.
    mainLineColor=get(H.mainLine,'color');
    edgeColor=mainLineColor+(1-mainLineColor)*0.55;

    if transparent
        faceAlpha=patchSaturation;
        patchColor=mainLineColor;
    else
        faceAlpha=1;
        patchColor=mainLineColor+(1-mainLineColor)*(1-patchSaturation);
    end


    %Calculate the error bars
    uE=y+errBar(1,:);
    lE=y-errBar(2,:);


    %Make the patch (the shaded error bar)
    yP=[lE,fliplr(uE)];
    xP=[x,fliplr(x)];

    %remove nans otherwise patch won't work
    xP(isnan(yP))=[];
    yP(isnan(yP))=[];
    

    if isdatetime(x) && strcmpi(hostName,'MATLAB')
      H.patch=patch(datenum(xP),yP,1);
    else
      H.patch=patch(xP,yP,1);
    end


    set(H.patch,'facecolor',patchColor, ...
        'edgecolor','none', ...
        'facealpha',faceAlpha, ...
        'HandleVisibility', 'off', ...
        'Tag', 'shadedErrorBar_patch')


    %Make pretty edges around the patch. 
    H.edge(1)=plot(x,lE,'-');
    H.edge(2)=plot(x,uE,'-');

    set([H.edge], 'color',edgeColor, ...
      'HandleVisibility','off', ...
      'Tag', 'shadedErrorBar_edge')


    % Ensure the main line of the plot is above the other plot elements
    if strcmpi(hostName,'MATLAB')
      if strcmp(get(gca,'YAxisLocation'),'left') %Because re-ordering plot elements with yy plot is a disaster
        uistack(H.mainLine,'top')
      end
    elseif strcmpi(hostName, 'Octave')
      % create the struct from scratch by temp.
      H = struct('mainLine', H.mainLine, ...
      'patch', H.patch, ...
      'edge', H.edge);
    end

end % function makePlot

function boolDate = checkOctave_datestr(x)
  %% Simple try/catch for casting datenums, requireing valid datestr
  boolDate = true;
  try
    datenum(x)
  catch
    boolDate = false;
  end
  
end % function checkOctave

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
function varargout = segmenter(xvals, varargin)

% segmenter  Identifies segments of a smooth continuous function.
%
% Syntax
%   [segments, numsegments] = segmenter(xvalues);
%   [segments, numsegments] = segmenter(xvalues, linearity);
%
% Description
%   [segments, numsegments] = segmenter(xvalues) determines segments of the
%   xvalues row vector. xvalues is a row vector representing a smooth
%   continuous function that has some break points. segments is a two
%   column matrix. Each row of segments represents the begining and end
%   index values of the segment. numsegments is a scalar indicating the
%   number of segments found.
% 
%   [segments, numsegments] = segmenter(xvalues, linearity) determines
%   segments of the xvalues row vector. linearity can be either 'linear' or
%   'quadratic'. See below for more details. 
% 
% Notes
%   This function attempts to manage the scenario where a region of the
%   spectrum (or spectra, if we have a matrix) has one or more points
%   missing. MATLAB's plot function simply joins the ends of these spectral
%   ranges with a straight line. However, this can be misleading. We
%   really want to show a break in the spectra to indicate the location of
%   the 'missing' data points. 
%   Therefore, this code is 'tuned' to work on a list of data points that
%   are either the same distance apart (a linear vector), or where the
%   points follow a quadratic relationship. Other data point separations
%   will probably not work correctly. No checks are made to determine
%   whether the input is linear, quadratic, or some other format. 
%   The code determines whether there is a break (disjoint) in the vector
%   if it finds a spacing over 1.5 times the typical spacing. The typical
%   spacing is determined using the first derivative for linear data, or
%   the second derivative for quadratic data. 
%   If there are a very large number of missing data points, the algorithm
%   will probably fail since that is leaning towards randomly positioned
%   data. 
%
% Copyright (c) 2021, Alex Henderson.
% Licenced under the GNU Lesser General Public License (LGPL) version 3.
%
% See also 
%   plot diff

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU Lesser General Public License (LGPL) version 3
% http://www.gnu.org/copyleft/lgpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on GitHub
% https://github.com/AlexHenderson/shadedErrorBar
% https://github.com/AlexHenderson/ChiToolbox


% Get form of x-axis: linear, or quadratic
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
% reason for using the mode to determine the most frequently occuring
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
% Here 'too large' means over 1.5 times the most frequently occurring
% separation
mostcommondifference = mode(difference);
disjoints = find(difference > (1.5 * mostcommondifference));

% If we have quadratic data we use the second derivative. Therefore the
% index values of the disjoints are displaced by 1. 
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

end % function segmenter
