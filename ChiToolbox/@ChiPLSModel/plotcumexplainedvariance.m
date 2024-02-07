function plotcumexplainedvariance(this,limit,varargin)

% plotcumexplainedvariance Plots the cumulative percentage explained variance of both the data (X) block and the dependent variable (Y). 
%
% Syntax
%   plotcumexplainedvariance();
%   plotcumexplainedvariance(limit);
%   plotcumexplainedvariance(____,'nofig');
%
% Description
%   plotcumexplainedvariance() creates a 2-D line plot of the cumulative
%   percentage variance explained by each partial least squares component
%   in both the data (X) block and the dependent variable (Y). Up to 20 PLS
%   components are plotted by default. A line indicates the position of 95%
%   explained variance. A new figure window is generated.
%
%   plotcumexplainedvariance(limit) plots the cumulative percentage
%   explained variance with limit values being displayed.
%
%   plotcumexplainedvariance(____,'nofig') plots the data in the currently
%   active figure window, or creates a new figure if none is available.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot function for more details. 
%
% Copyright (c) 2020-2023, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot plotxscores plotloading plotexplainedvariance
%   ChiPLSModel ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, May 2020
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


errorcode = 'Chi:ChiPLSModel';
errormessagestub = 'Requested PLS component is out of range. Max components = ';

if exist('limit','var')
    if ((limit > this.ncomp) || (limit < 1))
        err = MException([errorcode,':OutOfRange'], ...
            [errormessagestub, num2str(this.ncomp), '.']);
        throw(err);
    end
end

argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
else
    % No 'nofig' found so create a new figure
    windowtitle = 'Cumulative percentage explained variance';
    figure('Name',windowtitle,'NumberTitle','off');
end

cumxexplained = cumsum(this.xexplained);
cumyexplained = cumsum(this.yexplained);

if ~exist('limit','var')
    limit = min(20,length(this.xexplained));
end

utilities.plotformatted(1:limit,cumxexplained(1:limit),'o-',1:limit,cumyexplained(1:limit),'o-',varargin{:});

% Draw line indicating 95% cumulative explained variance
axiscolour = 'k';
hold on;
limits = axis;
xmin = limits(1,1);
xmax = limits(1,2);
utilities.plotformatted([xmin,xmax], [95,95], axiscolour);
hold off;


legend({'data block';'dependent variable'},'Location','best')
xlabel('partial least squares component number');
ylabel('cumulative percentage explained variance');
title('Cumulative percentage explained variance');

%% Manage data cursor information
figurehandle = gcf;
cursor = datacursormode(figurehandle);
set(cursor,'UpdateFcn',{@utilities.datacursor_plsexplainedvariance});    

end
