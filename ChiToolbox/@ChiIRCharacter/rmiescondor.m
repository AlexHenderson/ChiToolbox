function [jobname,localpath] = rmiescondor(this,username,varargin)

% rmiescondor  Resonant Mie scattering correction for infrared spectroscopy
%
% Syntax
%   rmiescondor(username);
%   rmiescondor(____,options);
%   rmiescondor(____,reference);
%   rmiescondor(____,localpath);
%   rmiescondor(____,spectraPerJob);
%   [jobname,localpath] = rmiescondor(____);
%
% Description
%   rmiescondor(username) performs a resonant Mie scattering
%   correction on the data using the UoM Condor high throughput facility.
%   username is a UoM username that has been activated for Condor access.
%   A default rmiesoptions object and the internal Matrigel reference are
%   used. The user is prompted for a temporary location on the local
%   machine to store the files prior to transfer to the Condor system. A
%   default value of 200 spectra per Condor job is used.
% 
%   rmiescondor(____,options) perform the correction using the
%   provided options. options is a rmiesoptions object.
% 
%   rmiescondor(____,reference) uses the provided reference spectrum.
%   reference is a ChiSpectrum.
% 
%   rmiescondor(____,localpath) uses the provided location the local
%   machine to store the files prior to transfer to the Condor system.
% 
%   rmiescondor(____,spectraPerJob) creates individual Condor jobs
%   containing spectraPerJob spectra.
% 
%   [jobname,localpath] = rmiescondor(____) returns jobname which is the
%   name of the root folder of the Condor job collection and localpath the
%   location of the Condor job collection on the local drive.
% 
% Version 5 of the RMieS algorithm used is available from
% https://github.com/GardnerLabUoM/RMieS. 
%
% Notes
% See http://condor.eps.manchester.ac.uk/ for more information regarding
% the Condor pool
% 
% See http://matchmaker.itservices.manchester.ac.uk/condorstatus/ to monitor the
% currently active Condor tasks
% 
% Caution
%   Using a single iteration, each spectrum utilises the same reference
%   spectrum. For subsequent iterations each spectrum utilises its previous
%   iteration as a starting point. This means multiple iterations will take
%   a (*very*) long time to complete for many spectra. Therefore it may be
%   prudent to explore the time taken with a small number of spectra and
%   iterations before moving to larger datasets. 
%
% Copyright (c) 2018-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   RMieS_EMSC_v5, rmies, rmiesoptions 

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 3.0, March 2019
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolboxmanchester/


%% Check input
if (nargin < 1)
    err = MException(['Chi:',mfilename,':InputError'], ...
        'You need to provide UoM user name.');
    throw(err);
end

if ~ischar(username)
    err = MException(['Chi:',mfilename,':InputError'], ...
        'A University of Manchester user name that has been activated for Condor is required.');
    throw(err);
end

%% Set some defaults
rmiesOptions = rmiesoptions();
reference = [];
localpath = [];
spectra_per_job = 200;

%% Read the additional user supplied data
% Conveniently these are all different types
if ~isempty(varargin)
    % Is an options object supplied?
    argposition = find(cellfun(@(x) isa(x, 'rmiesoptions'), varargin));
    if argposition
        rmiesOptions = varargin{argposition};
        varargin(argposition) = [];
    end
    
    % Is a reference supplied?
    argposition = find(cellfun(@(x) isa(x, 'ChiSpectrum'), varargin));
    if argposition
        reference = varargin{argposition};
        varargin(argposition) = [];
    end

    % Is a local path supplied?
    argposition = find(cellfun(@(x) ischar(x), varargin));
    if argposition
        localpath = varargin{argposition};
        varargin(argposition) = [];
    end
    
    % Is a spectra_per_job value supplied?
    argposition = find(cellfun(@(x) isnumeric(x), varargin));
    if argposition
        spectra_per_job = varargin{argposition};
        varargin(argposition) = [];
    end
    
    if length(varargin) %#ok<ISMT>
        utilities.warningnobacktrace('Some parameters were not used.');
    end
end

%% Generate a log entry
log = {};
log = vertcat(log,'rmies correction:');

if isempty(reference)
    log = vertcat(log,'    Internal reference (Matrigel)');
else
    if isempty(reference.filenames)
        log = vertcat(log,'    External reference: user supplied');
    else
        log = vertcat(log,['    External reference: ', reference.filenames{1}]);
    end
end

props = properties(rmiesOptions);
for i = 1:length(props)
    str = ['rmiesOptions.',props{i}];
    val = eval(str);
    historyString = ['    ', props{i},' = ', num2str(val)];
    log = vertcat(log,historyString); %#ok<AGROW>
end

%% Contort the data into the 'RMieS for Condor' layout

% Generate a job name that will act as the foldername
jobname = [username, '_', datestr(now, 'yyyy-mm-dd'), '_', datestr(now, 'hh-MM-ss')];

% Get a location to put the files ready to transfer to Condor
if isempty(localpath)
    localpath = uigetdir([],'Select a location for the Condor files. ');
    if localpath == 0
        err = MException(['Chi:',mfilename,':InputError'], ...
            'You need to provide a location for the Condor files on your local drive.');
        throw(err);
    end
