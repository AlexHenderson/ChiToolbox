function plotscoresbyclass(this,cvx,cvy,varargin)

% plotscoresbyclass  Plots canonical variate scores for each class separately. 
%
% Syntax
%   plotscoresbyclass(cvx,cvy);
%
% Description
%   plotscoresbyclass(cvx,cvy) creates a 2-D scatter plot of canonical
%   variate scores. cvx is the canonical variate to plot on the x-axis,
%   while cvy is the canonical variate to plot on the y-axis. A new figure
%   window is created for each class in addition to the overall plot.
%
%   Other parameters can be applied to customise the plot. See the 
%   utilities.gscatter function for more details. 
%
% Copyright (c) 2018-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plotscores plotloadings plotexplainedvariance plotpcloadings
%   plotpcexplainedvariance plotpccumexplainedvariance utilities.gscatter
%   ChiPCAModel ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


titlestub = 'Scores on canonical variates ';
windowtitlestub = titlestub;
axislabelstub = 'score on CV ';
errorcode = 'CHI:ChiPCCVAModel';
errormessagestub = 'Requested canonical variate is out of range. Max CVs = ';

% If we have more than 1 canonical variate, check that the required cvs are
% in range. 
if (this.numcvs ~= 1)
    if ((cvx > this.numcvs) || (cvx < 1))
    err = MException([errorcode,':OutOfRange'], ...
        [errormessagestub, num2str(this.numcvs), '.']);
    throw(err);
    end

    if ((cvy > this.numcvs) || (cvy < 1))
    err = MException([errorcode,':OutOfRange'], ...
        [errormessagestub, num2str(this.numcvs), '.']);
    throw(err);
    end
end

if (this.numcvs > 1)
    % We can use a scatter plot...
    % Firstly draw everything, partly to grab the axis limits
    windowtitle = [windowtitlestub, num2str(cvx), ' and ' num2str(cvy)];
    figure('Name',windowtitle,'NumberTitle','off');
    colours = get(gca,'colororder');

    numcolours = size(colours,1);
    if (this.pca.classmembership.numuniquelabels > numcolours)
        utilities.warningnobacktrace('There are more groups than colours, the colours will be recycled');
        while (this.pca.classmembership.numuniquelabels > size(colours,1))
            colours = vertcat(colours,colours); %#ok<AGROW>
        end
    end
    
% Defaults
    
    decplaces = 3;
    
    utilities.gscatter(this.scores(:,cvx),this.scores(:,cvy),this.pca.classmembership.labels,'colours',colours,'nofig',varargin{:});
    xlabel([axislabelstub, num2str(cvx), ' (', num2str(this.explained(cvx),decplaces), '%)']);
    ylabel([axislabelstub, num2str(cvy), ' (', num2str(this.explained(cvy),decplaces), '%)']);
    title([titlestub, num2str(cvx), ' and ', num2str(cvy), ' (',num2str(this.pcs), ' pcs)']);
    limits = axis;
    utilities.draw00axes(axis)

    % Manage data cursor information
    plotinfo = struct;
    plotinfo.xpointlabel = ['CV ', num2str(cvx)];
    plotinfo.ypointlabel = ['CV ', num2str(cvy)];
    plotinfo.xdata = this.scores(:,cvx);
    plotinfo.ydata = this.scores(:,cvy);

    if ~isempty(this.pca.classmembership)
        plotinfo.pointmembershiplabels = this.pca.classmembership.labels;
    end
    
    % Set the datacursor for this plot
    figurehandle = gcf;
    cursor = datacursormode(figurehandle);
    set(cursor,'UpdateFcn',{@utilities.datacursor_scores_6sf,this,plotinfo});
    
    % Now draw separate figures for each class
    % Could put this into a single figure, using subplot, but need to manage
    % the layout. Easiest to produce separate figures for now. 
    for i = 1:this.pca.classmembership.numuniquelabels
        label = this.pca.classmembership.uniquelabels{i};
        windowtitle = [windowtitlestub, num2str(cvx), ' and ' num2str(cvy), ' (', label, ')' ];
        figure('Name',windowtitle,'NumberTitle','off');

        % What are we plotting
        thisclass = (this.pca.classmembership.labelids == i);

        % Produce the plot for this class
        utilities.gscatter(this.scores(thisclass,cvx),this.scores(thisclass,cvy),this.pca.classmembership.labels(thisclass),'colours',colours(i,:),'nofig',varargin{:});
        
        % Change limits to match the overall figure for consistency
        xlim(limits(1:2));
        ylim(limits(3:4));
    
        % Labels
        xlabel([axislabelstub, num2str(cvx), ' (', num2str(this.explained(cvx),decplaces), '%)']);
        ylabel([axislabelstub, num2str(cvy), ' (', num2str(this.explained(cvy),decplaces), '%)']);
        title([titlestub, num2str(cvx), ' and ', num2str(cvy), ' (',num2str(this.pcs), ' pcs)']);
        
        % Plot the zero axis lines
        utilities.draw00axes(axis)
        
        % Set the datacursor for this plot
        figurehandle = gcf;
        cursor = datacursormode(figurehandle);
        set(cursor,'UpdateFcn',{@utilities.datacursor_scores_6sf,this,plotinfo});

    end

else
    % Only a single canonical variate so we can use a box plot
    boxplot(this.scores, this.pca.classmembership.labels, 'jitter',0.2, 'notch','on', 'orientation','vertical', varargin{:});
    xlabel(this.pca.classmembership.title);
    ylabel('score on cv 1');
    title('Score on canonical variate 1');    
end
