function massdata = tof2mass(varargin)

% tof2mass  Convert time-of-flight data to mass data. 
%
% Syntax
%   massdata = tof2mass(binwidth,startmass,endmass);
%
% Description
%   massdata = tof2mass(binwidth,startmass,endmass) converts a
%   time-of-flight data set into one linear in mass. binwidth is the
%   separation of mass values in the output (default = 0.1 amu). startmass
%   is the centre of the first mass channel (default = 0 amu). endmass is
%   the centre of the last mass channel(default = minimum of the original
%   upper mass limit, or 1000 amu).
%
% Notes
%   The intensities of time channels falling within the new mass channels
%   are summed. 
%
% Copyright (c) 2013-2019, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.
%
% See also 
%   keeprange removerange ChiMassSpectrum

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% The latest version of this file is available at:
% https://github.com/AlexHenderson/ChiToolbox

%   version 1.0 June 2013
%   version 2.0 August 2018
%   version 3.0 January 2019


    this = varargin{1};

    binwidth = 0.1;
    startmass = 0;
    endmass = min(this.mass(end),1000);
    
    switch nargin
        case 1
            % Do nothing and the defaults are used
        case 2
            binwidth = varargin{2};
        case 3
            binwidth = varargin{2};
            startmass = varargin{3};
        case 4
            binwidth = varargin{2};
            startmass = varargin{3};
            endmass = varargin{4};
        otherwise
            err = MException(['CHI:',mfilename,':InputError'], ...
                'Too many parameters entered');
            throw(err);
    end        

    % We have ToFMS data, but need to output a mass spectral dataset
    if isa(this,'ChiSpectrum')
        massdata = ChiMSSpectrum(this);
        massdata = rebintolinear(this,massdata,binwidth,startmass,endmass);
    else
        if isa(this,'ChiSpectralCollection')
            massdata = ChiMSSpectralCollection(this);
            massdata = rebintolinear(this,massdata,binwidth,startmass,endmass);
        else        
            if isa(this,'ChiImage')
                massdata = ChiMSImage(this);
                massdata = rebintolinear(this,massdata,binwidth,startmass,endmass);
            end
        end
    end

    message = 'tof2mass';
    message = [message, ': binwidth = ', num2str(binwidth)];
    message = [message, ', startmass = ', num2str(startmass)];
    message = [message, ', endmass = ', num2str(endmass)];
    massdata.history.add(message);
    
end % function tof2mass

% =========================================================================
% =========================================================================
% =========================================================================

function target = rebintolinear(source,target,binwidth,startvalue,stopvalue)

    % Here we wish to combine a non-linear collection of channels into a
    % linear one. This is the case for time-to-mass conversion. 
    
    % Determine the limits of the new channel bins, and their centres. 
    halfbinwidth = binwidth/2;
    binedges   = (startvalue-halfbinwidth : binwidth : stopvalue+halfbinwidth)';
    bincentres = (startvalue : binwidth : stopvalue)';
    
    % Find the matrix index values for these new channel bins. 
    indicies = source.indexat(binedges);    
    
    % Make some space for the results
    if issparse(source.data)
        newy = sparse(source.numspectra,length(bincentres));
    else    
        newy = zeros(source.numspectra,length(bincentres));
    end
    
    % Combine the channels
    if (source.numspectra == 1)
        for i = 1:length(bincentres)
            % Include lower boundary, but not upper boundary
            newy(i) = sum(source.data(indicies(i):indicies(i+1)-1));
        end
    else
        for i = 1:length(bincentres)
            % Include lower boundary, but not upper boundary
            newy(:,i) = sum(source.data(:,indicies(i):indicies(i+1)-1),2);
        end
    end
    
    target.xvals = bincentres';
    target.data = newy;

end % function rebintolinear
