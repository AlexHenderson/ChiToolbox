function obj = poissonscale(this)

% poissonscale  Performs a scaling for Poisson noise
%
% Syntax
%   poissonscale();
%   obj = poissonscale();
%
% Description
%   poissonscale() Poisson scales the data.
% 
%   obj = poissonscale() clones the object before scaling. 
%
% Notes
%   Poisson scaling is useful for low count rate pulse counted data that is
%   subject to Poisson counting statistics. This approach relates to the
%   following paper: 
%     Accounting for Poisson noise in the multivariate analysis of ToF-SIMS
%     spectrum images
%     Michael R. Keenan and Paul G. Kotula 
%     Surf. Interface Anal. 36 (2004) 203–212 
%     https://doi.org/10.1002/sia.1657
% 
% Copyright (c) 2008-2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   sqrt quadrt nthroot.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


if nargout
    obj = this.clone();
    % Not a great approach, but quite generic. 
    % Prevents errors if the function name changes. 
    command = [mfilename, '(obj);']; 
    eval(command);  
else

    % Determine whether we should return a full, or sparse, matrix
    sparsedata = issparse(this.data);
    
    G = mean(this.data, 2);  % mean image
    H = mean(this.data, 1);  % mean spectrum

    % To prevent divide by zero errors
    G(G == 0) = 1;
    H(H == 0) = 1;
    
    GG = 1 ./ sqrt(G);
    HH = 1 ./ sqrt(H);

    % Using sparse to prevent out of memory errors
    GG = spdiags(GG, 0, length(GG), length(GG));
    HH = spdiags(HH', 0, length(HH), length(HH));

    % Dhat = (aG)^(-1/2) D (bH)^(-1/2)
    this.data = GG * this.data * HH;

    % Return a matrix of the original sparsity
    if sparsedata
        this.data = sparse(this.data);
    else
        this.data = full(this.data);
    end

end

end
