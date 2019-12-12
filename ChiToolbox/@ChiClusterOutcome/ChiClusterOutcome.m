classdef ChiClusterOutcome < ChiBase

% ChiClusterOutcome  Class to manage the outcome of clustering algorithms.
%
% Syntax
%   outcome = ChiClusterOutcome(clusterdata);
%   outcome = ChiClusterOutcome(clusterdata,algorithm);
%
% Description
%   outcome = ChiClusterOutcome(clusterdata) creates a wrapper for the
%   output of a clustering algorithm, for example kmeans. clusterdata
%   contains a matrix of the cluster identification number for each pixel. 
%
%   outcome = ChiClusterOutcome(clusterdata,algorithm) includes a string
%   containing teh name of the algorithm employed.
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiImage.kmeans kmeans

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox
    
    
    properties
        clusters    % Outcome of cluster algorithm
        algorithm   % Name of cluster algorithm employed
    end

    properties (Dependent)
        numclusters     % Number of clusters
    end
    
    methods
        function this = ChiClusterOutcome(varargin)
            
        % ChiClusterOutcome  Class to manage the outcome of clustering algorithms.
        %
        % Syntax
        %   outcome = ChiClusterOutcome(clusterdata);
        %   outcome = ChiClusterOutcome(clusterdata,algorithm);
        %
        % Description
        %   outcome = ChiClusterOutcome(clusterdata) creates a wrapper for the
        %   output of a clustering algorithm, for example kmeans. clusterdata
        %   contains a matrix of the cluster identification number for each pixel. 
        %
        %   outcome = ChiClusterOutcome(clusterdata,algorithm) includes a string
        %   containing the name of the algorithm employed.
        %
        % Copyright (c) 2019, Alex Henderson.
        % Licenced under the GNU General Public License (GPL) version 3.
        %
        % See also 
        %   kmeans

        % Contact email: alex.henderson@manchester.ac.uk
        % Licenced under the GNU General Public License (GPL) version 3
        % http://www.gnu.org/copyleft/gpl.html
        % Other licensing options are available, please contact Alex for details
        % If you use this file in your work, please acknowledge the author(s) in
        % your publications. 

        % The latest version of this file is available on Bitbucket
        % https://bitbucket.org/AlexHenderson/chitoolbox
            
            % args: clusters,algorithm
            
            % Defaults
            this.algorithm = 'unspecified';

            % Parse the arguments
            switch nargin
                case 0
                case 1
                    this.clusters = varargin{1};
                case 2
                    this.clusters = varargin{1};
                    this.algorithm = varargin{2};
                otherwise
                    err = MException(['CHI:',mfilename,':showError'], ...
                        'No data to show.');
                    throw(err);
            end
                    
                    
        end
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function numclusters = get.numclusters(this)
            numclusters = max(max(this.clusters));
        end                
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
    end
    
    
end

