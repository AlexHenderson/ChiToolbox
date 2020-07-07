function plotloading(this,cv,varargin)

% plotloading  Plots the canonical variate loading of your choice. 
%
% Syntax
%   plotloading(cv);
%   plotloading(cv,'nofig');
%   plotloading(____,'bar');
%
% Description
%   plotloading(cv) creates a 2-D line chart of the canonical variate cv in
%   a new figure window.
%
%   plotloading(cv,'nofig') plots the loading in the currently active
%   figure window, or creates a new figure if none is available.
%
%   plotloading(____,'bar') generates a bar plot rather than a line plot.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot/bar functions for more details. 
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot bar plotscores plotexplainedvariance plotcumexplainedvariance
%   plotpcscores plotpcloading plotpcexplainedvariance
%   plotpccumexplainedvariance ChiSpectralCVAModel ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 2.0, September 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    titlestub = 'Loading on canonical variate ';
    windowtitlestub = titlestub;
    ylabelstub = 'loading on CV ';
    errorcode = 'CHI:ChiSpectralCVAModel';
    errormessagestub = 'Requested canonical variate is out of range. Max CVs = ';

    barplot = false;

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
        
        argposition = find(cellfun(@(x) strcmpi(x, 'bar') , varargin));
        if argposition
            % Remove the parameter from the argument list
            varargin(argposition) = [];
            barplot = true;
        end
        
        datatoplot = this.loadings(:,cv);
        if barplot
            bar(this.pca.xvals, datatoplot, varargin{:});
        else
            plot(this.pca.xvals, datatoplot, varargin{:});
        end
        
        if this.pca.reversex
            set(gca,'XDir','reverse');
        end
        utilities.tightxaxis;
        
        if ~barplot
            utilities.drawy0axis(axis);
        end
        
        xlabel(this.pca.xlabel);        
        ylabel([ylabelstub, num2str(cv), ' (', num2str(this.explained(cv),3), '%)']);
        title([titlestub, num2str(cv)]);
        
    end
    
%% Manage data cursor information
figurehandle = gcf;
cursor = datacursormode(figurehandle);
set(cursor,'UpdateFcn',{@utilities.datacursor_6sf});    
    
end
