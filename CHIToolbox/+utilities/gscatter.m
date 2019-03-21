function [fig,ax,sct,leg] = gscatter(x,y,group,varargin)

% gscatter  Grouped scatter plot.
%
% Syntax
%   [fig,ax,sct,leg] = gscatter(x,y,group);
%   [fig,ax,sct,leg] = gscatter(____, 'colours', colours);
%   [fig,ax,sct,leg] = gscatter(____, 'sizedata', sizedata);
%   [fig,ax,sct,leg] = gscatter(____, 'nofig');
%   [fig,ax,sct,leg] = gscatter(____, 'marker');
%   [fig,ax,sct,leg] = gscatter(____, 'sort');
%   [fig,ax,sct,leg] = gscatter(____, 'nolegend');
%
% Description
%   [fig,ax,sct,leg] = gscatter(x,y,group) generates a scatter plot grouped
%   by colour. group can be a cell array of strings, or a vector of numeric
%   identifiers.
%   fig is the figure handle, ax is the axis handle, sct is an array of
%   scatter plot handles, leg is a legend handle.
% 
%   [____] = gscatter(____, 'colours',colours) used the supplied colours to
%   plot the groups.  colours can be a string (for example 'rbgcmyk' or a
%   matrix of colour triplets. By default the current MATLAB colour scheme
%   is used.
% 
%   [____] = gscatter(____, 'sizedata',sizedata) plots the data at this
%   point size. Note that MATLAB's scatter function uses the square of this
%   value. Here we follow the format of the plot function. Default = 6.
% 
%   [____] = gscatter(____, 'nofig') uses the current figure is avilable,
%   otherwise a new figure is generated.
% 
%   [____] = gscatter(____, 'marker') plots each group using the
%   supplied marker. The same marker is used for each group. See the help
%   page for scatter to see the possible markers accepted. Default = '.'
%   with a sizedata default of 15 to make the dots larger.
% 
%   [____] = gscatter(____, 'sort') sorts the group labels before plotting.
%   The default is to plot each group in the order of appearance.
% 
%   [____] = gscatter(____, 'nolegend') does not display a legend on the
%   plot. The default is to show a legend in the 'best' location.
%   
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   scatter.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


%% Check the inputs

if length(x) ~= length(y)
    err = MException(['CHI:',mfilename,':IOError'], ...
        'x and y are differnet lengths.');
    throw(err);
end
    
if length(x) ~= length(group)
    err = MException(['CHI:',mfilename,':IOError'], ...
        'There must be a single group for each data point.');
    throw(err);
end

%% Some defaults
marker = '.';
sizedata = 6;
sizedatadefined = false;
showlegend = true;

%% Parse command line
% Do we need a new figure?
argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    fig = gcf;
    varargin(argposition) = [];
else
    % No 'nofig' found so create a new figure
    fig = figure;
end

% Would we like the groups sorted? 
argposition = find(cellfun(@(x) strcmpi(x, 'sort') , varargin));
if argposition
    uniquegroups = unique(group,'sort');
    varargin(argposition) = [];
else
    uniquegroups = unique(group,'stable');
end

% colours
argposition = find(cellfun(@(x) strcmpi(x, 'colours') , varargin));
if argposition
    colours = varargin{argposition+1};
    varargin(argposition+1) = [];
    varargin(argposition) = [];
else
    % Use default colormap. Can be overridden in 'colors' below. 
    colours = get(gca,'colororder');
end

% colours for the Americans ;-)
argposition = find(cellfun(@(x) strcmpi(x, 'colors') , varargin));
if argposition
    colours = varargin{argposition+1};
    varargin(argposition+1) = [];
    varargin(argposition) = [];
end

% sizedata
argposition = find(cellfun(@(x) strcmpi(x, 'sizedata') , varargin));
if argposition
    sizedata = varargin{argposition+1};
    sizedatadefined = true;
    varargin(argposition+1) = [];
    varargin(argposition) = [];
end

% legend
argposition = find(cellfun(@(x) strcmpi(x, 'nolegend') , varargin));
if argposition
    showlegend = false;
    varargin(argposition) = [];
end

% marker
argposition = find(cellfun(@(x) ischar(x) , varargin));
if argposition
    marker = varargin{argposition};
    varargin(argposition) = [];
end

% If the chosen marker is a dot and the size has not been defined, make the
% dot a bit bigger. 
if (strcmp(marker, '.') && ~sizedatadefined)
    sizedata = 15;
end

if length(varargin) %#ok<ISMT>
    utilities.warningnobacktrace('Some parameters were not used.');
end

%% Now we have a figure, we can grab the axis handle
ax = gca;

%% Check the format of colours
numcolours = 0; 
if ischar(colours)
    colours = ChiForceToColumn(colours);
    numcolours = length(colours);
    if (length(uniquegroups) > numcolours)
        utilities.warningnobacktrace('There are more groups than colours, the colours will be recycled');
        while (length(uniquegroups) > length(colours))
            colours = vertcat(colours,colours); %#ok<AGROW>
        end
    end
end

if isnumeric(colours)
    if (size(colours,2) ~= 3)
        err = MException(['CHI:',mfilename,':IOError'], ...
            'Colours should be in triplets.');
        throw(err);
    end
        
    numcolours = size(colours,1);
    if (length(uniquegroups) > numcolours)
        utilities.warningnobacktrace('There are more groups than colours, the colours will be recycled');
        while (length(uniquegroups) > size(colours,1))
            colours = vertcat(colours,colours); %#ok<AGROW>
        end
    end
    
end

if (numcolours == 0)
    err = MException(['CHI:',mfilename,':IOError'], ...
        'There is a problem with the colours.');
    throw(err);
end    

%% Do the plotting
% scatter uses a marker area in points squared, rather than plot's
% sizedata in points. Therefore, square the sizedata.
sizedata = sizedata * sizedata;

% Cycle through each group, identifying the appropriate points to plot and
% assigning them a specific colour. 
for i = 1:length(uniquegroups)
    idx = false(length(group),1);
    if iscellstr(group) %#ok<ISCLSTR>
        idx(strcmp(group, uniquegroups{i})) = true;
    else
        if isnumeric(group)
            idx(cell2mat(group) == uniquegroups{i}) = true;
        else
            if ischar(group)
                idx(strcmp(group, uniquegroups{i})) = true;
            else
                if isstring(group)
                    idx(strcmp(group, uniquegroups{i})) = true;
                end
            end
        end
    end
    
    if ischar(colours)
        sct{i} = scatter(ax,x(idx),y(idx), sizedata, colours(i), 'Marker',marker); %#ok<AGROW>
    else
        sct{i} = scatter(ax,x(idx),y(idx), sizedata, colours(i,:), 'Marker',marker); %#ok<AGROW>
    end
    
    % Add subsequent plots to this figure
    hold on;
end

% Finished with this plot, so turn hold off. 
hold off;

%% Add legend if requested
if showlegend
    leg = legend(uniquegroups,'Location','best');
else
    leg = [];
end

end
