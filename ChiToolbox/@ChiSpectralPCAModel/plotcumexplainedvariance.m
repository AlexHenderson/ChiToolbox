function plotcumexplainedvariance(this,limitpcs,varargin)

% plotcumexplainedvariance Plots cumulative percentage explained variance
%
% Syntax
%   plotcumexplainedvariance();
%   plotcumexplainedvariance(limitpcs);
%   plotcumexplainedvariance(____,'nofig');
%
% Description
%   plotcumexplainedvariance() creates a 2-D plot of the cumulative
%   percentage variance explained by each principal component. Up to 20
%   principal components are plotted by default. A line indicates the
%   position of 95% explained variance. A new figure window is generated.
%
%   plotcumexplainedvariance(limitpcs) plots the cumulative percentage
%   explained variance with limitpcs values being displayed.
%
%   plotcumexplainedvariance(____,'nofig') plots the data in the currently
%   active figure window, or creates a new figure if none is available.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot function for more details. 
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot plotscores plotloading plotexplainedvariance
%   ChiSpectralPCAOutcome ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/Chitoolbox

errorcode = 'Chi:ChiSpectralPCAOutcome';
errormessagestub = 'Requested principal component is out of range. Max PCs = ';

if exist('limitpcs','var')
    if ((limitpcs > this.numpcs) || (limitpcs < 1))
        err = MException([errorcode,':OutOfRange'], ...
            [errormessagestub, num2str(this.numpcs), '.']);
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

cumexplained = cumsum(this.explained);

if exist('limitpcs','var')
    plot(cumexplained(1:limitpcs),'o-',varargin{:});
else
    maxpcs = min(20,length(cumexplained));
    plot(cumexplained(1:maxpcs),'o-',varargin{:});
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
