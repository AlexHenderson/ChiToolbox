function [mask,logmessage] = test(data,test,varargin)

% test  Performs a logical test on data.
%
% Syntax
%   [mask,logmessage] = test(data,test,value);
%   [mask,logmessage] = test(data,test,value1,value2);
%
% Description
%   [mask,logmessage] = test(data,test,value) performs a logical test on
%   data. data is a vector, or matrix, of values. test is a char array. The
%   options for test are listed below. value is the parameter used to test
%   data. mask is a ChiMask object. logmessage is a char array describing
%   the test performed.
% 
%   [mask,logmessage] = test(data,test,value1,value2) is used when there
%   are two values required for the test. value1 and value2 are sorted into
%   ascending order.
% 
% Notes
%   Available tests are:
%       '==' data is equal to value;
%       '~=' data is not equal to value;
%       '<'  data is less than value;
%       '>'  data is greater than value;
%       '<=' data is less than, or equal to, value;
%       '>=' data is greater than, or equal to, value;
%       'between' data is >= value1 AND data <= value2. Note that value1
%                 and value2 are sorted into ascending order;
%       'insiderange' same as between;
%       'inrange' same as between;
%       'outsiderange' data is < value1 OR data > value2. Note that value1
%                 and value2 are sorted into ascending order;
% 
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiMask.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox
    

% Note this is a static function 

    logmessage = 'ChiMask.test (data ';
    switch test
        case '=='
            mask = (data == varargin{1});
            logmessage = [logmessage, test, ' ', num2str(varargin{1})];
        case '~='
            mask = (data ~= varargin{1});
            logmessage = [logmessage, test, ' ', num2str(varargin{1})];
        case '<'
            mask = (data < varargin{1});
            logmessage = [logmessage, test, ' ', num2str(varargin{1})];
        case '>'
            mask = (data > varargin{1});
            logmessage = [logmessage, test, ' ', num2str(varargin{1})];
        case '<='
            mask = (data <= varargin{1});
            logmessage = [logmessage, test, ' ', num2str(varargin{1})];
        case '>='
            mask = (data >= varargin{1});
            logmessage = [logmessage, test, ' ', num2str(varargin{1})];
        case 'between'
            if (length(varargin) ~= 2)
                err = MException(['CHI:',mfilename,':IOError'], ...
                    'between requires two values.');
                throw(err);
            end
            a = varargin{1};
            b = varargin{2};
            [a,b] = utilities.forceincreasing(a,b);
            mask = (data >= a) & (data <= b);
            logmessage = [logmessage, test, ' ', num2str(a), ' and ', num2str(b)];
        case 'insiderange'
            if (length(varargin) ~= 2)
                err = MException(['CHI:',mfilename,':IOError'], ...
                    'insiderange requires two values.');
                throw(err);
            end
            a = varargin{1};
            b = varargin{2};
            [a,b] = utilities.forceincreasing(a,b);
            mask = (data >= a) & (data <= b);
            logmessage = [logmessage, test, ' ', num2str(a), ' to ', num2str(b)];
        case 'inrange'
            if (length(varargin) ~= 2)
                err = MException(['CHI:',mfilename,':IOError'], ...
                    'inrange requires two values.');
                throw(err);
            end
            a = varargin{1};
            b = varargin{2};
            [a,b] = utilities.forceincreasing(a,b);
            mask = (data >= a) & (data <= b);
            logmessage = [logmessage, test, ' ', num2str(a), ' to ', num2str(b)];
        case 'outsiderange'
            if (length(varargin) ~= 2)
                err = MException(['CHI:',mfilename,':IOError'], ...
                    'outsiderange requires two values.');
                throw(err);
            end
            a = varargin{1};
            b = varargin{2};
            [a,b] = utilities.forceincreasing(a,b);
            mask = (data < a) | (data > b);
            logmessage = [logmessage, test, ' ', num2str(a), ' to ', num2str(b)];
        otherwise
            err = MException(['CHI:',mfilename,':IOError'], ...
                'Test function not recognised.');
            throw(err);
    end
    
    logmessage = [logmessage, ')'];
    mask = ChiMask(mask);

end % function 
