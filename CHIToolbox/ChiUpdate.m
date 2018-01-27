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

here = pwd();
filename = mfilename('fullpath');
[pathstr,name,ext] = fileparts(filename);
cd(pathstr);
system('git pull origin master');
addpath(genpath(pwd));
savepath();
cd(here);
