function plotspectra(this,varargin)

% plotspectra  Plots one or more spectra. Multiple spectra are overlaid. 
%
% Syntax
%   plotspectra();
%   plotspectra(function);
%   plotspectra(____,'byclass');
%   plotspectra(____,'nofig');
%   plotspectra(____,'axes',desiredaxes);
%
% Description
%   plotspectra() creates a 2-D line plot of the ChiSpectrum, or
%   ChiSpectralCollection, object in a new figure window.
%
%   plotspectra(function) plots the spectra in a range of different ways
%   depending on the value of function:
%     'mean' plots the mean of the spectra
%     'sum' plots the sum of the spectra
%     'median' plots the median of the spectra
%     'std' plots the mean of the spectra, with the standard deviation
%     of the spectra shown in a shaded region
% 
%   plotspectra(____,'byclass') plots the spectra in a range of
%   different ways depending on the presence and/or value of function:
%     'mean' plots the mean of the spectra in each class
%     'sum' plots the sum of the spectra in each class
%     'median' plots the median of the spectra in each class
%     'std' plots the mean of the spectra in each class, with the
%     standard deviation of the spectra shown in a shaded region
%   If function is not provided, the spectra are plotted using the same
%   coloured line for each class. 
% 
%   plotspectra(____,'nofig') plots the spectra in the currently active
%   figure window, or creates a new figure if none is available.
%
%   plotspectra(____,'axes',desiredaxes) plots the spectra in the
%   desiredaxes. Defaults to gca. 
% 
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot function for more details. 
%
% Copyright (c) 2017-2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot shadedErrorBar datacursor ChiSpectrum ChiSpectralCollection gca.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 2.0, August 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox

% varargin management borrowed from here:
% https://uk.mathworks.com/matlabcentral/answers/127878-interpreting-varargin-name-value-pairs


%% Do we need a new figure?
argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
else
    % No 'nofig' found so create a new figure
    figure;
end

%% Define defaults for datacursor
plotinfo.functionplot = false;
plotinfo.byclass = false;
plotinfo.appliedfunction = '';

%% Determine what the user asked for
argposition = find(cellfun(@(x) strcmpi(x, 'mean') , varargin));
if argposition
    varargin(argposition) = [];
    plotinfo.appliedfunction = 'mean';
    plotinfo.functionplot = true;
end

argposition = find(cellfun(@(x) strcmpi(x, 'sum') , varargin));
if argposition
    varargin(argposition) = [];
    plotinfo.appliedfunction = 'sum';
    plotinfo.functionplot = true;
end

argposition = find(cellfun(@(x) strcmpi(x, 'median') , varargin));
if argposition
    varargin(argposition) = [];
    plotinfo.appliedfunction = 'median';
    plotinfo.functionplot = true;
end

argposition = find(cellfun(@(x) strcmpi(x, 'std') , varargin));
if argposition
    varargin(argposition) = [];
    plotinfo.appliedfunction = 'std';
    plotinfo.functionplot = true;
end

argposition = find(cellfun(@(x) strcmpi(x, 'byclass') , varargin));
if argposition
    varargin(argposition) = [];
    if isempty(this.classmembership)
        % Requested 'byclass', but no class information is available
        utilities.warningnobacktrace('Plot ''byclass'' requested, but classmembership is missing.');
    else
        plotinfo.byclass = true;
    end
end

argposition = find(cellfun(@(x) strcmpi(x, 'grouped') , varargin));
if argposition
    varargin(argposition) = [];
    if isempty(this.classmembership)
        % Requested 'grouped', but no class information is available
        utilities.warningnobacktrace('Plot ''grouped'' requested, but classmembership is missing.');
    else
        plotinfo.byclass = true;
    end
end

argposition = find(cellfun(@(x) strcmpi(x, 'force') , varargin));
if argposition
    % This is just to remove the 'force' term used by images in case it has
    % been added in error.
    varargin(argposition) = [];
end

%% Do the plotting
if (~isprop(this,'classmembership') || isempty(this.classmembership))
    % No class information
    plotinfo = plotnoclasses(this,plotinfo,varargin{:});
else
    % We have class information
    if plotinfo.byclass
        % We wish to plot the spectra as a function of the class
        % structure...
        plotinfo = plotwithclasses(this,plotinfo,varargin{:});
    else
        % ...but we don't have to
        plotinfo = plotwithclassesbutnotused(this,plotinfo,varargin{:});
    end

end
   
%% Prettify plot
utilities.tightxaxis();

if this.reversex
    set(gca,'XDir','reverse');
