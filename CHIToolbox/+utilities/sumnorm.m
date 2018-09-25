function normed_data = sumnorm(spectra)

% SUMNORM  Sum normalisation
% usage:
%     normed_data = sumnorm(spectra);
%
% input:
%     spectra - rows of spectra
% output:
%     normed_data - sum normalised version of data
%
%   The data is normalised such that the sum of the output is unity (1).
%
%   Copyright (c) 2004-2018, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 3.0 September 2018 Alex Henderson

% version 3.0 September 2018 Alex Henderson
%   Implemented in ChiToolbox
% version 2.0 May 2015, Alex Henderson
%   Vectorised the function
% version 1.0 October 2004, Alex Henderson
%   Initial implementation


% New version 2015

sparseinput = false;
if issparse(spectra)
    sparseinput = true;
end

% Sum the rows (spectra)
s = sum(spectra);

% Remove zeros that will cause a divide by zero error later. This isn't a
% problem since the only scenario whereby we can have positive values
% summing to zero is when the entire row is zero. Therefore, if we replace
% the sum with 1, we get lots of 0/1 values which is correct.
s(s==0) = 1;

% Create a multiplier
is = 1 ./ s;

% Generate a diagonal matrix. No point storing the zeros since this may
% cause problems with RAM
dis = spdiags(is,0,length(is),length(is));

% Calculate the normalised outcome
normed_data = spectra' * dis;

if sparseinput
    normed_data = sparse(normed_data);
else
    normed_data = full(normed_data);
end
