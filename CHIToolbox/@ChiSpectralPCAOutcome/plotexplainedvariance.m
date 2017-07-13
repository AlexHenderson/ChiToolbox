function plotexplainedvariance(this,limitpcs,varargin)

% plotexplainedvariance  Plots the percentage explained variance of the principal components. 
%
% Syntax
%   plotexplainedvariance();
%   plotexplainedvariance(limitpcs);
%   plotexplainedvariance(____,'nofig');
%
% Description
%   plotexplainedvariance() creates a 2-D line plot of the percentage
%   variance explained by each principal component. Up to 20 principal
%   components are plotted by default. A new figure window is generated.
%
%   plotexplainedvariance(limitpcs) plots the percentage explained variance
%   with limitpcs values being displayed.
%
%   plotexplainedvariance(____,'nofig') plots the data in the currently
%   active figure window, or creates a new figure if none is available.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot function for more details. 
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot plotscores plotloading plotcumexplainedvariance
%   CHiSpectralPCAOutcome ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
else
    % No 'nofig' found so create a new figure
    windowtitle = 'Percentage explained variance';
    figure('Name',windowtitle,'NumberTitle','off');
end

if exist('limitpcs','var')
    plot(this.explained(1:limitpcs),'o-',varargin{:});
else
    maxpcs = min(20,length(this.explained));
    plot(this.explained(1:maxpcs),'o-',varargin{:});
end

xlabel('principal component number');
ylabel('percentage explained variance');
title('Percentage explained variance');

end
