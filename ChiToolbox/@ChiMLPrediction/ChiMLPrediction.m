classdef ChiMLPrediction < ChiBase

% ChiMLPrediction  Class to manage the outcome of machine learning algorithms.
%
% Syntax
%   outcome = ChiMLPrediction(labelid,scores,stdevs,classmembership,elapsed,elaspedinseconds)
%   outcome = ChiMLPrediction(____,correctlyclassified)
%   outcome = ChiMLPrediction(____,history)
% 
% Description
%   outcome = ChiMLPrediction(labelid,scores,stdevs,classmembership,elapsed,elaspedinseconds)
%   creates a wrapper for the outcome of a prediction by a machine learning
%   model on a set of 'previously unseen' data. 
% 
%   outcome = ChiMLPrediction(____,correctlyclassified) if the 'previously
%   unseen' data were actually labelled with known classes, then
%   correctlyclassified is a logical vector indicating whether the known
%   unseen data were correctly classified.
%   
%   outcome = ChiMLPrediction(____,history) includes a ChiLogger history
%   object recording the data processing history.
% 
% Notes
%   See the MATLAB help relating to fitcensemble or TreeBagger for an
%   explanation of the scores and stdevs properties. 
%
% Copyright (c) 2018-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   randomforest adaboost fitcensemble TreeBagger.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    properties
        labelid; % a list of label identifiers indicating the outcome of prediction.
        scores; % a matrix relating to the weighted probability that an observation belonged to a class.
        stdevs; % a matrix if standard deviations of the predictions of each observation. Only applicable when the model was generated by TreeBagger.
        classmembership; % an instance of ChiClassMembership
        elapsed; % time that the prediction took as a string
        elaspedinseconds; % time in seconds that the prediction took
        correctlyclassified; % if the unseen data was labelled, this is a vector indicating whether it was correctly classified. Otherwise it is an empty variable.
        history = ChiLogger(); % log of data processing steps
    end
    
    properties (Dependent = true)
        cc; % if the unseen data was labelled, this is a vector indicating whether it was correctly classified. Otherwise it is an empty variable.
        percentcorrectlyclassified; % if the unseen data was labelled, this is the percentage of predicted data correctly classified. 
        percentcc; % if the unseen data was labelled, this is the percentage of predicted data correctly classified. 
        pcc; % if the unseen data was labelled, this is the percentage of predicted data correctly classified. 
        label; % predicted class label
    end
    
    methods
        %% Constructor
        function this = ChiMLPrediction(...
                        labelid, ...
                        scores, ...
                        stdevs, ...
                        classmembership, ...
                        elapsed,...
                        elaspedinseconds, ...
                        varargin)
                    
            argposition = find(cellfun(@(x) isa(x,'ChiLogger') , varargin));
            if argposition
                this.history = varargin{argposition}.clone;
                varargin(argposition) = []; 
            else
                this.history = ChiLogger();
            end
            
            if nargin % Support calling with 0 arguments
                this.labelid = labelid;
                this.scores = scores;
                this.stdevs = stdevs;
                this.classmembership = classmembership.clone();
                this.elapsed = elapsed;
                this.elaspedinseconds = elaspedinseconds;
            end 

            % Was the predicted data already labelled?
            if ~isempty(varargin)
                this.correctlyclassified = varargin{1};
            else
                this.correctlyclassified = [];
            end
            
        end
        
        %% percentcc
        function percentcorrectlyclassified = get.percentcorrectlyclassified(this)
            if ~isempty(this.correctlyclassified)
                percentcorrectlyclassified = 100 * sum(this.correctlyclassified) ./ length(this.correctlyclassified);
            else
                percentcorrectlyclassified = [];
            end
        end
        
        %% percentcc
        function percentcc = get.percentcc(this)
            percentcc = this.percentcorrectlyclassified;
        end
        
        %% cc
        function cc = get.cc(this)
            cc = this.correctlyclassified;
        end
       
        %% pcc
        function pcc = get.pcc(this)
            pcc = this.percentcc;
        end
       
        %% label
        function label = get.label(this)
            label = this.classmembership.uniquelabels(this.labelid);
        end
       
    end
    
end