end
if ~isempty(this.xlabel)
    set(get(gca,'XLabel'),'String',this.xlabel);
end

if isempty(this.ylabel)
    ylab = 'arbitrary units';
else
    ylab = this.ylabel;
end

if plotinfo.functionplot
    % We wish to modify the y label for functions
    set(get(gca,'YLabel'),'String',[plotinfo.appliedfunction, ' of ', ylab]);
else
    set(get(gca,'YLabel'),'String',ylab);
end

%% Manage data cursor information
figurehandle = gcf;
cursor = datacursormode(figurehandle);
set(cursor,'UpdateFcn',{@utilities.datacursor,this,plotinfo});

end % function plotspectra

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function plotinfo = plotnoclasses(this,plotinfo,varargin)
% Here we plot the entire data set, or a summary based on a function. If we
% plot a summary, then we display a legend giving the function applied. If
% we plot all the spectra, there is no need for a legend. The datacursor
% cannot display class information since none is available, so display the
% function name instead. 

% Get required axes
argposition = find(cellfun(@(x) strcmpi(x, 'axes') , varargin));
if argposition
    % Remove the parameters from the argument list
    ax = varargin{argposition+1};
    varargin(argposition + 1) = [];
    varargin(argposition) = [];
else
    ax = gca;
end


if plotinfo.functionplot
    switch plotinfo.appliedfunction
        case 'mean'
            plot(ax,this.xvals,ChiMean(this.data),varargin{:});
        case 'sum'
            plot(ax,this.xvals,ChiSum(this.data),varargin{:});
        case 'median'
            plot(ax,this.xvals,ChiMedian(this.data),varargin{:});
        case 'std'
            % Plot the mean with the standard deviation plotted as a shaded
            % overlay. 
            colours = get(gca,'colororder');
%             shadedErrorBar(this.xvals,mean(this.data),std(this.data),{'Color',colours(1,:)});
            % shadedErrorBar doesn't accept an axes variable
            shadedErrorBar(this.xvals,this.data,{@ChiMean,@ChiStd},'lineprops',{'color',colours(1,:)});
            
        otherwise
            % ToDo: Correct the error code
            err = MException('CHI:ChiToolbox:UnknownInput', ...
                'Only mean, sum, median and standard deviation (std) are available.');
            throw(err);
    end
    legend(plotinfo.appliedfunction,'Location','best');
    plotinfo.linelabels = cellstr(plotinfo.appliedfunction);
else
    % Plot all the spectra, without a legend or advanced datacursor
    plot(ax,this.xvals,this.data,varargin{:});
end
    
end

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function plotinfo = plotwithclassesbutnotused(this,plotinfo,varargin)
% Plot the entire data set since we do not wish to use the class info.
% Summaries are single line plots, but if a summary isn't requested we plot
% everything. We still need the class information for the datacursor for
% the scenario where we plot everything.

% Get required axes
argposition = find(cellfun(@(x) strcmpi(x, 'axes') , varargin));
if argposition
    % Remove the parameters from the argument list
    ax = varargin{argposition+1};
    varargin(argposition + 1) = [];
    varargin(argposition) = [];
else
    ax = gca;
end

if plotinfo.functionplot
    switch plotinfo.appliedfunction
        case 'mean'
            % Plot the mean of the entire data set
            plot(ax,this.xvals,ChiMean(this.data),varargin{:});
        case 'sum'
            % Plot the sum of the entire data set
            plot(ax,this.xvals,ChiSum(this.data),varargin{:});
        case 'median'
            % Plot the sum of the entire data set
            plot(ax,this.xvals,ChiMedian(this.data),varargin{:});
        case 'std'
            % Plot the mean with the standard deviation plotted as a shaded
            % overlay. 
            colours = get(gca,'colororder');
%             shadedErrorBar(this.xvals,mean(this.data),std(this.data),{'Color',colours(1,:)},1);
            % shadedErrorBar doesn't accept an axes variable
            shadedErrorBar(this.xvals,this.data,{@ChiMean,@ChiStd},'lineprops',{'color',colours(1,:)});
        otherwise
            % ToDo: Correct the error code
            err = MException('CHI:ChiToolbox:UnknownInput', ...
                'Only mean, sum, median and standard deviation (std) are available.');
            throw(err);
    end
    legend(plotinfo.appliedfunction,'Location','best');
    plotinfo.linelabels = cellstr(plotinfo.appliedfunction);
