function [xvals,data,height,width,filenames,acqdate,xlabel,xunit,ylabel,yunit,datatype] = ChiOpusFileHandler(varargin)

% ChiOpusFileHandler  File format handler for Bruker Opus files
% 
% Syntax
%   brukerData = ChiOpusFileHandler();
%   brukerData = ChiOpusFileHandler(filename);
%
% Description
%   brukerData = ChiOpusFileHandler() prompts the user for a Bruker Opus
%   file (*.0).
% 
%   brukerData = ChiOpusFileHandler(filename) opens the file named
%   filename.
%
% Copyright (c) 2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiOPusFile ChiBrukerFile ChiSpectrum ChiSpectralCollection ChiImage.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Version 1.0, January 2019
% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


%% Get the filename if not supplied
if ~isempty(varargin)
    filenames = varargin{1};
else
    filenames = utilities.getfilename('*.0', 'Bruker Opus Files (*.0)');
end

if ~iscell(filenames)
    filenames = cellstr(filenames);
end

%% Import the data
% Using Jacob Filik's ImportOpus routine
% New files (?) seem to have all parameters with 'Changed' at the end. Old
% files don't. Not sure if this is a robust statement. 

changed = '';
try
    
    % We get a warning about the p-file being older than the m-file
    % Not much we can do about that, so just suppress it
    warningid = 'MATLAB:pfileOlderThanMfile'; 
    warning('off',warningid);
    
    [data,xvals,params] = ImportOpus(filenames{1},'RatioAbsorptionChanged');
    
    % Reinstate the warning
    warning('on',warningid);

    changed = 'Changed';
catch
    try
        warningid = 'MATLAB:pfileOlderThanMfile'; 
        warning('off',warningid);
        [data,xvals,params] = ImportOpus(filenames{1},'RatioAbsorption');
        warning('on',warningid);
    catch ex
        err = MException(['CHI:',mfilename,':IOError'], ...
            'Data appears not to be background referenced.');
        throw(err);
    end
end

%% Reorientate the data to match the ChiToolbox convention
% xvalues run low to high
% data to be in doubles

if (xvals(1) > xvals(end))
    xvals = fliplr(xvals);
    data = fliplr(data);
end
    
data = double(data);
if iscolumn(data)
    data = data';
end


%% Get the data type and the dimensionality
datatype = 'spectrum';
height = 1;
width = 1;

if isfield(params,['DataTrace', changed])
    % We have a spectral collection
    datatype = 'spectralcollection';
    height = params.(['DataTrace',changed]).NPT;
else
    if isfield(params,['ReferenceDataSpectrum', changed])
        if (isfield(params.(['ReferenceDataSpectrum',changed]),'NPX') && ...
                isfield(params.(['ReferenceDataSpectrum',changed]),'NPY'))
            % We have an image
            datatype = 'image';
            width = params.(['ReferenceDataSpectrum',changed]).NPX;
            height = params.(['ReferenceDataSpectrum',changed]).NPY;
        end
    end
end

%% Extract axis labels
xlabel = '';
xunit = '';
ylabel = '';
yunit = '';

if isfield(params,['RatioDataAbsorption', changed])
    if isfield(params.(['RatioDataAbsorption',changed]),'DXU')
        x_label = params.(['RatioDataAbsorption',changed]).DXU;
        x_label = deblank(x_label);
        
        switch x_label
            case 'WN'
                xlabel = 'wavenumber';
                xunit = 'cm^{-1}';
            case 'MI'
                xlabel = 'micron';
                xunit = 'um';
            case 'LGW'
                xlabel = 'log(wavenumber)';
            case 'MIN'
                xlabel = 'minutes';
                xunit = 'min';
            case 'PNT'
                xlabel = 'points';
            otherwise
                xlabel = 'unknown';
        end
    end
end

if isfield(params,['Acquisition', changed])
    if isfield(params.(['Acquisition',changed]),'PLF')
        y_label = params.(['Acquisition',changed]).PLF;
        y_label = deblank(y_label);

        switch y_label
            case 'SC'
                ylabel = 'single channel';
            case 'TR'
                ylabel = 'transmission';
            case 'AB'
                ylabel = 'absorbance';
            case 'KM'
                ylabel = 'Kubelka-Munk';
            case 'LA'
                ylabel = '-log(absorbance)';
            case 'DR'
                ylabel = 'diffuse reflectance';
            otherwise
                ylabel = 'unknown';
        end
    end
end

%% Get acquisition date and time

% Examples
% DAT: '2011/12/02 R'
% TIM: '13:26:18 (GMT-6) s  '
% DAT: '20/01/2019  '
% TIM: '16:32:35.752 (GMT+0)    '
% DAT: '2005/01/25 p'
% TIM: '13:22:23 (UTC+0) a.X'

acqdate = '';

if isfield(params,['ReferenceDataSpectrum', changed])
    if isfield(params.(['ReferenceDataSpectrum',changed]),'DAT')
        recordeddate = params.(['ReferenceDataSpectrum',changed]).DAT;
        acqdate = recordeddate;
    end
    if isfield(params.(['ReferenceDataSpectrum',changed]),'TIM')
        recordedtime = params.(['ReferenceDataSpectrum',changed]).TIM;
        if ~isempty(acqdate)
            acqdate = [acqdate, ' ' recordedtime];
        else
            acqdate = recordedtime;
        end
    end
end

end % function ChiOpusFileHandler
