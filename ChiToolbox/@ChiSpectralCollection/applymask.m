function masked = applymask(varargin)

% applymask  Filters spectra using a logical mask.
%
% Syntax
%   masked = applymask(mask);
%
% Description
%   masked = applymask(mask) retains spectra based on the logical mask. Mask can be
%   a ChiMask, or a vector of logical values of the same length as the
%   number of spectra. True positions in the mask are retained in the
%   spectral collection, or a spectrum as appropriate. 
% 
% Copyright (c) 2019, Alex Henderson.
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
                masked = maskedclass(this.xvals,retaineddata,this.reversex,this.xlabelname,this.xlabelunit,this.ylabelname,this.ylabelunit);
            else
                % We are retaining a spectral collection
                masked = this.clone();
                masked.data = retaineddata;
            end
            
            % Remove the appropriate filenames if they exist
            if ~isempty(this.filenames)
                masked.filenames = this.filenames(masked.mask);
            end
            
            % Remove the appropriate classmemberships if they exist
            if ~isempty(this.classmembership)
                masked.classmembership.removeentries(mask.mask);
            end

            % Log what we did
            this.history.add('Masked');
            masked.history = this.history.clone();
            
        end    
    end
    
end % function
