function area = measurearea(this,from,to)

% measurearea  Calculates the area under a section of the spectrum. 
%
% Syntax
%   area = measurearea(from,to);
%
% Description
%   area = measurearea(from,to) calculates the area under the region of the
%   spectrum delimited by the values from and to (inclusive), using a
%   linear baseline.
%   The parameters from and to are in xaxis units.
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   measureareaidx rangesum rangesumidx ChiSpectrum.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, July 2017
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    fromidx = indexat(this, from);
    toidx = indexat(this, to);

%     this.history.add(['measurearea from ', num2str(from), ' to ', num2str(to)]);
    area = measureareaidx(this,fromidx,toidx);
    
end
