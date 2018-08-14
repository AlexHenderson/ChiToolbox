classdef (Abstract) ChiAbstractFileFormat < handle

% ChiAbstractFileFormat  The base level for all file format readers
%
% Syntax
%   ChiAbstractFileFormat is an abstract class and cannot be instantiated. 
%
% Description
%   ChiAbstractFileFormat is the abstract base class for all file format
%   readers. Any class inheriting from this class will be automatically
%   discovered by the ChiFileReader class and included in options provided
%   to the user. 
%
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiFileReader ChiFile.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2018
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


    methods
        function name = className(this)
            name = this.className;
        end
    end
    
    methods (Static = true, Access = public)
        truefalse = isreadable(filename);
        obj = open(filename);
        extn = getExtension();
        filter = getFiltername();        
    end
    
end