end

localpath = fullfile(localpath, jobname);

% Generate the folders to take the Condor files
% Check folder doesn't already exist
if exist(localpath,'dir')
    err = MException(['Chi:',mfilename,':InputError'], ...
        'The localpath already exists. Please provide another.');
    throw(err);
end

localinputfolder = fullfile(localpath,'input');
localoutputfolder = fullfile(localpath,'output');
localerrorfolder = fullfile(localpath,'error');

[status,msg,msgID] = mkdir(localpath);
if (status ~= 1)
    err = MException(msgID, msg);
    throw(err);
end
[status,msg,msgID] = mkdir(localinputfolder);
if (status ~= 1)
    err = MException(msgID, msg);
    throw(err);
end
[status,msg,msgID] = mkdir(localoutputfolder);
if (status ~= 1)
    err = MException(msgID, msg);
    throw(err);
end
[status,msg,msgID] = mkdir(localerrorfolder);
if (status ~= 1)
    err = MException(msgID, msg);
    throw(err);
end

% Create the appropriate options file
correction_options = rmiesOptions.exportv1(); %#ok<NASGU>
save(fullfile(localinputfolder,'options.mat'),'correction_options');
save(fullfile(localoutputfolder,'options.mat'),'correction_options');

% Create the appropriate reference file
if isempty(reference)
    rmiespath = fileparts(which('RMieS_EMSC_v5.m'));
    matrigelpath = fullfile(rmiespath,'private/Matrigel_Reference_Raw.mat');
    if ~exist(matrigelpath,'file')
        err = MException(['Chi:',mfilename,':InputError'], ...
            'Cannot find default Matrigel file.');
        throw(err);
    end
    copyfile(matrigelpath,fullfile(localinputfolder,'ref.mat'));
    copyfile(matrigelpath,fullfile(localoutputfolder,'ref.mat'));
else
    ZRef_Raw = [ChiForceToColumn(reference.wavenumbers),ChiForceToColumn(reference.data)]; %#ok<NASGU>
    save(fullfile(localinputfolder,'ref.mat'),'ZRef_Raw');    
    save(fullfile(localoutputfolder,'ref.mat'),'ZRef_Raw');    
end

%% Generate separate jobs for collections of spectra
number_jobs = generate_condor_jobs(this.data, this.wavenumbers, jobname, localinputfolder, spectra_per_job);

%% Create the submit file
condor_submit_template(localoutputfolder, localerrorfolder, jobname, number_jobs, username);

%% Save some info on the task to assist when reading the data back in using rmiesrestore
channels = this.numchannels; %#ok<NASGU>
numspectra = this.numspectra; %#ok<NASGU>

infoFilename = fullfile(localoutputfolder,'info.mat');
save(infoFilename,'numspectra','channels','number_jobs','log','this');

%% Display a message to the user telling them what to do next
disp('Next steps:');
disp(['1. Copy the entire contents of the ', localpath, ' folder to the Condor submit node. From a Windows PC you can use WinSCP']);
disp('2. Log into the submit node using Putty');
disp(['3. On the Condor submit node, navigate to the output folder: <somewhere>/', jobname, '/output']);
disp('4. Run this command: condor_submit submit.txt'); 
disp('5. Monitor the progress at <a href="http://matchmaker.itservices.manchester.ac.uk/condorstatus/">http://matchmaker.itservices.manchester.ac.uk/condorstatus/</a>');

end % function rmiescondorcondor

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ~~~~~~~~~~~~~~~~~~~~~ generate_condor_jobs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function number_jobs = generate_condor_jobs(data, wavenumbers, name_of_map, inputpath, spectra_per_job)

% The output MAT files require certain variables to be present so that the
% RMieS program will recognise them correctly. These are:
% WN_Raw, ZRaw, Spectra_indices, filename, number_jobs, job_number, name_of_map, total_number_spectra
% Any changes to the name or content of these variables will require a
% change to the RMieS program.

%% Ensure that none of the spectra have negative absorbance values
data = add_minimum(data);

%% Job count
% For 100 iterations we can process about 32 spectra in an hour
numspectra = size(data,1);
number_jobs = ceil(numspectra / spectra_per_job);

%% Write job files
total_number_spectra = numspectra; %#ok<NASGU>
WN_Raw = wavenumbers; %#ok<NASGU>
finished = false;
startidx = 1;
job_number = 0;
while (~finished)
    stopidx = min((startidx+spectra_per_job-1), numspectra);

    Spectra_indices = (startidx:stopidx)';
    how_many = length(Spectra_indices);       
    ZRaw = data(startidx:stopidx,:); %#ok<NASGU>

    filename = [name_of_map, '_job_', num2str(job_number)];
    jobfilename = fullfile(inputpath, filename);
    save(jobfilename, 'WN_Raw', 'ZRaw', 'Spectra_indices', 'filename', 'number_jobs', 'job_number', 'name_of_map', 'total_number_spectra');
    
    disp([filename,' : Spectra ',num2str(startidx),' to ',num2str(stopidx),' (',num2str(how_many),' spectra)'])

    startidx = stopidx + 1;
    job_number = job_number + 1;
    if (stopidx == numspectra)
        finished = true;
    end
