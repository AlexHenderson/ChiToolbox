function plotscoresbyclass(this,pcx,pcy,varargin)

% plotscores  Plots principal component scores for each class separately. 
%
% Syntax
%   plotscoresbyclass(pcx,pcy);
%
% Description
%   plotscoresbyclass(pcx,pcy) creates a 2-D scatter plot of principal
%   component scores. pcx is the principal component to plot on the x-axis,
%   while pcy is the principal component to plot on the y-axis. A new
%   figure window is created for each class in addition to the overall
%   plot.
%
%   Other parameters can be applied to customise the plot. See the
%   utilities.gscatter function for more details. 
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plotscores utilities.gscatter plotloadings plotexplainedvariance
%   ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


titlestub = 'Scores on principal components ';
windowtitlestub = titlestub;
axislabelstub = 'score on PC ';
errorcode = 'CHI:ChiSpectralPCAOutcome';
errormessagestub = 'Requested principal component is out of range. Max PCs = ';

if isempty(this.classmembership)
    err = MException([errorcode,':InputError'], ...
        'No class membership is available');
    throw(err);
end

% If we have more than 1 principal component, check that the required pcs are
% in range. 
if (this.numpcs ~= 1)
    if ((pcx > this.numpcs) || (pcx < 1))
    err = MException([errorcode,':OutOfRange'], ...
        [errormessagestub, num2str(this.numpcs), '.']);
    throw(err);
    end

    if ((pcy > this.numpcs) || (pcy < 1))
    err = MException([errorcode,':OutOfRange'], ...
        [errormessagestub, num2str(this.numpcs), '.']);
    throw(err);
    end
end

if (this.numpcs > 1)
    % We can use a scatter plot...
    % Firstly draw everything, partly to grab the axis limits
    windowtitle = [windowtitlestub, num2str(pcx), ' and ' num2str(pcy)];
    figure('Name',windowtitle,'NumberTitle','off');
    colours = get(gca,'colororder');
    
    % Check the format of colours
    numcolours = size(colours,1);
    if (this.classmembership.numuniquelabels > numcolours)
        utilities.warningnobacktrace('There are more groups than colours, the colours will be recycled');
        while (this.classmembership.numuniquelabels > size(colours,1))
            colours = vertcat(colours,colours); %#ok<AGROW>
        end
    end
    
    decplaces = 3;
    
    utilities.gscatter(this.scores(:,pcx), this.scores(:,pcy), this.classmembership.labels, 'colours', colours, 'nofig', varargin{:});
    xlabel([axislabelstub, num2str(pcx), ' (', num2str(this.explained(pcx),decplaces), '%)']);
    ylabel([axislabelstub, num2str(pcy), ' (', num2str(this.explained(pcy),decplaces), '%)']);
    title([titlestub, num2str(pcx), ' and ', num2str(pcy)]);
    limits = axis;
    utilities.draw00axes(axis)
    
    % Now draw separate figures for each class
    % Could put this into a single figure, using subplot, but need to manage
    % the layout. Easiest to produce separate figures for now. 
    for i = 1:this.classmembership.numuniquelabels
        label = this.classmembership.uniquelabels{i};
        windowtitle = [windowtitlestub, num2str(pcx), ' and ' num2str(pcy), ' (', label, ')' ];
        figure('Name',windowtitle,'NumberTitle','off');

        % What are we plotting
        thisclass = (this.classmembership.labelids == i);

        % Produce the plot for this class
        utilities.gscatter(this.scores(thisclass,pcx), this.scores(thisclass,pcy), this.classmembership.labels(thisclass), 'colours', colours(i,:), 'nofig', varargin{:});
        
        % Change limits to match the overall figure for consistency
        xlim(limits(1:2));
        ylim(limits(3:4));
    
        % Labels
        xlabel([axislabelstub, num2str(pcx), ' (', num2str(this.explained(pcx),decplaces), '%)']);
        ylabel([axislabelstub, num2str(pcy), ' (', num2str(this.explained(pcy),decplaces), '%)']);
        title([titlestub, num2str(pcx), ' and ', num2str(pcy)]);
        
        % Plot the zero axis lines
        utilities.draw00axes(axis)
    end

else
    % Only a single principal component so we can use a box plot
    boxplot(this.scores, this.classmembership.labels, 'jitter',0.2, 'notch','on', 'orientation','vertical', varargin{:});
    xlabel(this.classmembership.title);
    ylabel('score on pc 1');
    title('Score on principal component 1');    
end
