function varargout = plotsegments(varargin)

% MATLAB plot syntax                            Implemented here
% plot(X,Y)                                     OK
% plot(X,Y,LineSpec)                            OK
% plot(X1,Y1,...,Xn,Yn)                         Not handled
% plot(X1,Y1,LineSpec1,...,Xn,Yn,LineSpecn)     Not handled
% plot(Y)                                       Not possible
% plot(Y,LineSpec)                              Not possible
% plot(___,Name,Value)                          OK
% plot(ax,___)                                  OK
% h = plot(___)                                 OK

% A continuous function is required, either linear or quadratic. 

%% Get required axes
argposition = find(cellfun(@(x) isa(x,'matlab.graphics.axis.Axes') , varargin));
if argposition
    % Remove the parameters from the argument list
    ax = varargin{argposition};
    varargin(argposition) = [];
else
    ax = gca;
end

%% Get form of x-axis: linear or quadratic
linearity = 'unknown';

% Do we have a linearity argument?
argposition = find(cellfun(@(x) isa(x, 'ChiAbscissaOrder') , varargin));
if argposition
    switch varargin{argposition}
        case ChiAbscissaOrder.linear
            linearity = 'linear';
        case ChiAbscissaOrder.quadratic
            linearity = 'quadratic';
        otherwise
            err = MException('CHI:ChiSpectralCollection:InputError', ...
                'Input not understood. Check linearity.');
            throw(err);
    end
    varargin(argposition) = [];
end

% Has the user supplied the answer?
argposition = find(cellfun(@(x) strcmpi(x, 'linear') , varargin));
if argposition
    linearity = varargin{argposition};
    varargin(argposition) = [];
end
% Check for quadratic shape
argposition = find(cellfun(@(x) strcmpi(x, 'quadratic') , varargin));
if argposition
    linearity = varargin{argposition};
    varargin(argposition) = [];
end

% If we still don't know, calculate the linearity ourselves
if strcmpi(linearity, 'unknown')
    linearity = calclinearity(varargin{1});
end

%% Get colour the line(s) should be drawn in
RequestedColorOrderIndex = 1;
argposition = find(cellfun(@(x) strcmpi(x, 'colouridx') , varargin));
if argposition
    RequestedColorOrderIndex = varargin{argposition + 1};
    varargin(argposition + 1) = [];
    varargin(argposition) = [];
end

% Also check for US spelling of colour. 
% I blame Noah Webster. Why didn't he change his name to Noa?
argposition = find(cellfun(@(x) strcmpi(x, 'coloridx') , varargin));
if argposition
    RequestedColorOrderIndex = varargin{argposition + 1};
    varargin(argposition + 1) = [];
    varargin(argposition) = [];
end

%% Extract the X and Y values
x = varargin{1};
varargin(1) = [];

if ~isempty(varargin)
   y = varargin{1};
   varargin(1) = [];
else
    error('Need X-Y pairs to enable segment determination');
end

%% Double-check we can handle this plot syntax 
if ~isnumeric(y)
    error('Need X-Y pairs to enable segment determination');
end

%% Determine the segments in the data
[segments, numsegments] = utilities.segmenter(x,linearity);

%% Do the plotting of each segment in turn
handles = cell(1,numsegments);

if (numsegments == 1)
    % We only have a single segment, so just plot as usual
    handles{1,1} = utilities.plotformatted(ax,x,y,varargin{:});
else
    for seg = 1:numsegments
        % Reset the line colours so they match each segment, or user
        % preference
        ax.ColorOrderIndex = RequestedColorOrderIndex;
        hold on
        handles{1,seg} = utilities.plotformatted(ax, x(segments(seg,1):segments(seg,2)), y(:,segments(seg,1):segments(seg,2)), varargin{:});
    end
    hold off
end

%% Manage return variables, if requested
if nargout
    varargout{1} = handles;
end

end % function plotsegments

%% ========================================================================
%  ========================================================================
function linearity = calclinearity(x)

% Here we fit two curves to the x axis values: linear and quadratic.
% Then we calculate the estimated results given those models.
% We determine the RMSE of each estimated fit to the actual x values.
% Whichever RMSE value is the lowest is likely to be the actual shape of
% the curve.

[linear_model,lin_S,lin_mu] = polyfit(1:length(x),x,1); 
x_hat_lin = polyval(linear_model, 1:length(x), lin_S, lin_mu);
rmse_1in = sqrt(mean((x - x_hat_lin).^2));

[quadratic_model,quad_S,quad_mu] = polyfit(1:length(x),x,2);
x_hat_quad = polyval(quadratic_model, 1:length(x), quad_S, quad_mu);
rmse_quad = sqrt(mean((x - x_hat_quad).^2));

if (rmse_1in < rmse_quad)
    linearity = 'linear';
else
    linearity = 'quadratic';
end

end     % function calclinearity
