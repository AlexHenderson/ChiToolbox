function prediction = predict(varargin)


% If data has a classmembership we could consider this to be a test and
% report classification accuracy. 

%% Do we have the machine learning toolbox
if ~exist('TreeBagger','file')
    err = MException(['CHI:',mfilename,':InputError'], ...
        'The Statistics and Machine Learning Toolbox is required for this function.');
    throw(err);
end

%% Manage arguments
this = varargin{1};
classifyme = varargin{2}; % ChiSpectralCollection

%%
% %% Defaults
% useparallel = -1;   % auto configure
% 
% %% User requested parameters
% argposition = find(cellfun(@(x) strcmpi(x, 'parallel') , varargin));
% if argposition
%     if ~exist('parpool','file')
%         utilities.warningnobacktrace('The Parallel Computing Toolbox is required to use parallel processing.');
%         useparallel = false;
%     else
%         useparallel = true;
%     end
%     varargin(argposition) = [];
% end
% 
% %% Determine whether to automatically use the parallel pool
% % Need to balance the benefits of using the parallel pool with the time
% % taken to start it up and wind it down. 
% if useparallel == -1
%     % User did not specify use of the pool
%     if ((numtrees * this.numspectra) > 5000000)
%         % Data seems quite large
%         if exist('parpool','file')
%             % We have access to the pool
%             useparallel = true;
%         else 
%             useparallel = false;
%         end
%     else
%         useparallel = false;
%     end
% end
% 
% %% Open parallel pool
% if useparallel
%     poolobj = parpool;
%     paroptions = statset('UseParallel',true);
% else
%     paroptions = statset();
% end

%% Predict
predictiontimer = tic();

if isa(this.model,'TreeBagger')
	[pred,scores,stdevs] = predict(this.model,classifyme.data);
	pred = str2num(cell2mat(pred)); %#ok<ST2NM>
else	% fitcensemble
	[pred,scores] = predict(this.model,classifyme.data);
	stdevs = zeros(size(scores));
end
	

[predictiontime,predictionsec] = tock(predictiontimer);

prediction = ChiRFPrediction(...
                pred, ...
                scores, ...
                stdevs, ...
                this.classmembership, ...
                predictiontime,...
                predictionsec);

end
