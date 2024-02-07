function varargout = plotloading(this,cv,varargin)

% plotloading  Plots the canonical variate loading of your choice. 
%
% Syntax
%   plotloading(cv);
%   plotloading(cv,'nofig');
%   plotloading(____,'legacy');
%   plotloading(____,'bar');
%   handle = plotloading(____);
%
% Description
%   plotloading(cv) creates a 2-D line chart of the canonical variate cv in
%   a new figure window.
%
%   plotloading(cv,'nofig') plots the loading in the currently active
%   figure window, or creates a new figure if none is available.
%
%   plotloading(____,'legacy') plots the loading using the legacy method,
%   where segments are joined by a straight line.
% 
%   plotloading(____,'bar') generates a bar plot rather than a line plot.
%
%   handle = plotloading(____) returns a handle to the figure.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot/bar functions for more details. 
%
% Copyright (c) 2017-2023, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot bar plotscores plotexplainedvariance plotcumexplainedvariance
%   plotpcscores plotpcloading plotpcexplainedvariance
%   plotpccumexplainedvariance ChiPCCVAModel ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 3.0, April 2021
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    titlestub = 'Loading on canonical variate ';
    windowtitlestub = titlestub;
    ylabelstub = 'loading on CV ';
    errorcode = 'CHI:ChiPCCVAModel';
    errormessagestub = 'Requested canonical variate is out of range. Max CVs = ';

    barplot = false;

    if ~isempty(this.loadings)
        if ((cv > this.cvs) || (cv < 1))
            err = MException(errorcode, ...
                [errormessagestub, num2str(this.numcvs), '.']);
            throw(err);
        end

        % Do we want a legacy plot?
        legacy = false;
        argposition = find(cellfun(@(x) strcmpi(x, 'legacy') , varargin));
        if argposition
            legacy = true;
            % Remove the parameter from the argument list
            varargin(argposition) = [];
        end

        % Centroided data work best in legacy mode
        if this.iscentroided
            % Centroided data work best in legacy mode
            legacy = true;
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
        
        datatoplot = this.loadings(:,cv)';  % convert to row
        if barplot
            retval = utilities.barformatted(gca(),this.pca.xvals, datatoplot, varargin{:}); %#ok<NASGU>
        else
            if this.iscentroided
                legacy = true;
            end
            if legacy
                if this.iscentroided
                    retval = utilities.stemformatted(gca(),this.pca.xvals,datatoplot,varargin{:},'marker','none'); %#ok<NASGU>
                else
                    retval = utilities.plotformatted(gca(),this.pca.xvals, datatoplot, varargin{:}); %#ok<NASGU>
                end
                
            else
                % do a segmented plot 
                retval = utilities.plotsegments(gca(),this.pca.xvals, datatoplot, this.linearity, varargin{:}); %#ok<NASGU>
            end
        end
        
        if this.pca.reversex
            set(gca,'XDir','reverse');
        end
        
        if ~this.iscentroided
            utilities.tightxaxis;  
        end
        
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
    
%% Has the user asked for the figure handle?
if nargout
    varargout{1} = gcf();
end

end
