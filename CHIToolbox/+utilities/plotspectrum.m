function plotspectrum(this,varargin)

% plot  Plots one, or more, spectra. Multiple spectra are overlaid. 
%
% Syntax
%   plotspectrum();
%   plotspectrum('nofig');
%
% Description
%   plotspectrum() creates a 2-D line plot of the ChiSpectrum, or
%   ChiSpectralCollection, object in a new figure window.
%
%   plotspectrum('nofig') plots the spectrum in the currently active figure
%   window, or creates a new figure if none is available.
%
%   Other parameters can be applied to customise the plot. See the MATLAB
%   plot function for more details. 
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   plot ChiSpectrum ChiSpectralCollection.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/agilent-file-formats

% varargin management borrowed from here:
% https://uk.mathworks.com/matlabcentral/answers/127878-interpreting-varargin-name-value-pairs

argposition = find(cellfun(@(x) strcmpi(x, 'nofig') , varargin));
if argposition
    % Remove the parameter from the argument list
    varargin(argposition) = [];
else
    % No 'nofig' found so create a new figure
    figure;
end

    plot(this.xvals,this.data,varargin{:});
    axis tight;
    if this.reversex
        set(gca,'XDir','reverse');
    end
    if ~isempty(this.xlabel)
        set(get(gca,'XLabel'),'String',this.xlabel);
    end
    if ~isempty(this.ylabel)
        set(get(gca,'YLabel'),'String',this.ylabel);
    end

end
