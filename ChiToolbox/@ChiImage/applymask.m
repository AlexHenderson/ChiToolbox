function masked = applymask(varargin)

% applymask  Filters pixels using a logical mask.
%
% Syntax
%   masked = applymask(mask);
%
% Description
%   masked = applymask(mask) retains pixels (spectra) based on the logical
%   mask. mask can be a ChiMask, a matrix of the same 2D dimensions of the
%   image, or a vector of logical values of the same length as the number
%   of spectra.
%   masked is a spectral collection, or spectrum where appropriate, where
%   true positions in the mask have been retained.
% 
% Copyright (c) 2014-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiMask

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox

    
% Do we have somewhere to put the data?
if ~nargout
    stacktrace = dbstack;
    functionname = stacktrace.name;
    err = MException(['CHI:',mfilename,':IOError'], ...
        'Nowhere to put the output. Try something like: mymask = %s(mask);',mfilename);
    throw(err);
end
            
if (nargin ~= 2)
     err = MException(['CHI:',mfilename,':IOError'], ...
        'No mask was provided.');
    throw(err);
end    

this = varargin{1};
mask = varargin{2};

    if ~isa(mask,'ChiMask')
        mask = ChiMask(mask);
    end
    
    if (this.numspectra ~= length(mask.data))
         err = MException(['CHI:',mfilename,':IOError'], ...
            'The mask is the wrong size for these data.');
        throw(err);
    end

    if ((this.xpixels ~= mask.xpixels) || (this.ypixels ~= mask.ypixels))
         err = MException(['CHI:',mfilename,':IOError'], ...
            'The dimensions of the mask do not match the data.');
        throw(err);
    end

    if (mask.numfalse == 0)
        utilities.warningnobacktrace('The mask is entirely true, there is nothing to remove.');
        masked = this.clone();
    else
        if (mask.numtrue == 0)
             err = MException(['CHI:',mfilename,':IOError'], ...
                'The mask is entirely false. Cannot remove all data.');
            throw(err);
        else
            retaineddata = this.data(mask.mask,:);
            if (mask.numtrue == 1)
                % We are only retaining a single spectrum
                maskedclass = str2func(this.spectrumclassname);
            else
                % We are retaining a spectral collection
                maskedclass = str2func(this.spectralcollectionclassname);
            end
            masked = maskedclass(this.xvals,retaineddata,this.reversex,this.xlabelname,this.xlabelunit,this.ylabelname,this.ylabelunit);
            masked.filenames = this.filenames;
            this.history.add('Masked');
            masked.history = this.history.clone();
        end    
        
    end
    
end % function
