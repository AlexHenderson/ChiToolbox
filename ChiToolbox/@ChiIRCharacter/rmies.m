function varargout = rmies(this,varargin)

% rmies  Resonant Mie scattering correction for infrared spectroscopy
%
% Syntax
%   rmies();
%   rmies(____,options);
%   rmies(____,reference);
%   rmies(options,reference);
%   [corrected] = rmies(____);
%   [corrected,iterations] = rmies(____);
%
% Description
%   rmies() performs a resonant Mie scattering correction on the data. A
%   default rmiesoptions object and the internal Matrigel reference are
%   used.
% 
%   rmies(____,options) perform the correction using the provided options.
%   options is a rmiesoptions object. 
% 
%   rmies(____,reference) uses the provided reference spectrum. reference
%   is a ChiSpectrum. 
% 
%   [corrected] = rmies(____) clones the data and performs the correction
%   on the clone. The original data is not modified. 
% 
%   [corrected,iterations] = rmies(____) return the iteration history in a
%   ChiRmiesIterations object. 
% 
% Version 5 of the RMieS algorithm used is available from
% https://github.com/GardnerLabUoM/RMieS. 
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
%   RMieS_EMSC_v5, rmiesoptions.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 2.0, February 2019
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


%% Has the user requested the iteration history to be saved? 
% If so we need to manage its location in the output. 
rmiesOptions = rmiesoptions();
iterationHistoryRequested = false;
if ~isempty(varargin)
    % Is an options object supplied?
    argposition = find(cellfun(@(x) isa(x, 'rmiesoptions'), varargin));
    if argposition
        rmiesOptions = varargin{argposition};
        iterationHistoryRequested = rmiesOptions.savehistory;
    end
end

if (iterationHistoryRequested && (nargout ~= 2))
    % The user asked for the history, but there is nowhere to put it. 
    stacktrace = dbstack;
    functionname = stacktrace.name;
    err = MException(['CHI:',mfilename,':IOError'], ...
        'Nowhere to put the iteration history. Try something like: [corrected,iterations] = %s(options,reference);',functionname);
    throw(err);
end

if (~iterationHistoryRequested && (nargout == 2))
    % The user provided an output for history, but didn't request it to be
    % calculated. Change the options and calculate it anyway. 
    message = ['Options suggests no iteration history is required, ' ...
               'but a variable for it has been provided. ' ...
               'Changing options to return iteration history. '];
    utilities.warningnobacktrace(message);
    rmiesOptions.savehistory = true;
    iterationHistoryRequested = true;
end

%% Route the various calculation pathways

switch nargout
    case 0
        % We wish to scatter-correct this object in-situ
        this.rmiescalculation(rmiesOptions,varargin{:});
    case 1
        % We wish to create a new object (a clone) and scatter-correct that
        temp = this.clone();
        varargout{1} = temp.rmiescalculation(rmiesOptions,varargin{:});
    case 2
        % We wish to create a new object (a clone) and scatter-correct that
        temp = this.clone();
        if iterationHistoryRequested
            [corrected,iterations] = temp.rmiescalculation(rmiesOptions,varargin{:});
            varargout{1} = corrected;
            varargout{2} = iterations;
        else
            [varargout{1}] = temp.rmiescalculation(rmiesOptions,varargin{:});
        end
    otherwise
        err = MException(['CHI:',mfilename,':IOError'], ...
            'Too many output arguments');
        throw(err);
end
    
end % function rmies
