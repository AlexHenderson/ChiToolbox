function [mass,data,height,width,layers,filename,xlabel,xunit,ylabel,yunit,imzmlinfo] = ionoptika_h5file(filename, varargin)

% ionoptika_h5file  Import function for Ionoptika .h5 files.
% 
% Syntax
%  [mass,data,height,width,layers,filename,xlabel,xunit,ylabel,yunit,imzmlinfo] = ionoptika_h5file();
%  [____] = ionoptika_h5file(filename);
%  [____] = ionoptika_h5file(____,'lowmass',lowmassvalue);
%  [____] = ionoptika_h5file(____,'highmass',highmassvalue);
%  [____] = ionoptika_h5file(____,'combine',numchanstocombine);
%
% Description
%   [mass,data,height,width,layers,filename,x_label,y_label,imzmlinfo] =
%   ionoptika_h5file() prompts the user for an Ionoptika h5 file (any
%   .0000_xxx_yyy.h5 file) and extracts the contents. 
%   mass is a row vector of mass values. data is a 3d array of spectra in
%   the form height x width x intensity values. height is the number of
%   rows in the image (y-axis). width is the number of columns in the image
%   (x-axis). layers is currently set to 1 since this code cannot handle
%   multiple depths (yet). filename is the name of the file that was
%   opened. xlabel, xunit, ylabel and yunit are labels for the x-axis and
%   y-axis respectively and default to:
%       xlabel = 'm/z'
%       xunit  = 'amu'
%       ylabel = 'intensity'
%       yunit  = 'counts'
%   imzmlinfo is a struct with a single field: 
%       imzmlinfo.instrument = 'Ionoptika J105'
% 
%   [____] = ionoptika_h5file(filename) opens the filename specified. If a
%   tile image is specified, the entire image is opened, not only that
%   tile. 
%
%   [____] = ionoptika_h5file(____,'lowmass',lowmassvalue) crops the data
%   to a lower mass limit of lowmassvalue, or the closest available mass
%   channel. 
%
%   [____] = ionoptika_h5file(____,'highmass',highmassvalue) crops the data
%   to a upper mass limit of highmassvalue, or the closest available mass
%   channel. 
%
%   [____] = ionoptika_h5file(____,'combine',numchanstocombine) sums
%   together numchanstocombine time channels, thus reducing teh mass
%   resolution. 
% 
% Notes
%   The lowmass, highmass and combine operations can be used separately or
%   together.
%   Where a mass limit is out of range, the actual mass limit will be used.
%   Where combine is used and the value would result in the final channel
%   of teh output being composed of less than numchanstocombine in the
%   original data, the last channel is omitted. 
%   Depth profiles (z-axis) are not handled yet.     
%
% Copyright (c) 2017-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   ChiIonoptikaFile, ChiToFMSImage, ChiFile.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available on Bitbucket
% https://bitbucket.org/AlexHenderson/chitoolbox


%% Do we want to limit the mass range? low mass limit
limitmassrange = false;
lowmass = 0;
argposition = find(cellfun(@(x) strcmpi(x, 'lowmass') , varargin));
if argposition
    % Remove the parameter from the argument list
    limitmassrange = true;
    lowmass = varargin{argposition+1};
    varargin(argposition+1) = [];
    varargin(argposition) = [];
end

%% Do we want to limit the mass range? high mass limit
highmass = 0;
argposition = find(cellfun(@(x) strcmpi(x, 'highmass') , varargin));
if argposition
    % Remove the parameter from the argument list
    limitmassrange = true;
    highmass = varargin{argposition+1};
    varargin(argposition+1) = [];
    varargin(argposition) = [];
end

%% Catch error where low mass and high mass are reversed
if (highmass < lowmass)
    temp = lowmass;
    lowmass = highmass;
    highmass = temp;
end

%% Do we want to combine the channels?
combinechannels = false;
binwidth = 0;
argposition = find(cellfun(@(x) strcmpi(x, 'combine') , varargin));
if argposition
    % Remove the parameter from the argument list
    combinechannels = true;
    binwidth = varargin{argposition+1};
    varargin(argposition+1) = [];
    varargin(argposition) = []; %#ok<NASGU>
