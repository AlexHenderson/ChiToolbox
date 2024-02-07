function varargout = csvwrite(this,filename,varargin)

% csvwrite  Writes the data to disc in comma separated variable format.
%
% Syntax
%   csvwrite();
%   filename = csvwrite();
%   [____] = csvwrite(filename);
%   [____] = csvwrite(filename,'rows');
%   [____] = csvwrite([],'rows');
%
% Description
%   csvwrite() writes the data to disc in comma separated variable format.
%   The data is written in columns with the first column being the
%   x-values. A dialog box is presented for the user to select a filename.
%   If the data was originally generated from a file, the original filename
%   is used, but with the file extension changed to 'csv'.
% 
%   filename = csvwrite() returns the filename of the csv file.
% 
%   [____] = csvwrite(filename) saves the data to filename.
%
%   [____] = csvwrite(filename,'rows') saves the data in rows with the
%   first row being the x-values.
%
%   [____] = csvwrite([],'rows') presents the user with a dialog box to
%   select a filename, then saves the data in rows with the first row being
%   the x-values.
% 
% Notes
%   The data is written in the following order. First the x-values are
%   written, then each column of pixels in order. For example, using the
%   terminology (x,y), we write (1,1) to (1,end), then (2,1) to (2,end) and
%   so on.
% 
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   csvwrite uiputfile.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    if (~exist('filename', 'var') || isempty(filename))
        
        filter = {'*.csv', 'Comma Separated Variable Files (*.csv)';
                  '*.*',  'All Files (*.*)'};
        
        % Set the default filename to be the first filename in
        % this.filenames with the extension changed to .csv
        if ~isempty(this.filenames)
            [filepath,name] = fileparts(this.filenames{1});
            defaultname = fullfile(filepath,[name,'.csv']);
            [userfile,userpath] = uiputfile(filter,'Select a filename...',defaultname);
        else
            [userfile,userpath] = uiputfile(filter,'Select a filename...');
        end
        
        if ~userfile
            % User cancelled the dialog box
            filename = '';
            if nargout
                varargout{1} = filename;
            end
            return
        else
            % Build a full filename
            filename = fullfile(userpath,userfile);
        end
        
    else
        % Prepend the current working directory if the user did not specify
        % the full filename
        [filepath,name,ext] = fileparts(filename);
        if isempty(filepath)
            filename = fullfile(pwd,[name,ext]);
        end
    end

    % Default is to have data in columns with xvals as the first column
    output = [this.xvals; this.data]';
    
    if ~isempty(varargin)
        if strcmpi(varargin{1},'rows')
            % The user prefers data to be in rows, so transpose output
            output = output';
        end
    end
    
    % Perform the actual write
    csvwrite(filename,output);
    
    % If the user requested an output, provide the filename
    if nargout
        varargout{1} = filename;
    end

end
