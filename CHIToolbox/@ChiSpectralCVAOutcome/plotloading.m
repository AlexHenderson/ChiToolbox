function plotloading(this,cv,varargin)

% plotloading  Plots the canonical variate loading of your choice. 
%
% Syntax
%   plotloading(cv);
%   plotloading(cv,'nofig');
%
% Description
%   plotloading(cv) creates a 2-D bar chart of the canonical variate cv in
%   a new figure window.
%
%   plotloading(cv,'nofig') plots the loading in the currently active
%   figure window, or creates a new figure if none is available.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   bar function for more details. 
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   bar plotscores plotexplainedvariance plotcumexplainedvariance
%   plotpcscores plotpcloading plotpcexplainedvariance
%   plotpccumexplainedvariance ChiSpectralCVAOutcome ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    titlestub = 'Loading on canonical variate ';
    windowtitlestub = titlestub;
    ylabelstub = 'loading on CV ';
    errorcode = 'CHI:ChiSpectralCVAOutcome';
    errormessagestub = 'Requested canonical variate is out of range. Max CVs = ';

    if ~isempty(this.loadings)
        if ((cv > this.cvs) || (cv < 1))
            err = MException(errorcode, ...
                [errormessagestub, num2str(this.numcvs), '.']);
            throw(err);
        end

        argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
        if argposition
            % Remove the parameter from the argument list
            varargin(argposition) = [];
        else
            % No 'nofig' found so create a new figure
            windowtitle = [windowtitlestub, num2str(cv)];
            figure('Name',windowtitle,'NumberTitle','off');
        end
        
        datatoplot = this.loadings(:,cv);
        bar(this.PCAOutcome.xvals, datatoplot, varargin{:});
        if this.PCAOutcome.reversex
            set(gca,'XDir','reverse');
        end
        utilities.tightxaxis;
        xlabel(this.PCAOutcome.xlabel);        
        ylabel([ylabelstub, num2str(cv), ' (', num2str(this.explained(cv),3), '%)']);
        title([titlestub, num2str(cv)]);
        
    end
    
%% Manage data cursor information
figurehandle = gcf;
cursor = datacursormode(figurehandle);
set(cursor,'UpdateFcn',{@utilities.datacursor_6sf});    
    
end