end

%% Get the filename if not supplied
if ~exist('filename', 'var')
    filename = getfilename('*.h5', 'Ionoptika Files (*.h5)');
    if (isfloat(filename) && (filename == 0))
        return;
    end
    filename = filename{1};
end

[filepath,name,ext] = fileparts(filename);
[dummy,name] = fileparts(name); %#ok<ASGLU> % remove the tile number
clear dummy;

%% Define some defaults
height = 1; %#ok<NASGU>
width = 1; %#ok<NASGU>
layers = 1; % This code doesn't handle depth profiles yet. 

imzmlinfo.instrument = 'Ionoptika J105';
xlabel   = 'm/z';
xunit    = 'amu';
ylabel   = 'intensity';
yunit    = 'counts';

%% Get dimensions
xtiles = h5read(filename,'/numberOfTilesX');
ytiles = h5read(filename,'/numberOfTilesY');

tilewidth = h5read(filename,'/rasterWidth');
tileheight = h5read(filename,'/rasterHeight');

xpixels = xtiles * tilewidth;
ypixels = ytiles * tileheight;

height = ypixels;
width = xpixels;

%% Get the mass channel information
mass = h5read(filename,'/massArray');
lowmassidx = 1;

if limitmassrange
    lowmassidx = find((mass < lowmass),1,'last');
    highmassidx = find((mass > highmass),1,'first');
    
    if isempty(lowmassidx)
        lowmassidx = 1;
        utilities.warningnobacktrace(['Requested low mass is below the mass range (', num2str(mass(1)), ' amu). Setting lowmassvalue to this value.'])
    end
    if isempty(highmassidx)
        highmassidx = length(mass);
        utilities.warningnobacktrace(['Requested high mass is beyond the mass range (', num2str(mass(end)), ' amu). Setting highmassvalue to this value.'])
    end
    
    mass = mass(lowmassidx:highmassidx);
end

%% Read in the data
for z = 1:layers
    for y = 1:ytiles
        for x = 1:xtiles
            thistilelocation = sprintf('.%04d_%03d_%03d', z-1, x-1, y-1);
            tilefilename = fullfile(filepath,[name,thistilelocation,ext]);
            
            if limitmassrange
                tempdata = h5read(tilefilename,'/spectrumArray',[lowmassidx,1],[length(mass),Inf]); % Takes a while to read, so only do this when necessary
            else
                tempdata = h5read(tilefilename,'/spectrumArray'); % Takes a while to read, so only do this when necessary
            end            
            
            tempdata = tempdata';

            if combinechannels
                [newmass,tempdata] = utilities.rebincombine(mass,tempdata,binwidth,'sum');
            else
                % Need to keep a copy of mass for next pass
                newmass = mass;
            end
            
            tempdata = reshape(tempdata,tileheight,tilewidth,[]);
            tempdata = rot90(tempdata);

            % Make space for data on first pass. Could have done this
            % earlier, but requires mass length to be known
            if ((x == 1) && (y == 1) && (z == 1))
                try
                    data = zeros(ypixels,xpixels,length(newmass));
                catch ME
                    % Catch error when out of memory, suggesting an
                    % alternative route
                    if strcmp(ME.identifier,'MATLAB:array:SizeLimitExceeded')
                        message = [ME.message, '\n\nAlternatively, consider using the additional options available in ChiIonoptikaFile\n'];
                        err = MException(['CHI:',mfilename,':InputError'], message);
                        throwAsCaller(err);
                    else
                        rethrow(ME)
                    end
                end
            end
            
            % Insert this tile into the image
            data((1+((y-1)*tileheight)):(y*tileheight), (1+((x-1)*tilewidth)):(x*tilewidth), :) = tempdata;
        end
    end
end

data = flipud(data);

%% Tidy up
mass = double(newmass);
mass = utilities.force2row(mass);
data = double(data);

end % function
