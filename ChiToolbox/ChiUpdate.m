function ChiUpdate()

% Function to update the code to the Master version on Bitbucket. 
% https://bitbucket.org/AlexHenderson/chitoolbox
% 
% We record where we are, work out where the ChiToolbox is located on the
% local hard drive and move to that location. Then we send a message to the
% Git program to update the code. Once done, we add the current path, with
% subfolders (in case any folders have been added or removed) to the search
% path and navigate back to the initial location.
% 
% Requires that the code was cloned from the repository on Bitbucket, not
% simply downloaded. The Git program is also required. This can be found
% at: https://git-scm.com/


% Store the current location for use later
whereWeStartedFrom = pwd();

try
    disp('Checking code repository for changes');

    % Check git is available
    [status,cmdout] = system('git --version'); %#ok<ASGLU>
    if status
        err = MException(['CHI:',mfilename,':ResourceError'], ...
            'The Git program is not available. Please install it and retry (https://git-scm.com/)');
        throw(err);
    end
    
    % Work out where this m-file is located
    filename = mfilename('fullpath');
    [pathstr,name,ext] = fileparts(filename); %#ok<ASGLU>

    % Move to that location. This is the root of the ChiToolbox
    cd(pathstr);
    
    % Connect to git repository and update codebase
	% Note this is a special user account and password that only allows for read-only commands
    status = system('git pull https://ChiToolboxManchesterRO:rnHQS7g8hk3PcYqzUcfd@bitbucket.org/AlexHenderson/chitoolboxmanchester.git master'); %#ok<NASGU>

    % Since the file and folder structure may have changed, rebuild the path
    disp('Rebuilding MATLAB path');
    addpath(genpath(pwd));
    savepath();
    
    % Return to the original directory
    cd(whereWeStartedFrom);
    disp('Done!');
catch ME
    % Return to the original directory
    cd(whereWeStartedFrom);

    % Report problem to user
    switch ME.identifier
        case ['CHI:',mfilename,':ResourceError']
            utilities.warningnobacktrace(ME.message);
        otherwise
            utilities.warningnobacktrace('Could not update ChiToolboxManchester');
    end    
end
    