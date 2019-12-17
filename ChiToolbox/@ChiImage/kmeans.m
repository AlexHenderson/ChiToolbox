function obj = kmeans(this,k,varargin)

% kmeans  k-means clustering. 
%
% Syntax
%   result = kmeans(k);
%   result = kmeans(k,'vis');
%
% Description
%   result = kmeans(k) performs k-means clustering on the data using k
%   clusters. Results are returned in a ChiClusterOutcome object.
% 
%   result = kmeans(k,'vis') also displays the outcome.
% 
% Notes
%   This function requires the Statistics and Machine Learning Toolbox. 
% 
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiClusterOutcome kmeans randomforest adaboost

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


%% Do we have the machine learning toolbox
if ~exist('kmeans','file')
    err = MException(['CHI:',mfilename,':InputError'], ...
        'The Statistics and Machine Learning Toolbox is required for this function.');
    throw(err);
end

%% Need k
if (nargin < 2)
    err = MException(['CHI:',mfilename,':InputError'], ...
        'The number of clusters (k) is required.');
    throw(err);
end

%% Visualise?
vis = false;
argposition = find(cellfun(@(x) strcmpi(x, 'vis') , varargin));
if argposition
    vis = true;
    varargin(argposition) = [];
end

%% Perform kmeans
    idx = kmeans(this.data,k,varargin{:});
    
    idx = reshape(idx,this.ypixels,this.xpixels);
    
    obj = ChiClusterOutcome(idx,'kmeans');
    
    if vis
        obj.show;
    end
    
end
