function varargout = rmiesrestore(filename)

% rmiesrestore  Manage RMieS corrected data returned from Condor pool. 
%
% Syntax
%   [corrected,iterations,filename,info] = rmiesrestore(filename);
%   [corrected,iterations,filename,info] = rmiesrestore();
%
% Description
%   [corrected,iterations,filename,info] = rmiesrestore(filename) rebuilds
%   the output from a RMieS correction performed on the Condor pool.
%   filename is of the format *_output_job_0.mat. Only the output from the
%   0th job is required; the other files will be handled appropriately. 
% 
%   [corrected,iterations,filename,info] = rmiesrestore() opens a dialog
%   box where the user can select the appropriate file. 
% 
%   The outputs contain the following:
%      -corrected is a ChiIRSpectralCollection, or ChiIRSpectrum depending
%       on whether one or more spectra were submitted for correction,
%       containing the RMieS output;
%      -iterations is a ChiRmiesIterations object containing the data at
%       various stages through the correction process;
%      -filename is the MAT file opened;
%      -info is a struct containing the information originally passed to
%       the rmiescondor submission system.
%
% Notes
%   The *_output_job_0.mat file can be found in the output folder of the
%   folder collection sent to Condor using rmiescondor. This is the same
%   location as the submit.txt file. 
% 
%   See http://condor.eps.manchester.ac.uk/ for more information regarding
%   the Condor pool
% 
%   See http://matchmaker.itservices.manchester.ac.uk/condorstatus/ to
%   monitor the currently active Condor tasks
% 
% Copyright (c) 2018-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiIRCharacter.rmiescondor, ChiRmiesIterations, RMieS_EMSC_v5, rmies, rmiesoptions 

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version April 2019
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolboxmanchester/

% TODO: add error checking for file presence etc
% TODO: add error checking for bad Condor output


if (nargout > 4)
    err = MException(['CHI:',mfilename,':IOError'], ...
        'Too many output variables. Maximum is 4.');
    throw(err);
end
    
if (~exist('filename', 'var'))
    filter = '*output_job_0.mat';
    filtername = 'RMieS Output Files (*output_job_0.mat)';
    filename = utilities.getfilenames(filter, filtername);
    
    if (isfloat(filename) && (filename == 0))
        return;
    end
end

filename = char(filename);

%% Get the original job name

% the output .mat files are called mydata_output_job_0.mat
% therefore the original job name was 'mydata'

[pathstr, name, ext] = fileparts(filename);
[start_idx, end_idx, extents, matches, tokens, names, splits] = regexp(name,'([\w|\-]+)_output_job_\d+', 'split'); %#ok<ASGLU>
original_jobname = char(names{1,1});

%% Get info if available

infoFilename = fullfile(pathstr,'info.mat');
if exist(infoFilename,'file')
    info = load(infoFilename);
else
    err = MException(['CHI:',mfilename,':IOError'], ...
        'The info.mat file is not present. Speak to Alex.');
    throw(err);
end

%% Loop through all .mat files and rebuild the matrix

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
            temp = load(job_filename,'WN_corr','history','correction_options');
            wavenumbers_corr = temp.WN_corr;
            data_corr = zeros(numSpectra,length(wavenumbers_corr));
            savehistory = temp.correction_options(13);
            if savehistory
                historydims = size(temp.history);
                if (length(historydims) == 3)
                    numiterations = historydims(3);
                else
                    numiterations = 1;
                end
                    history_corr = zeros(numSpectra,length(wavenumbers_corr),numiterations);
            end                    

        end
        temp = load(job_filename,'history');
        job_history = temp.history;
        job_data = job_history(:,:,end);

        % Identify where in the output this job lies and put the data
        % there
        stop = start + size(job_data,1) - 1;
        data_corr(start:stop,:) = job_data;
        if savehistory
            history_corr(start:stop,:,:) = job_history;
        end            
        start = stop + 1;

        job_counter = job_counter + 1;
        disp(['Processing job number ', num2str(job_counter)]);
    else
        finished = true;
    end
end    
    
%% Build the output
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
        % Export iteration history
        iterations = ChiRmiesIterations(numiterations);
        if savehistory
            if (size(data_corr,1) == 1)
                % Only corrected a single spectrum
                for i = 1:numiterations
                    iterations.append(ChiIRSpectrum(wavenumbers_corr,history_corr(:,i)));
                end
            else
                for i = 1:numiterations
                    iterations.append(ChiIRSpectralCollection(wavenumbers_corr,history_corr(:,:,i)));
                end
            end
        else
            % Simply replicate the corrected data
            iterations = ChiRmiesIterations(varargout{1});
        end
        varargout{2} = iterations;
        
    case 3
        % Create a Chi object
        if (size(data_corr,1) == 1)
            varargout{1} = ChiIRSpectrum(wavenumbers_corr,data_corr);
        else
            varargout{1} = ChiIRSpectralCollection(wavenumbers_corr,data_corr);
        end
        % Export iteration history
        iterations = ChiRmiesIterations(numiterations);
        if savehistory
            if (size(data_corr,1) == 1)
                % Only corrected a single spectrum
                for i = 1:numiterations
                    iterations.append(ChiIRSpectrum(wavenumbers_corr,history_corr(:,i)));
                end
            else
                for i = 1:numiterations
                    iterations.append(ChiIRSpectralCollection(wavenumbers_corr,history_corr(:,:,i)));
                end
            end
        else
            % Simply replicate the corrected data
            iterations = ChiRmiesIterations(varargout{1});
        end
        varargout{2} = iterations;
        
        varargout{3} = filename;
    case 4
        % Create a Chi object
        if (size(data_corr,1) == 1)
            varargout{1} = ChiIRSpectrum(wavenumbers_corr,data_corr);
        else
            varargout{1} = ChiIRSpectralCollection(wavenumbers_corr,data_corr);
        end
        % Export iteration history
        iterations = ChiRmiesIterations(numiterations);
        if savehistory
            if (size(data_corr,1) == 1)
                % Only corrected a single spectrum
                for i = 1:numiterations
                    iterations.append(ChiIRSpectrum(wavenumbers_corr,history_corr(:,i)));
                end
            else
                for i = 1:numiterations
                    iterations.append(ChiIRSpectralCollection(wavenumbers_corr,history_corr(:,:,i)));
                end
            end
        else
            % Simply replicate the corrected data
            iterations = ChiRmiesIterations(varargout{1});
        end
        varargout{2} = iterations;
        
        varargout{3} = filename;
        
        if exist('info','var')
            varargout{4} = info;
        else
            utilities.warningnobacktrace('No information was stored with the Condor jobs.');
            varargout{4} = [];
        end
end        
