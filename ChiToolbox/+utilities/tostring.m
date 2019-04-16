function str = tostring(input)

% tostring  Converts various inputs to a string
%
% Syntax
%   str = tostring(input);
%
% Description
%   str = tostring(input) converst various inputs to a single char string.
% 
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   is

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


% The order of these if statements is important. For example, isnumeric
% will return true for a vector of numbers, so we must check whether we
% have a scalar before we check if we have a number. 
% We need to re-enter this function recursively, so short circuit with
% return if we have handled the input.

if ischar(input)
    str = input;
    return;
end

if islogical(input)
    if input
        str = 'true';
    else
        str = 'false';
    end
    return;
end

% Convert a cell array of string to a single string surrounded by braces
% and separated by commas
if iscellstr(input) %#ok<ISCLSTR>
    [rows,cols] = size(input);
    if ((rows ~= 1) && (cols ~= 1))
        err = MException(['CHI:',mfilename,':IOError'], ...
            'Data type (matrix of cells of char) not managed.');
        throw(err);
    end
    
    str = '{';
    for i = 1:length(input)
        if (i ~= 1)
            str = horzcat(str,', '); %#ok<AGROW>
        end
        str = horzcat(str,input{i}); %#ok<AGROW>
    end
    str = horzcat(str,'}');
    return;
end

% Convert a cell array to a string surrounded by braces and separated by
% commas
if iscell(input)
    [rows,cols] = size(input);
    if ((rows ~= 1) && (cols ~= 1))
        err = MException(['CHI:',mfilename,':IOError'], ...
            'Data type (matrix of cells) not managed.');
        throw(err);
    end
    
    str = '{';
    for i = 1:length(input)
        if (i ~= 1)
            str = horzcat(str,', '); %#ok<AGROW>
        end
        str = horzcat(str,utilities.tostring(input{i})); %#ok<AGROW>
    end
    str = horzcat(str,'}');
    return;
end

if isstruct(input)
    fields = fieldnames(input);
    str = [];
    for i = 1:length(fields)
        if (i ~= 1)
            str = horzcat(str,', '); %#ok<AGROW>
        end
        str = horzcat(str,[fields{i}, '=', utilities.tostring(input{i})]); %#ok<AGROW>
    end
    return;
end

% Convert a vectors of numbers to a string of numbers enclosed in square
% brackets and separated by commas
if ~isscalar(input)
    [rows,cols] = size(input);
    if ((rows ~= 1) && (cols ~= 1))
        err = MException(['CHI:',mfilename,':IOError'], ...
            'Data type (matrix) not managed.');
        throw(err);
    end
    if isrow(input)
        input = input';
    end
    str = '[';
    for i = 1:length(input)
        if (i ~= 1)
            str = horzcat(str,', '); %#ok<AGROW>
        end
        str = horzcat(str,utilities.tostring(input(i))); %#ok<AGROW>
    end
    str = horzcat(str,']');
    return;
end

if isnumeric(input)
    str = num2str(input);
    return;
end

if isstring(input)
    str = char(input);
    return;
end

err = MException(['CHI:',mfilename,':IOError'], ...
    'Data type not managed.');
throw(err);

end % function: tostring
