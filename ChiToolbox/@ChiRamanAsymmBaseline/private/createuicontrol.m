function handle = createuicontrol(this,parent,type,params,name,callback) %#ok<INUSL>

% createuicontrol  A helper function to create user interface controls
%
% Syntax
%   handle = createuicontrol(parent,type,params,name,callback);
%
% Description
%   createuicontrol is used interally to help generate user interface
%   controls
% 
% Copyright (c) 2018, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, August 2018
% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox


    switch lower(type)
        case 'button'
            handle = uicontrol('Parent',parent, 'String',name, 'Callback',callback);
        case 'text'
            handle = uicontrol('Parent',parent, 'Style','text', 'FontSize',params.fontsize, 'String',name);
        case 'edit'
            handle = uicontrol('Parent',parent, 'Style','edit', 'FontSize',params.fontsize, 'String',name);
        case 'spacer'
            handle = uicontrol('Parent',parent, 'Style','text', 'FontSize',params.fontsize, 'String',params.spacerstring);
        otherwise
            error('uicontrol type not recognised');
    end
end
