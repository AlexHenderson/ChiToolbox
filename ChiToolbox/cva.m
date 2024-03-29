function [eigenvectors,eigenvalues,percent_explained_variation] = cva(data,groupmembership,varargin)

% CVA Canonical Variates Analysis
% usage:
%     [eigenvectors,eigenvalues,percent_explained_variation] = cva(data,groupmembership);
%     [eigenvectors,eigenvalues,percent_explained_variation] = cva(___,Name,Value);
% input:
%     data - typically pcscores, rows are observations, columns are variables on these observations
%     groupmembership - vector of labels, one per row of data
%     Name and Value should be in pairs. See below for options.  
% output:
%     eigenvectors - canonical variate eigenvectors, directions of most variation
%     eigenvalues - canonical variate eigenvalues, importance of each eigenvector
%     percent_explained_variation - percentage of variation explained by successive eigenvectors
%
% defaults:
%     By default the classes are balanced using undersampling. This
%     balancing can be removed by using a Name/Value pair of
%     'sample','none'. Other options include 'sample','undersample' to
%     duplicate the default status
%     
%   Copyright (c) 2015-2018, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
% See also 
%   undersample.
%
%   version 2.0 February 2018

%   version 2.0 February 2018 Alex Henderson
%   Added code to provide undersampling as a option. Default is undersampling
%   version 1.0 June 2015 Alex Henderson
%   initial release

% Taken from...
% A modification of canonical variates analysis to handle highly collinear multivariate data
% Lars N�rgaard, Rasmus Bro, Frank Westad, S�ren Balling
% Journal of Chemometrics 20 (2006) 425-435
% https://doi.org/10.1002/cem.1017
%
% See also...
% http://www.nag.co.uk/numeric/fn/manual/pdf/c28/c28int_fn04.pdf

% Could calculate within-group and between-group covariances at the same
% time, but this is easier to follow. 

%% Check inputs to see if different sampling methods are requested
undersampleRequired = true;
if (nargin > 2)
    argposition = find(cellfun(@(x) strcmpi(x, 'sample') , varargin));
    if argposition
        switch lower(varargin{argposition+1})
            case 'none'
                undersampleRequired = false;
            case 'undersample'
                undersampleRequired = true;
            otherwise
                utilities.warningnobacktrace('Sampling type not understood. Falling back to the default of ''undersample''');
        end        
        
        % Remove the parameter from the argument list
        varargin(argposition+1) = [];
        varargin(argposition) = []; %#ok<NASGU>
    end
end

%% Perform sampling, if requested
if undersampleRequired
    [uniqueNames,chosenClassMasks] = undersample(groupmembership); %#ok<ASGLU>
    
    data = data(any(chosenClassMasks),:);
    groupmembership = groupmembership(any(chosenClassMasks),:);    
end

%% Determine number of groups and valid outputs
% Unique rows doesn't work for cell arrays, so need two versions of the
% code here. 
if (size(groupmembership,2) > 1)
    [uniquegroups, not_required, groupindex] = unique(groupmembership, 'rows'); %#ok<ASGLU>
else
    [uniquegroups, not_required, groupindex] = unique(groupmembership); %#ok<ASGLU>
end
numgroups = size(uniquegroups,1);
[numspectra, numpts] = size(data);

canonical_variates = numgroups - 1;

%% Calculate the within-group covariance
within_group_covariances = zeros(numpts,numpts,numgroups);

for g = 1:numgroups
    thisgroup = data((groupindex == g),:);
    num_in_group = size(thisgroup,1);
    group_mean = mean(thisgroup);
    
    meancentered_group = thisgroup - repmat(group_mean,num_in_group,1);
    
    covariance = meancentered_group' * meancentered_group;
    
    within_group_covariances(:,:,g) = covariance;
end

within_group_covariance = sum(within_group_covariances,3)/(numspectra - numgroups);
% within_group_covariance = sum(within_group_covariances,3);

%% Calculate the between-group covariance
between_group_covariances = zeros(numpts,numpts,numgroups);

data_mean = mean(data);

for g = 1:numgroups
    thisgroup = data((groupindex == g),:);
    num_in_group = size(thisgroup,1);
    group_mean = mean(thisgroup);
    
    mean_difference = group_mean - data_mean;
    
    covariance = num_in_group * (mean_difference' * mean_difference);
    
    between_group_covariances(:,:,g) = covariance;
end

between_group_covariance = sum(between_group_covariances,3)/(numgroups - 1);
% between_group_covariance = sum(between_group_covariances,3);

%% Determine the line of best separation
[eigenvectors,eigenvalues] = eig(within_group_covariance \ between_group_covariance);
eigenvalues = diag(eigenvalues);

%% Construct the output
% Pool the eigenvalues and eigenvectors into a single matrix to sort and
% select, then separate again
combination = horzcat(eigenvalues,eigenvectors'); % merge the matrix
combination_sorted_by_eigenvalues = sortrows(combination,-1); % sort descending by eigenvalues
combination_wanted = combination_sorted_by_eigenvalues(1:canonical_variates, :); % only want the highest n vals
eigenvalues = combination_wanted(:,1); % separate the matrix again
eigenvectors = combination_wanted(:,2:end)';
percent_explained_variation = 100 * (eigenvalues / sum(eigenvalues));
