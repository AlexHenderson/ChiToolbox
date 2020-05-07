function plotexplainedvariance(this,limit,varargin)

% plotexplainedvariance  Plots the percentage explained variance of both the data (X) block and the dependent variable (Y). 
%
% Syntax
%   plotexplainedvariance();
%   plotexplainedvariance(limit);
%   plotexplainedvariance(____,'nofig');
%
% Description
%   plotexplainedvariance() creates a 2-D line plot of the percentage
%   variance explained by each partial least squares component in both the
%   data (X) block and the dependent variable (Y). Up to 20 components are
%   plotted by default. A new figure window is generated.
%
%   plotexplainedvariance(limit) plots the percentage explained variance
%   with limit values being displayed.
%
%   plotexplainedvariance(____,'nofig') plots the data in the currently
%   active figure window, or creates a new figure if none is available.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot function for more details. 
%
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot plotxscores plotweight plotcumexplainedvariance
%   ChiSpectralPLSOutcome ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, May 2020
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/Chitoolbox


argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
else
    % No 'nofig' found so create a new figure
    windowtitle = 'Percentage explained variance';
    figure('Name',windowtitle,'NumberTitle','off');
end

errorcode = 'Chi:ChiSpectralPLSOutcome';
errormessagestub = 'Requested PLS component is out of range. Max components = ';

if exist('limit','var')
    if ((limit > this.ncomp) || (limit < 1))
        err = MException([errorcode,':OutOfRange'], ...
            [errormessagestub, num2str(this.ncomp), '.']);
        throw(err);
    end
end

if ~exist('limit','var')
    limit = min(20,length(this.xexplained));
end

plot(1:limit,this.xexplained(1:limit),'o-',1:limit,this.yexplained(1:limit),'o-',varargin{:});

legend({'data block';'dependent variable'},'Location','best')
xlabel('partial least squares component number');
ylabel('percentage explained variance');
title('Percentage explained variance');

%% Manage data cursor information
figurehandle = gcf;
cursor = datacursormode(figurehandle);
set(cursor,'UpdateFcn',{@utilities.datacursor_plsexplainedvariance});    

end
