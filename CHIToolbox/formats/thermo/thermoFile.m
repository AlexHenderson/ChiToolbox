function obj = thermoFile(filenames)

%   Function: thermoFile
%   Usage: [xvals,data,height,width,filename,acqdate,x_label,y_label] = thermoFile();
%   Usage: [xvals,data,height,width,filename,acqdate,x_label,y_label] = thermoFile(filename);
%
%   Extracts the spectra from a Thermo Scientific file.
%
%   input:
%   'filename' string containing the full path to either a .spc file (optional)
% 
%   output:
%   'xvals' is a list of the x-axis values related to the data
%   'data' is a 3D cube of the data in the file (height x width x wavenumbers)
%   'width' is the width of the image in pixels (rows)
%   'height' is the height of the image in pixels (columns)
%   'width' is the width of the image in pixels (rows)
%   'filename' is a string containing the full path to the opened file
%   'acqdate' is a string containing the date and time of acquisition
%   'x_label' is the name of the unit on the x axis (eg wavenumber)
%   'y_label' is the name of the unit on the y axis (eg intensity)
%
%   Copyright (c) 2017, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 1.0, June 2017

%       version 1.0, June 2017 Alex Henderson. 


%% Get filename(s) if not provided
if (~exist('filenames', 'var'))
    filenames = utilities.getfilenames(vertcat(...
            {'*.spc',  'Thermo Scientific GRAMS Files (*.spc)'}));

    if (isfloat(filenames) && (filenames == 0))
        return;
    end
end

%% Ensure filenames is a cell array
if ~iscell(filenames)
    filenames = cellstr(filenames);
end

%% Process files
if (length(filenames) == 1)
    % Only a single file selected 
    [pathstr,name,ext] = fileparts(filenames{1}); %#ok<ASGLU>

    switch(lower(ext))
        case {'.spc'}
            [xvals,data,height,width,filename,acqdate,x_label,y_label] = thermoSpc(filenames{1}, false); %#ok<ASGLU>
        otherwise
            error(['problem reading Thermo Fisher file: ', filenames{1}]);
    end
    
    if ((height == 1) && (width == 1))
        % We have one or more spectra rather than an image
        % Check to see if we have a single spectrum or a profile
        if (numel(data) == numel(xvals))
            % Spectrum
            if strfind(lower(x_label),'raman') %#ok<STRIFCND>
                % Raman data
                obj = ChiRamanSpectrum(xvals,data);
            else
                if strfind(lower(x_label),'wavenumber') %#ok<STRIFCND>
                    % IR data
                    obj = ChiIRSpectrum(xvals,data);
                else
                    % Generic data
                    xunit = '';
                    yunit = '';
                    obj = ChiSpectrum(xvals,data,false,x_label,xunit,y_label,yunit);
                end
            end
            obj.filename = filename;
            
        else
            % Multiple spectra
            if strfind(lower(x_label),'raman') %#ok<STRIFCND>
                % Raman data
                obj = ChiRamanSpectralCollection(xvals,data);
                obj.filenames = filenames;                                
            else
                if strfind(lower(x_label),'wavenumber') %#ok<STRIFCND>
                    % IR data
                    obj = ChiIRSpectralCollection(xvals,data);
                    obj.filenames = filenames;                                
                else
                    % Generic data
                    xunit = '';
                    yunit = '';
                    obj = ChiSpectralCollection(xvals,data,false,x_label,xunit,y_label,yunit);
                    obj.filenames = filenames;                                
                end
            end
            
        end               
    else
        % Image data
        if strfind(lower(x_label),'raman') %#ok<STRIFCND>
            % Raman data
            obj = ChiRamanImage(xvals,data,width,height);
        else
            if strfind(lower(x_label),'wavenumber') %#ok<STRIFCND>
                % IR data
                obj = ChiIRImage(xvals,data,width,height);
            else
                % Generic data
                xunit = '';
                yunit = '';
                obj = ChiImage(xvals,data,width,height,false,x_label,xunit,y_label,yunit,width,height);
            end
        end
        obj.filename = filename;
        
    end
    
    obj.history.add(['filename: ', filename]);

else
    % Multiple files
    
    % Read the first file to find out the filetype
    [pathstr,name,ext] = fileparts(filenames{1}); %#ok<ASGLU>
    switch lower(ext)
        case {'.spc'}
            [xvals,data,height,width,filename,acqdate,x_label,y_label] = thermoSpc(filenames{1}, false); %#ok<ASGLU>
        otherwise
            error(['problem reading Thermo Fisher file: ', filenames{1}]);
    end

    if strfind(lower(x_label),'raman') %#ok<STRIFCND>
        % Raman data
        obj = ChiRamanSpectralCollection(xvals,data);
        obj.filenames = filenames;                                
        filetype = 'raman';
    else
        if strfind(lower(x_label),'wavenumber') %#ok<STRIFCND>
            % IR data
            obj = ChiIRSpectralCollection(xvals,data);
            obj.filenames = filenames;                                
            filetype = 'ir';
        else
            % Generic data
            xunit = '';
            yunit = '';
            obj = ChiSpectralCollection(xvals,data,false,x_label,xunit,y_label,yunit);
            obj.filenames = filenames;                                
            filetype = 'generic';
        end
    end
    
    % Now read the remaining files
    for i = 2:length(filenames)
        [pathstr,name,ext] = fileparts(filenames{i}); %#ok<ASGLU>
        switch lower(ext)
            case {'.spc'}
                [xvals,data,height,width,filename,acqdate,x_label,y_label] = thermoSpc(filenames{i}, false); %#ok<ASGLU>
            otherwise
                error(['problem reading Thermo Fisher file: ', filenames{i}]);
        end
        
        % Even if we have an image, we need to treat it as a spectral
        % collection. We have no mechanism for describing concatenated
        % images
        if (numel(data) == numel(xvals))
            switch filetype
                case 'raman'
                    object = ChiRamanSpectrum(xvals,data);
                case 'ir'
                    object = ChiIRSpectrum(xvals,data);
                otherwise
                    xunit = '';
                    yunit = '';
                    object = ChiSpectrum(xvals,data,false,x_label,xunit,y_label,yunit);
            end
        else
            switch filetype
                case 'raman'
                    object = ChiRamanSpectralCollection(xvals,data);
                    obj.filenames = filenames;                                
                case 'ir'
                    object = ChiIRSpectralCollection(xvals,data);
                    obj.filenames = filenames;                                
                otherwise
                    xunit = '';
                    yunit = '';
                    object = ChiSpectralCollection(xvals,data,false,x_label,xunit,y_label,yunit);
                    obj.filenames = filenames;                                
            end
        end               
        obj.append(object);
        obj.history.add(['filename: ', filename]);
    end
end

end % function thermoFile
