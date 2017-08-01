function plotspectrum(this,varargin)

% plotspectrum  Plots one or more spectra. Multiple spectra are overlaid. 
%
% Syntax
%   plotspectrum();
%   plotspectrum('nofig');
%   plotspectrum(____,Function);
%   plotspectrum(____,'grouped',Function);
%
% Description
%   plotspectrum() creates a 2-D line plot of the ChiSpectrum, or
%   ChiSpectralCollection, object in a new figure window.
%
%   plotspectrum('nofig') plots the spectrum in the currently active figure
%   window, or creates a new figure if none is available.
%
%   plotspectrum(____,Function) plots the spectra in a range of different
%   ways depending on the value of Function:
%     'mean' plots the mean of the spectra
%     'sum' plots the sum of the spectra
%     'median' plots the median of the spectra
%     'std' plots the mean of the spectra, with the standard deviation
%     of the spectra shown in a shaded region
% 
%   plotspectrum(____,'grouped',Function) plots the spectra in a range of
%   different ways depending on the value of Function:
%     'mean' plots the mean of the spectra in each class
%     'sum' plots the sum of the spectra in each class
%     'median' plots the median of the spectra in each class
%     'std' plots the mean of the spectra in each class, with the
%     standard deviation of the spectra shown in a shaded region
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot function for more details. 
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot shadedErrorBar ChiSpectrum ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
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

%% Determine what the user asked for
plottype = 'normal';
grouped = false;

argposition = find(cellfun(@(x) strcmpi(x, 'mean') , varargin));
if argposition
    varargin(argposition) = [];
    plottype = 'mean';
end

argposition = find(cellfun(@(x) strcmpi(x, 'sum') , varargin));
if argposition
    varargin(argposition) = [];
    plottype = 'sum';
end

argposition = find(cellfun(@(x) strcmpi(x, 'median') , varargin));
if argposition
    varargin(argposition) = [];
    plottype = 'median';
end

argposition = find(cellfun(@(x) strcmpi(x, 'std') , varargin));
if argposition
    varargin(argposition) = [];
    plottype = 'std';
end

argposition = find(cellfun(@(x) strcmpi(x, 'grouped') , varargin));
if argposition
    varargin(argposition) = [];
    grouped = true;
end

%% Do the plotting
if ~grouped
    % Not grouped
    switch plottype
        case 'mean'
            % Plot the mean of the entire data set
            plot(this.xvals,mean(this.data),varargin{:});
        case 'sum'
            % Plot the sum of the entire data set
            plot(this.xvals,sum(this.data),varargin{:});
        case 'median'
            % Plot the sum of the entire data set
            plot(this.xvals,median(this.data),varargin{:});
        case 'std'
            % Plot the mean with the standard deviation plotted as a shaded
            % overlay. 
            colours = get(gca,'colororder');
            toplot = this.data;
            shadedErrorBar(this.xvals,mean(toplot),std(toplot),{'Color',colours(1,:)},1);
        otherwise
            % Plot all the spectra
            plot(this.xvals,this.data,varargin{:});
    end
else
    % grouped
    if isempty(this.classmembership)
        warning('backtrace','off');
        warning('Plot ''grouped'' requested, but classmembership is missing. Applying function to entire data set.');
        warning('backtrace','on');
        % Plot normally since there is no grouping available
        switch plottype
            case 'mean'
                % Plot the mean of the entire data set
                plot(this.xvals,mean(this.data),varargin{:});
            case 'sum'
                % Plot the sum of the entire data set
                plot(this.xvals,sum(this.data),varargin{:});
            case 'median'
                % Plot the sum of the entire data set
                plot(this.xvals,median(this.data),varargin{:});
            case 'std'
                % Plot the mean with the standard deviation plotted as a
                % shaded overlay.
                colours = get(gca,'colororder');
                toplot = this.data;
                shadedErrorBar(this.xvals,mean(toplot),std(toplot),{'Color',colours(1,:)},1);
            otherwise
                % Plot all the spectra
                plot(this.xvals,this.data,varargin{:});
        end
    else
        % Grouping selected and classmembership available
        switch plottype
            case 'mean'
                % Each class is averaged and plotted with a different
                % colour
                hold on;
                for i = 1:this.classmembership.numuniquelabels
                    toplot = this.data(this.classmembership.labelids == i,:);
                    plot(this.xvals,mean(toplot),varargin{:});
                end
                hold off;
            case 'sum'
                % Each class is summed and plotted with a different colour
                hold on;
                for i = 1:this.classmembership.numuniquelabels
                    toplot = this.data(this.classmembership.labelids == i,:);
                    plot(this.xvals,sum(toplot),varargin{:});
                end
                hold off;
            case 'median'
                % Each class is summed and plotted with a different colour
                hold on;
                for i = 1:this.classmembership.numuniquelabels
                    toplot = this.data(this.classmembership.labelids == i,:);
                    plot(this.xvals,median(toplot),varargin{:});
                end
                hold off;
            case 'std'
                % Each class is averaged and plotted with a different
                % colour. The standard deviation is plotted as a shaded
                % overlay. 
                colours = get(gca,'colororder');
                numcolours = size(colours,1);
                c = 1;
                hold on;
                for i = 1:this.classmembership.numuniquelabels
                    toplot = this.data(this.classmembership.labelids == i,:);
                    colour = colours(c,:);
                    if (c == numcolours)
                        c = 1;
                    else
                        c = c + 1;
                    end
                    shadedErrorBar(this.xvals,mean(toplot),std(toplot),{'Color',colour},1);
                end
                hold off;
            otherwise
                % Spectra belonging to the same class are plotted with the same colour
                colours = get(gca,'colororder');
                numcolours = size(colours,1);
                c = 1;
                hold on;
                for i = 1:this.classmembership.numuniquelabels
                    toplot = this.data(this.classmembership.labelids == i,:);
                    colour = colours(c,:);
                    if (c == numcolours)
                        c = 1;
                    else
                        c = c + 1;
                    end
                    plot(this.xvals,toplot,'Color',colour,varargin{:});
                end
                hold off;
        end
    end
            
end
    
axis tight;
if this.reversex
    set(gca,'XDir','reverse');
end
if ~isempty(this.xlabel)
    set(get(gca,'XLabel'),'String',this.xlabel);
end
if ~isempty(this.ylabel)
    set(get(gca,'YLabel'),'String',this.ylabel);
end

end
