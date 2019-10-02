classdef ChiRFPrediction < ChiBase
% ChiRFPrediction
%   Copyright (c) 2018 Alex Henderson (alex.henderson@manchester.ac.uk)

    properties
        prediction;
        scores;
        stdevs;
        classmembership;        % an instance of ChiClassMembership
%         correctlyclassified;
        elapsed;
        elaspedinseconds;
        history = ChiLogger();  % Log of data processing steps
    end
    
    properties (Dependent = true)
%         %% Calculated properties
%         cc;
%         percentcorrectlyclassified;
%         percentcc;
%         pcc;
    end
    
    methods
        %% Constructor
        function this = ChiRFPrediction(...
                        prediction, ...
                        scores, ...
                        stdevs, ...
                        classmembership, ...
                        elapsed,...
                        elaspedinseconds,varargin)
                    
            argposition = find(cellfun(@(x) isa(x,'ChiLogger') , varargin));
            if argposition
                this.history = varargin{argposition}.clone;
                varargin(argposition) = []; %#ok<NASGU>
            else
                this.history = ChiLogger();
            end
            
            if (nargin > 0) % Support calling with 0 arguments
                this.prediction = prediction;
                this.scores = scores;
                this.stdevs = stdevs;
                this.classmembership = classmembership.clone();
%                 this.correctlyclassified = correctlyclassified;
                this.elapsed = elapsed;
                this.elaspedinseconds = elaspedinseconds;
            end 
        end
        
        %% percentcc
%         function percentcorrectlyclassified = get.percentcorrectlyclassified(this)
%             percentcorrectlyclassified = 100 * sum(this.correctlyclassified) ./ length(this.correctlyclassified);
%         end
        
        %% percentcc
%         function percentcc = get.percentcc(this)
%             percentcc = this.percentcorrectlyclassified;
%         end
        
        %% cc
%         function cc = get.cc(this)
%             cc = this.correctlyclassified;
%         end
       
        %% pcc
%         function pcc = get.pcc(this)
%             pcc = this.percentcc;
%         end
       
    end
    
end

