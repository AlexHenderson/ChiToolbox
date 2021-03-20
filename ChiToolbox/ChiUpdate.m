function ChiUpdate()

% Function to update the code to the Master version on Bitbucket. 
% https://bitbucket.org/AlexHenderson/chitoolbox
% 
% This file should be in chitoolbox/ChiToolbox
% First we determine whether Git is available. 
% We get the location of this file and tell Git to update the repository in
% that location. 
% Once done, we add the current path, with subfolders (in case any folders
% have been added or removed) to the search path and navigate back to the
% initial location.
% 
% Requires that the code was cloned from the repository on Bitbucket, not
% simply downloaded. The Git program is also required. This can be found
% at: https://git-scm.com/


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

    % Connect to git repository and pull down the most recent version of
    % the master branch
    command = ['git -C "', pathstr, '" pull origin master'];
    [status,cmdout] = system(command); %#ok<ASGLU>
    
    % Since the file and folder structure may have changed, rebuild the path
    disp('Rebuilding MATLAB path');
    addpath(genpath(pathstr));
    savepath();
    
    disp('Done!');
catch ME
    % Report problem to user
    switch ME.identifier
        case ['CHI:',mfilename,':ResourceError']
            utilities.warningnobacktrace(ME.message);
        otherwise
            utilities.warningnobacktrace('Could not update ChiToolbox');
    end    
end
    