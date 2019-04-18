function varargout = rmiesrestore(filename)

% [corrected,filename,info]

% TODO: add error checking for file presence etc
% TODO: add error checking for bad Condor output

% Need to load a .mat file with info in it relating to the original
% structure of the data?

%% Changes as of 9 Feb 2017
%   Checked for the size of the data output and preallocate memory. Slot
%   each job result directly into the output without using vertcat

%% Check for filename input
% if(~exist('filename','var'))
%    % default for debugging 
%     filename = 'E:\FTIR data\Caryn\fibroblasts\BEST FIBROBLAST INFO AND DATA\the_best\output\the_best_output_job_0.mat';
     
% end

if (nargout > 3)
    err = MException(['CHI:',mfilename,':IOError'], ...
        'Too many output variables. Maximum is 3.');
    throw(err);
end
    
if (~exist('filename', 'var'))
    filter = '*output_job_0.mat';
    filtername = 'RMieS Output Files (*output_job_0.mat)';
    filename = utilities.getfilenames(filter, filtername);
    
%     filename = getfilename(filter, filtername);
    if (isfloat(filename) && (filename == 0))
        % Nothing chosen
        return;
    end
end

filename = char(filename);

%% Get the original job name

% the output .mat files are called the_best_output_job_0.mat
% therefore the original job name was 'the_best'

[pathstr, name, ext] = fileparts(filename);
[start_idx, end_idx, extents, matches, tokens, names, splits] = regexp(name,'([\w|\-]+)_output_job_\d+', 'split');
original_jobname = char(names{1,1});

%% Get info if available

infoFilename = fullfile(pathstr,'info.mat');
if exist(infoFilename,'file')
    info = load(infoFilename);
end

%% Loop through all .mat files and rebuild the matrix

% output channels may not be the same as input channels

if exist('info','var')
    numSpectra = info.numspectra;

    finished = false;
    job_counter = 0;
    start = 1;
    
    while(~finished)
        % rebuild job filename
        job_filename = fullfile(pathstr,[original_jobname, '_output_job_', num2str(job_counter),ext]);
        if exist(job_filename,'file')
            if (job_counter == 0)
                % First time though we load the new wavenumbers and
                % allocate memory for the data matrix
                temp = load(job_filename,'WN_corr');
                wavenumbers_corr = temp.WN_corr;
                data_corr = zeros(numSpectra,length(wavenumbers_corr));
            end
            temp = load(job_filename,'history');
            history = temp.history;
            job_data = history(:,:,end);
            
            % Identify where in the output this job lies and put the data
            % there
            stop = start + size(job_data,1) - 1;
            data_corr(start:stop,:) = job_data;
            start = stop + 1;
            
            job_counter = job_counter + 1;
            disp(['Processing job number ', num2str(job_counter)]);
        else
            finished = true;
        end
    end    
    
else
    % This is the previous version but the data_corr variable increases
    % with every loop iteration
    finished = false;
    job_counter = 0;
    data_corr = [];
    while(~finished)
        % rebuild job filename
        job_filename = fullfile(pathstr,[original_jobname, '_output_job_', num2str(job_counter),ext]);
        if(exist(job_filename,'file'))
            temp = load(job_filename,'history');
            history = temp.history;
            job_data = history(:,:,end);
            data_corr = vertcat(data_corr,job_data); %#ok<AGROW>
            if(job_counter == 0)
                temp = load(job_filename,'WN_corr');
                wavenumbers_corr = temp.WN_corr;
            end
            job_counter = job_counter + 1;
            disp(['Processing job number ', num2str(job_counter)]);
        else
            finished = true;
        end
    end
end


switch nargout
    case 0
        utilities.warningnobacktrace('Corrected data will be placed in the ans variable.')
        % Create a Chi object
        if (size(data_corr,1) == 1)
            varargout{1} = ChiIRSpectrum(wavenumbers_corr,data_corr);
        else
            varargout{1} = ChiIRSpectralCollection(wavenumbers_corr,data_corr);
        end
    case 1
        % Create a Chi object
        if (size(data_corr,1) == 1)
            varargout{1} = ChiIRSpectrum(wavenumbers_corr,data_corr);
        else
            varargout{1} = ChiIRSpectralCollection(wavenumbers_corr,data_corr);
        end
    case 2
        % Create a Chi object
        if (size(data_corr,1) == 1)
            varargout{1} = ChiIRSpectrum(wavenumbers_corr,data_corr);
        else
            varargout{1} = ChiIRSpectralCollection(wavenumbers_corr,data_corr);
        end
        varargout{2} = filename;
    case 3
        % Create a Chi object
        if (size(data_corr,1) == 1)
            varargout{1} = ChiIRSpectrum(wavenumbers_corr,data_corr);
        else
            varargout{1} = ChiIRSpectralCollection(wavenumbers_corr,data_corr);
        end
        varargout{2} = filename;
        if exist('info','var')
            varargout{3} = info;
        else
            utilities.warningnobacktrace('No information was stored with the Condor jobs.');
            varargout{3} = [];
        end
end        
