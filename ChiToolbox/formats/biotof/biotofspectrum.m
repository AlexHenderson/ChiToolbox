function [mass,intensity,parameters] = biotofspectrum(filename)

% syntax: [mass, intensity] = biotofspectrum(filename);
% or
% syntax: [mass, intensity] = biotofspectrum();
%
% The second version prompts for a file name.
%
% Version 2.0
% Reads the Biotof spectrum file format (Windows version)
%
% Takes a file name
% Returns two equal length column vectors - mass and intensity
% There is NO binning into fixed mass steps 
%
% Alex Henderson 
%
% Version 1.0 December 2006
% Version 1.1 September 2008
% Version 2.0 August 2017
%
% *** Version 1.0 contained an error. All calibration will be out. 
%
% Version 1.2 July 2010 - changed output type of intensity to double
% Version 2.0 August 2017 - Slight modification to style. Changed errors to
% exceptions. 


if (exist('filename', 'var') == 0)
    filename = getfilename();
end

[fid, message] = fopen(filename);
%if((fid == -1) || isempty(fid))
if (fid == -1)
    err = MException('biotofspectrum:IOError', message);
    throw(err);
end
parameters.filename = filename;

status = fseek(fid, 3216, 'bof');
if (status == -1)
    message = ferror(fid, 'clear');
    err = MException('biotofspectrum:IOError', message);
    throw(err);
end
mass_slope = fread(fid, 1, '*float64');
parameters.mass_slope = mass_slope;

status = fseek(fid, 3224, 'bof');
if (status == -1)
    message = ferror(fid, 'clear');
    err = MException('biotofspectrum:IOError', message);
    throw(err);
end
mass_intercept = fread(fid, 1, '*float64');
parameters.mass_intercept = mass_intercept;

status = fseek(fid, 3976, 'bof');   
if (status == -1)
    message = ferror(fid, 'clear');
    err = MException('biotofspectrum:IOError', message);
    throw(err);
end
kore_res = fread(fid, 1, '*float64');
parameters.kore_res = kore_res;

status = fseek(fid, 3968, 'bof');
if (status == -1)
    message = ferror(fid, 'clear');
    err = MException('biotofspectrum:IOError', message);
    throw(err);
end
da500_res = fread(fid, 1, '*float64');
parameters.da500_res = da500_res;

status = fseek(fid, 0, 'bof');
if (status == -1)
    message = ferror(fid, 'clear');
    err = MException('biotofspectrum:IOError', message);
    throw(err);
end
detector_flag = fread(fid, 1, '*int32');
parameters.detector_flag = detector_flag;

status = fseek(fid, 244, 'bof');
if (status == -1)
    message = ferror(fid, 'clear');
    err = MException('biotofspectrum:IOError', message);
    throw(err);
end
szdescription1 = fread(fid, 256, '*char');
parameters.szdescription1 = szdescription1;

status = fseek(fid, 500, 'bof');
if (status == -1)
    message = ferror(fid, 'clear');
    err = MException('biotofspectrum:IOError', message);
    throw(err);
end
szdescription2 = fread(fid, 1024, '*char');
parameters.szdescription21 = szdescription2;

status = fseek(fid, 1656, 'bof');
if (status == -1)
    message = ferror(fid, 'clear');
    err = MException('biotofspectrum:IOError', message);
    throw(err);
end
timestamp = fread(fid, 1, '*int32');
acqdatetime = datestr(datenum([1970 1 1 0 0 double(timestamp)]));
parameters.timestamp = timestamp;
parameters.acqdatetime = acqdatetime;

status = fseek(fid, 16, 'bof');
if (status == -1)
    message = ferror(fid, 'clear');
    err = MException('biotofspectrum:IOError', message);
    throw(err);
end
flagionsign = fread(fid, 1, '*int32');
parameters.flagionsign = flagionsign;

%status = fseek(fid, 5024, 'bof'); <--- error
status = fseek(fid, 4656, 'bof');
if (status == -1)
    message = ferror(fid, 'clear');
    err = MException('biotofspectrum:IOError', message);
    throw(err);
end

intensity = fread(fid, inf, '*int32');

fclose(fid);

switch detector_flag
	case 1408
        DetectorResolution = kore_res;
	case 1034 
        DetectorResolution = da500_res;
    otherwise
        err = MException('biotofspectrum:IOError', 'Cannot determine detector type');
        throw(err);
end
parameters.DetectorResolution = DetectorResolution;

Constant1 = DetectorResolution * sqrt(mass_slope) / 1000.0;
Constant2 = mass_intercept * sqrt(mass_slope);

parameters.Constant1 = Constant1;
parameters.Constant2 = Constant2;

channels = length(intensity);
parameters.channels = channels;

mass = zeros(channels,1);
for channel = 1:channels
    tempmass = (Constant1 * (channel-1)) + Constant2;
    if (tempmass < 0)
        sign = -1;  % handles negative mass!
    else
        sign = 1;
    end
    mass(channel) = tempmass * tempmass * sign; % ie the previous line squared 
end    

intensity = double(intensity);

end % function spectrum