end

%% Write submission command file to be executed on Condor submit node
% % Can't run this on the submit node without changing permissions,
% % therefore, no point in writing it. 
%
% flycondorfilename = [local_job_dir, 'flycondor.cmd'];
% fid = fopen(flycondorfilename, 'w');
% fprintf(fid, 'cd /home/%s/Condor/%s/output/\n', username, name_of_map);
% fprintf(fid, 'condor_submit submit.txt\n');
% fclose(fid);

end % function generate_condor_jobs

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ~~~~~~~~~~~~~~~~~~~~~~~~~~ add_minimum ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function data = add_minimum(data)

for i = 1:size(data,1)
    row = data(i,:);
    if min(row) < 0
        row = row + abs(min(row)) + 0.001;
        data(i,:) = row;
    end
end

end % function add_minimum

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ~~~~~~~~~~~~~~~~~~~~~ condor_submit_template ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function condor_submit_template(output_dir, error_dir, name_of_map, number_jobs, username)

% Using hardcoded forward slashes since these paths are looked at on Linux

fid = fopen(fullfile(output_dir,'submit.txt'), 'w');

fprintf(fid, 'universe = vanilla\n');

fprintf(fid, 'requirements = (Opsys == "LINUX" && Arch == "X86_64" && HAS_MATLAB=?=True && HAS_STANDARD_IMAGE =?= True)  \n');   % Before checkpointing
% 05/08/11 fprintf(fid, 'requirements = (Opsys == "LINUX" && Arch == "X86_64" && HAS_MATLAB=?=True)\n');   % Before checkpointing
%fprintf(fid, 'requirements = (Opsys == "LINUX" && Arch == "X86_64" && HAS_MATLAB=?=True && HAS_CHECKPOINTING =?= True)\n');
fprintf(fid, 'notification = never\n');

fprintf(fid, 'request_memory = 2000\n'); % added by Alex 31/10/12 see http://condor.eps.manchester.ac.uk/general/all-you-need-to-know-about-memory/

%fprintf(fid, 'nice_user = True\n');

% fprintf(fid, 'executable = /home/%s/Condor_exec/run_RMieS_condor_pro_new.sh\n', username);
if strcmpi(username,'mcdssah')
%     fprintf(fid, 'executable = /mnt/iusers01/ceas01/%s/scratch/Condor_exec/run_RMieS_condor_pro_new_v713.sh\n', username);
    fprintf(fid, 'executable = /home/%s/Condor_exec/run_RMieS_condor_pro_new_v713.sh\n', username);
else
    fprintf(fid, 'executable = /mnt/iusers01/condor01/%s/scratch/Condor_exec/run_RMieS_condor_pro_new_v713.sh\n', username);
end

% fprintf(fid, 'transfer_files = always\n');

if strcmpi(username,'mcdssah')
    condorpath = ['/home/', username, '/Condor'];
else
    condorpath = ['/mnt/iusers01/condor01/', username, '/scratch/Condor'];
end

% program_location = ['transfer_input_files = /home/', username, '/Condor_exec/RMieS_condor_pro_new'];
if strcmpi(username,'mcdssah')
    program_location = ['transfer_input_files = /home/', username, '/Condor_exec/RMieS_condor_pro_new, /home/', username, '/Condor_exec/mcr713.tar.gz'];
else
    program_location = ['transfer_input_files = /mnt/iusers01/condor01/', username, '/scratch/Condor_exec/RMieS_condor_pro_new, /mnt/iusers01/condor01/', username, '/scratch/Condor_exec/mcr713.tar.gz'];
end

jobfile = [condorpath, '/', name_of_map, '/input/', name_of_map, '_job_$(process).mat'];
optionsfile = [condorpath, '/', name_of_map, '/input/options.mat'];
referencefile = [condorpath, '/', name_of_map, '/input/ref.mat'];

fprintf(fid, '%s, %s, %s, %s\n', program_location, jobfile, optionsfile, referencefile);

% fprintf(fid, 'arguments = /opt/MATLAB/MATLAB_Compiler_Runtime/v713 %s $(process) ref.mat options.mat\n', name_of_map);
fprintf(fid, 'arguments = %s $(process) ref.mat options.mat\n', name_of_map);

% #/Users/paulbassan/Documents/MATLAB/y_2f/input/
% output = OUTPUT.out
fprintf(fid, 'output = _%s_output_file.txt\n', name_of_map);
%fprintf(fid, strcat('output = _',name_of_map,'_output_file.txt\n'));

% log = y_2f_LOG.log
fprintf(fid, 'log = _%s_log_file.txt\n', name_of_map);
%fprintf(fid, strcat('log = _',name_of_map,'_log_file.txt\n'));

line = 'error = ../error/_error_file_$(process).txt\n';
fprintf(fid, line);

% queue number of jobs
fprintf(fid, 'queue %i\n', number_jobs);

fclose(fid);

end % function: condor_submit_template
