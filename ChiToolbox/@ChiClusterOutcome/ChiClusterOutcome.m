classdef ChiClusterOutcome < ChiModel

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
        clusters    % Outcome of cluster algorithm as matrix of cluster numbers
        centroids   % Centroids of each cluster as a ChiSpectralCollection of the same type as the source
        algorithm   % Name of cluster algorithm employed
        seed        % Name of algorithm used to generate initial seeds for clusters
    end

    properties (Dependent)
        numclusters     % Number of clusters
        k               % Number of clusters
    end
    
    methods
        function this = ChiClusterOutcome(varargin)
            
        % ChiClusterOutcome  Class to manage the outcome of clustering algorithms.
        %
        % Syntax
        %   outcome = ChiClusterOutcome(clusters,centroids,algorithm,seed);
        %
        % Description
        %   outcome = ChiClusterOutcome(clusters,centroids,algorithm,seed)
        %   creates a wrapper for the output of a clustering algorithm; for
        %   example, kmeans. clusters is a ChiPicture representing each
        %   cluster. centroids is a ChiSpectralCollection of the same type
        %   as the source data, containing the centroids of each cluster.
        %   algorithm is the name of the clustering algorithm employed.
        %   seed is the algorithm for initiating the clustering process.
        %
        % Copyright (c) 2019-2021, Alex Henderson.
        % Licenced under the GNU General Public License (GPL) version 3.
        %
        % See also 
        %   kmeans ChiSpectralCollection colormap

        % Contact email: alex.henderson@manchester.ac.uk
        % Licenced under the GNU General Public License (GPL) version 3
        % http://www.gnu.org/copyleft/gpl.html
        % Other licensing options are available, please contact Alex for details
        % If you use this file in your work, please acknowledge the author(s) in
        % your publications. 

        % The latest version of this file is available on Bitbucket
        % https://bitbucket.org/AlexHenderson/chitoolbox
            
            % args: clusters,centroids,algorithm,seed
            
            % Defaults
            this.centroids = [];
            this.algorithm = 'unspecified';
            this.seed = 'unspecified';

            % Parse the arguments
            switch nargin
                case 0
                case 1
                    this.clusters = varargin{1};
                case 2
                    this.clusters = varargin{1};
                    this.centroids = varargin{2}.clone;
                case 3
                    this.clusters = varargin{1};
                    this.centroids = varargin{2}.clone;
                    this.algorithm = varargin{3};
                case 4
                    this.clusters = varargin{1};
                    this.centroids = varargin{2}.clone;
                    this.algorithm = varargin{3};
                    this.seed = varargin{4};
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
        function k = get.k(this)
            k = this.numclusters();
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
    end
    
    
end
