classdef ChiValidationSet

% ChiValidationSet  The results of a statistical validation test on some data. 
%
% Syntax
%   obj = ChiValidationSet(testname,testparams,...
%                          funcname,funcparams,...
%                          data,...
%                          trainingidx,testidx,...
%                          predictions,elapsed)
% 
%   obj = ChiValidationSet(____,history)
%
% Description
%   Statistical validation tests, performed on data, result in one or more
%   outcomes. A ChiValidationSet records these outcomes. 
% 
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiHoldoutTest ChiKFoldTest ChiLOOCVTest ChiBootstrapTest 

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, 2020
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    properties
        testname;       % name of the type of test performed
        testparameters; % struct of parameters relating to this test
        functionname;   % name of function validated
        functionparameters; % cell array of parameters passed to validation function  
        
        data;           % ChiSpectralCollection used in validation
        trainingidx;    % cell array of index values of spectra used to train each prediction of the model
        testidx;        % cell array of index values of spectra used to test each prediction of the model
        
        predictions;    % array of predictions made by the validation test
        elapsed;        % time in seconds that the validation took
        history = ChiLogger();  % log of data processing steps
    end

    properties (Dependent = true)
        elapsedstr;     % time that the validation took, as a string
        numtests;       % number of tests performed
        percentcorrectlyclassified; % if the unseen data was labelled, this is the percentage of predicted data correctly classified. 
        percentcc;  % if the unseen data was labelled, this is the percentage of predicted data correctly classified. 
        pcc;        % if the unseen data was labelled, this is the percentage of predicted data correctly classified. 
        meanpcc;    % mean percent correctly classified
        stdpcc;     % standard deviation of percentage correctly classified
    end
    
    
    methods
        % Constructor
        function this = ChiValidationSet(testname,testparams,...
                            funcname,funcparams,...
                            data,...
                            trainingidx,testidx,...
                            predictions,elapsed,varargin)
            
            argposition = find(cellfun(@(x) isa(x,'ChiLogger') , varargin));
            if argposition
                this.history = varargin{argposition}.clone;
                varargin(argposition) = [];  %#ok<NASGU>
            else
                this.history = ChiLogger();
            end
            
            if nargin % Support calling with 0 arguments
                this.testname = testname;
                this.testparameters = testparams;
                this.functionname = funcname;
                this.functionparameters = funcparams;
                this.data = data.clone();
                this.trainingidx = trainingidx;
                this.testidx = testidx;
                this.predictions = predictions;
                this.elapsed = elapsed;
            end
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % elapsedstr
        function elapsedstr = get.elapsedstr(this)
            elapsedstr = durationString(this.elapsed);
        end
       
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % numtests
        function numtests = get.numtests(this)
            numtests = length(this.predictions);
        end
       
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % percentcc
        function percentcorrectlyclassified = get.percentcorrectlyclassified(this)
            percentcorrectlyclassified = zeros(this.numtests,1);

            for i = 1:this.numtests
                percentcorrectlyclassified(i) = this.predictions(i).percentcorrectlyclassified;
            end
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % percentcc
        function percentcc = get.percentcc(this)
            percentcc = this.percentcorrectlyclassified;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % pcc
        function pcc = get.pcc(this)
            pcc = this.percentcorrectlyclassified;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % meanpcc
        function meanpcc = get.meanpcc(this)
            meanpcc = mean(this.percentcorrectlyclassified);
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % stdpcc
        function stdpcc = get.stdpcc(this)
            if strcmpi(this.testname,'ChiLOOCVTest')
                message = ['If this is a classification test, take this value with a pinch of salt. See ''doc ', mfilename,''' for more information.'];
                utilities.warningnobacktrace(message);
            end
            stdpcc = std(this.percentcorrectlyclassified);
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
    end
end

