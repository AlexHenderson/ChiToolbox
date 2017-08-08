function plotloading(this,pc,varargin)

% plotloading  Plots the principal component loading of your choice. 
%
% Syntax
%   plotloading(pc);
%   plotloading(pc,'nofig');
%
% Description
%   plotloading(pc) creates a 2-D bar chart of the principal component
%   pc in a new figure window.
%
%   plotloading(pc,'nofig') plots the loading in the currently active
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
%   ChiSpectralPCAOutcome ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox

    titlestub = 'Loading on principal component ';
    windowtitlestub = titlestub;
    ylabelstub = 'loading on PC ';
    errorcode = 'CHI:ChiSpectralPCAOutcome';
    errormessagestub = 'Requested principal component is out of range. Max PCs = ';

    if ~isempty(this.loadings)
        if ((pc > this.numpcs) || (pc < 1))
            err = MException([errorcode,':OutOfRange'], ...
                [errormessagestub, num2str(this.numpcs), '.']);
            throw(err);
        end

        argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
        if argposition
            % Remove the parameter from the argument list
            varargin(argposition) = [];
        else
            % No 'nofig' found so create a new figure
            windowtitle = [windowtitlestub, num2str(pc)];
            figure('Name',windowtitle,'NumberTitle','off');
        end
        
        datatoplot = this.loadings(:,pc);
        bar(this.xvals, datatoplot, varargin{:});
        if this.reversex
            set(gca,'XDir','reverse');
        end
        utilities.tightxaxis;
        xlabel(this.xlabel);        
        ylabel([ylabelstub, num2str(pc), ' (', num2str(this.explained(pc),3), '%)']);
        title([titlestub, num2str(pc)]);
        
    end
    
%% Manage data cursor information
figurehandle = gcf;
cursor = datacursormode(figurehandle);
set(cursor,'UpdateFcn',{@utilities.datacursor_6sf});    
    
end
