classdef ChiPrediction < ChiBase

% ChiPrediction  Simply a base class for outputs of a ChiModel prediction
% 
% Description
%   This class exists to identify objects that are predictions from
%   ChiModels.
% 
% Notes
%   In the confusion matrix, columns are truth, rows are predictions
%       TP FP
%       FN TN
% 
% Copyright (c) 2020, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiPCAPrediction ChiPCCVAPrediction ChiMLPrediction ChiModel ChiBase

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2020
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    properties (Dependent = true)
        numclasses = [];        % number of classes in the model
        labels = {};            % cell array of class labels
        confusionmatrix = [];   % confusion matrix where columns are truth, and rows are prediction
    end

    methods
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function numclasses = get.numclasses(this)
            numclasses = this.model.classmembership.numclasses; 
        end
       
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function labels = get.labels(this)
            labels = this.model.classmembership.uniquelabels;
        end
       
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function confusionmatrix = get.confusionmatrix(this)
            % Generate confusion matrix
            % Columns are truth, rows are predictions
            confusionmatrix = zeros(this.numclasses);
            for currentclass = 1:this.numclasses
                classresult = this.predictedclassid(this.trueclassid == currentclass);
                [classid, counts] = utilities.countclasses(classresult,(1:this.numclasses)'); %#ok<ASGLU>
                confusionmatrix(:,currentclass) = counts;
            end
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function TP = TP(this)
            % count of true positive outcomes
            if (this.numclasses ~= 2)
                st = dbstack;
                namestr = st.name;
                [filepath,name,ext] = fileparts(namestr); %#ok<ASGLU>
                err = MException(['CHI:',mfilename,':DimensionalityError'], ...
                    [ext(2:end), ' cannot be calculated. Not a 2-class model.']);
                throw(err);
            end
            TP = this.confusionmatrix(1,1);
        end
       
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function FP = FP(this)
            % count of false positive outcomes
            if (this.numclasses ~= 2)
                st = dbstack;
                namestr = st.name;
                [filepath,name,ext] = fileparts(namestr); %#ok<ASGLU>
                err = MException(['CHI:',mfilename,':DimensionalityError'], ...
                    [ext(2:end), ' cannot be calculated. Not a 2-class model.']);
                throw(err);
            end
            FP = this.confusionmatrix(1,2);
        end
       
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function FN = FN(this)
            % count of false negative outcomes
            if (this.numclasses ~= 2)
                st = dbstack;
                namestr = st.name;
                [filepath,name,ext] = fileparts(namestr); %#ok<ASGLU>
                err = MException(['CHI:',mfilename,':DimensionalityError'], ...
                    [ext(2:end), ' cannot be calculated. Not a 2-class model.']);
                throw(err);
            end
            FN = this.confusionmatrix(2,1);
        end
       
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function TN = TN(this)
            % count of true negative outcomes
            if (this.numclasses ~= 2)
                st = dbstack;
                namestr = st.name;
                [filepath,name,ext] = fileparts(namestr); %#ok<ASGLU>
                err = MException(['CHI:',mfilename,':DimensionalityError'], ...
                    [ext(2:end), ' cannot be calculated. Not a 2-class model.']);
                throw(err);
            end
            TN = this.confusionmatrix(2,2);
        end
       
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function numP = numP(this)
            % total number of positive outcomes
            if (this.numclasses ~= 2)
                st = dbstack;
                namestr = st.name;
                [filepath,name,ext] = fileparts(namestr); %#ok<ASGLU>
                err = MException(['CHI:',mfilename,':DimensionalityError'], ...
                    [ext(2:end), ' cannot be calculated. Not a 2-class model.']);
                throw(err);
            end
            numP = sum(this.confusionmatrix(:,1));
        end
       
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function numN = numN(this)
            % total number of negative outcomes
            if (this.numclasses ~= 2)
                st = dbstack;
                namestr = st.name;
                [filepath,name,ext] = fileparts(namestr); %#ok<ASGLU>
                err = MException(['CHI:',mfilename,':DimensionalityError'], ...
                    [ext(2:end), ' cannot be calculated. Not a 2-class model.']);
                throw(err);
            end
            numN = sum(this.confusionmatrix(:,2));
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function true_positive_rate = true_positive_rate(this)
            % true positive rate (= TP / TP + FN)
            if (this.numclasses ~= 2)
                st = dbstack;
                namestr = st.name;
                [filepath,name,ext] = fileparts(namestr); %#ok<ASGLU>
                err = MException(['CHI:',mfilename,':DimensionalityError'], ...
                    [ext(2:end), ' cannot be calculated. Not a 2-class model.']);
                throw(err);
            end
            true_positive_rate = this.TP / this.numP; % TP / TP + FN
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function false_positive_rate = false_positive_rate(this)
            % false positive rate  (= FP / FP + TN)
            if (this.numclasses ~= 2)
                st = dbstack;
                namestr = st.name;
                [filepath,name,ext] = fileparts(namestr); %#ok<ASGLU>
                err = MException(['CHI:',mfilename,':DimensionalityError'], ...
                    [ext(2:end), ' cannot be calculated. Not a 2-class model.']);
                throw(err);
            end
            false_positive_rate = this.FP / this.numN; % FP / FP + TN
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function sensitivity = sensitivity(this)
            % model sensitivity (= true positive rate)
            if (this.numclasses ~= 2)
                st = dbstack;
                namestr = st.name;
                [filepath,name,ext] = fileparts(namestr); %#ok<ASGLU>
                err = MException(['CHI:',mfilename,':DimensionalityError'], ...
                    [ext(2:end), ' cannot be calculated. Not a 2-class model.']);
                throw(err);
            end
            sensitivity = this.true_positive_rate;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function specificity = specificity(this)
            % model specificity (= 1 - false_positive_rate; = TN / (FP + TN))
            if (this.numclasses ~= 2)
                st = dbstack;
                namestr = st.name;
                [filepath,name,ext] = fileparts(namestr); %#ok<ASGLU>
                err = MException(['CHI:',mfilename,':DimensionalityError'], ...
                    [ext(2:end), ' cannot be calculated. Not a 2-class model.']);
                throw(err);
            end
            specificity = 1 - this.false_positive_rate; % TN / (FP + TN)
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function precision = precision(this)
            % model precision (= TP / (TP + FP))
            if (this.numclasses ~= 2)
                st = dbstack;
                namestr = st.name;
                [filepath,name,ext] = fileparts(namestr); %#ok<ASGLU>
                err = MException(['CHI:',mfilename,':DimensionalityError'], ...
                    [ext(2:end), ' cannot be calculated. Not a 2-class model.']);
                throw(err);
            end
            precision = this.TP / (this.TP + this.FP);
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function recall = recall(this)
            % model recall (= true positive rate; = sensitivity)
            if (this.numclasses ~= 2)
                st = dbstack;
                namestr = st.name;
                [filepath,name,ext] = fileparts(namestr); %#ok<ASGLU>
                err = MException(['CHI:',mfilename,':DimensionalityError'], ...
                    [ext(2:end), ' cannot be calculated. Not a 2-class model.']);
                throw(err);
            end
            recall = this.true_positive_rate;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function positive_predictive_value = positive_predictive_value(this)
            % model positive predictive value (= precision)
            if (this.numclasses ~= 2)
                st = dbstack;
                namestr = st.name;
                [filepath,name,ext] = fileparts(namestr); %#ok<ASGLU>
                err = MException(['CHI:',mfilename,':DimensionalityError'], ...
                    [ext(2:end), ' cannot be calculated. Not a 2-class model.']);
                throw(err);
            end
            positive_predictive_value = this.precision;
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function F_measure = F_measure(this)
            % model F-measure (F-score, F1 score), a measure of the test's accuracy
            if (this.numclasses ~= 2)
                st = dbstack;
                namestr = st.name;
                [filepath,name,ext] = fileparts(namestr); %#ok<ASGLU>
                err = MException(['CHI:',mfilename,':DimensionalityError'], ...
                    [ext(2:end), ' cannot be calculated. Not a 2-class model.']);
                throw(err);
            end
            F_measure = 2 / ((1/this.precision) + (1/this.recall));
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%         function numtruepositive = numtruepositive(this)
%             if (this.numclasses ~= 2)
%                 st = dbstack;
%                 namestr = st.name;
%                 [filepath,name,ext] = fileparts(namestr); %#ok<ASGLU>
%                 err = MException(['CHI:',mfilename,':DimensionalityError'], ...
%                     [ext(2:end), ' cannot be calculated. Not a 2-class model.']);
%                 throw(err);
%             end
%             numtruepositive = this.TP;
%         end
%        
%         % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%         function numfalsepositive = numfalsepositive(this)
%             if (this.numclasses ~= 2)
%                 st = dbstack;
%                 namestr = st.name;
%                 [filepath,name,ext] = fileparts(namestr); %#ok<ASGLU>
%                 err = MException(['CHI:',mfilename,':DimensionalityError'], ...
%                     [ext(2:end), ' cannot be calculated. Not a 2-class model.']);
%                 throw(err);
%             end
%             numfalsepositive = this.FP;
%         end
%        
%         % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%         function numfalsenegative = numfalsenegative(this)
%             if (this.numclasses ~= 2)
%                 st = dbstack;
%                 namestr = st.name;
%                 [filepath,name,ext] = fileparts(namestr); %#ok<ASGLU>
%                 err = MException(['CHI:',mfilename,':DimensionalityError'], ...
%                     [ext(2:end), ' cannot be calculated. Not a 2-class model.']);
%                 throw(err);
%             end
%             numfalsenegative = this.FN;
%         end
%        
%         % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%         function numtruenegative = numtruenegative(this)
%             if (this.numclasses ~= 2)
%                 st = dbstack;
%                 namestr = st.name;
%                 [filepath,name,ext] = fileparts(namestr); %#ok<ASGLU>
%                 err = MException(['CHI:',mfilename,':DimensionalityError'], ...
%                     [ext(2:end), ' cannot be calculated. Not a 2-class model.']);
%                 throw(err);
%             end
%             numtruenegative = this.TN;
%         end
%        
%         % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%         function numpositive = numpositive(this)
%             if (this.numclasses ~= 2)
%                 st = dbstack;
%                 namestr = st.name;
%                 [filepath,name,ext] = fileparts(namestr); %#ok<ASGLU>
%                 err = MException(['CHI:',mfilename,':DimensionalityError'], ...
%                     [ext(2:end), ' cannot be calculated. Not a 2-class model.']);
%                 throw(err);
%             end
%             numpositive = this.numP;
%         end
%        
%         % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%         function numnegative = numnegative(this)
%             if (this.numclasses ~= 2)
%                 st = dbstack;
%                 namestr = st.name;
%                 [filepath,name,ext] = fileparts(namestr); %#ok<ASGLU>
%                 err = MException(['CHI:',mfilename,':DimensionalityError'], ...
%                     [ext(2:end), ' cannot be calculated. Not a 2-class model.']);
%                 throw(err);
%             end
%             numnegative = this.numN;
%         end
%         
%         % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
    end

end