else
    % Plot all the spectra, without a legend
    plot(ax, this.xvals,this.data,varargin{:});
    
    % Each line needs a class label for the datacursor. This is the class each
    % spectrum belongs to. The spectra are plotted in natural order, so this is
    % simply the original label list.
    labels = this.classmembership.labels;
    if isnumeric(labels)
        labels = num2str(labels);
    end
    plotinfo.linelabels = cellstr(labels);
end
    
end

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function plotinfo = plotwithclasses(this,plotinfo,varargin)
% We need to plot either a summary function per class, or all the spectra,
% coloured by the class colour. The datacursor still needs to know the
% class label of each line, either in the summary, or in the entire list.
% Unfortunately, when we group by class, the ordering of the labels
% changes.

% Get required axes
argposition = find(cellfun(@(x) strcmpi(x, 'axes') , varargin));
if argposition
    % Remove the parameters from the argument list
    ax = varargin{argposition+1};
    varargin(argposition + 1) = [];
    varargin(argposition) = [];
else
    ax = gca;
end

c = 1;
colours = get(gca,'colororder');
numcolours = size(colours,1);
legendHandles = zeros(this.classmembership.numuniquelabels,1);

hold(ax,'on');
for i = 1:this.classmembership.numuniquelabels
    spectra = this.data(this.classmembership.labelids == i,:);

    if plotinfo.functionplot
        switch plotinfo.appliedfunction
            case 'mean'
                figurehandle = plot(ax,this.xvals,ChiMean(spectra),varargin{:});
                legendHandles(i) = figurehandle(1);
            case 'sum'
                figurehandle = plot(ax,this.xvals,ChiSum(spectra),varargin{:});
                legendHandles(i) = figurehandle(1);
            case 'median'
                figurehandle = plot(ax,this.xvals,ChiMedian(spectra),varargin{:});
                legendHandles(i) = figurehandle(1);
            case 'std'
                % Each class is averaged and plotted with a different colour.
                % The standard deviation is plotted as a shaded overlay.
                colour = colours(c,:);
                % shadedErrorBar doesn't accept an axes variable
                figurehandle = shadedErrorBar(this.xvals,spectra,{@ChiMean,@ChiStd},'lineprops',{'color',colour});
                legendHandles(i) = figurehandle.mainLine;
                if (c == numcolours)
                    c = 1;  % Reset colours to the beginning
                else
                    c = c + 1;
                end
            otherwise
                % ToDo: Correct the error code
                err = MException('CHI:ChiToolbox:IOError', ...
                    'Only mean, sum, median and standard deviation (std) are available.');
                throw(err);
        end
        
    else
        % Spectra belonging to the same class are plotted with the same colour
        colour = colours(c,:);
        figurehandle = plot(ax,this.xvals,spectra,'Color',colour,varargin{:});
        legendHandles(i) = figurehandle(1);
        if (c == numcolours)
            c = 1;  % Reset colours to the beginning
        else
            c = c + 1;
        end
        
    end
end
hold(ax,'off');

% Manage the legend. This is the colours of the lines, which is the same as
% uniquelabels
if (isnumeric(this.classmembership.uniquelabels) || islogical(this.classmembership.uniquelabels))
    legend(legendHandles,cellstr(num2str(this.classmembership.uniquelabels)),'Location','best','Interpreter','none');
else
    legend(legendHandles,this.classmembership.uniquelabels,'Location','best','Interpreter','none');
end
% Each line needs a class label for the datacursor. This is the class each
% spectrum belongs to.
if plotinfo.functionplot
    % ToDo: make sure std plot works correctly
    labels = this.classmembership.uniquelabels;
    if isnumeric(labels)
        labels = num2str(labels);
    end
    plotinfo.linelabels = cellstr(labels);
else
    % The spectra are plotted in batches which means the order of lines
    % being drawn is not the same as the order of class membership labels.
    % Need to generate the correct order for the data cursor. 
    spectrumid = 1:this.numspectra;
    labels = this.classmembership.labels;
    if isnumeric(labels)
        labels = num2str(labels);
    end        
    if islogical(labels)
        labels = num2str(labels);
    end        
    plotinfo.linelabels = cell(size(spectrumid));
    plotinfo.observationnumbers = zeros(size(spectrumid));
    start = 1;
    for i = 1:this.classmembership.numuniquelabels
        plotids = spectrumid(this.classmembership.labelids == i);
        stop = start + length(plotids) - 1;
        plotinfo.linelabels(start:stop) = cellstr(labels(plotids));
        plotinfo.observationnumbers(start:stop) = plotids;
        start = stop + 1;
    end
end    

end
