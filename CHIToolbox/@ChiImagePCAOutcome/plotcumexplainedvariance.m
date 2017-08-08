function plotcumexplainedvariance(this,limitpcs)

% plotcumexplainedvariance Plots cumulative percentage explained variance
% usage:
%     plotcumexplainedvariance(this);
%     plotcumexplainedvariance(this, limitpcs);
%
% where:
%   limitpcs - (optional) by default the function plots the first 20 pcs. If
%       'limitpcs' is present then this determines the number of principal
%       components displayed
%
%   Copyright (c) 2015-2017, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 2.0 July 2017

%   version 2.0 July 2017 Alex Henderson
%   Modified as a class function
%   version 1.0 June 2015 Alex Henderson
%   initial release

% window_title = 'Cumulative percentage explained variance';
% figure_handle = figure('Name',window_title,'NumberTitle','off');

cumpcexplained = cumsum(this.explained);

if (exist('limitpcs','var'))
    plot(cumpcexplained(1:limitpcs), 'o-');
else
    plot(cumpcexplained(1:20), 'o-');
end

    % Draw line indicating 95% cumulative explained variance
    axiscolour = 'k';
    hold on;
    limits = axis;
    xmin = limits(1,1);
    xmax = limits(1,2);
    plot([xmin,xmax], [95,95], axiscolour);
    hold off;

xlabel('principal component number');
ylabel('cumulative percentage explained variance');
title('Cumulative percentage explained variance');

%% Manage data cursor information
figurehandle = gcf;
cursor = datacursormode(figurehandle);
set(cursor,'UpdateFcn',{@utilities.datacursor_explainedvariance});    

end
