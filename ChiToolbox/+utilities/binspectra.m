function obj = binspectra(varargin)

%   Function: binspectra
%   Usage:
%   [newx,newy]=binspectra(xvals,yvals,xmode,range,sumormean,start,stop);
%
%   Spreads the data across a different number of channels.
%   The variable 'xmode' indicates which mode to operate in. 
%   xmode == 'mass' we spread nonlinear time channels across linear mass
%           channels. 
%   xmode == 'time' we combine adjacent channels. 
%   xvals: vector for the x-axis
%   yvals: matrix of spectra in rows
%   xmode: either 'mass' or 'time' as discussed above
%   range:  for xmode==mass this is the new binwidth (2 * +/- halfwidth)
%           for xmode==time this is the number of channels to combine.
%   func: either 'sum' or 'mean'. Do we want to sum the channels or
%           average them. Default == 'sum'
%   startvalue: threshold the x-axis by defining a starting value. 
%           Default == 0. No effect when type='time'
%   stopvalue: threshold the x-axis by defining an ending value.
%           Default == last value in the x-axis. No effect when type='time'
% 
%   Outputs newx and newy are the binned x-axis and spectra. 
%
%   Copyright (c) June 2013, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 1.0 June 2013


this = varargin{1};

if nargout
    obj = this.clone();
    % Not a great approach, but quite generic. 
    % Prevents errors if the function name changes. 
    command = ['utilities.', mfilename, '(obj,varargin{2:end});'];
    eval(command);  
else
    % We are expecting to modify this object in situ

    % Could add an offset or alignment value...
    % eg function [newx,newy]=binspectra(xvals,yvals,type,range,sumormean,align)

    % Set defaults
    xmode = 'mass';
    range = 2;
    func = 'sum';
    start = this.xvals(1);
    stop = this.xvals(end);

    % Manage function arguments as a list of named pairs
    argposition = find(cellfun(@(x) strcmpi(x, 'xmode') , varargin));
    if argposition
        xmode = lower(varargin{argposition + 1});
        varargin(argposition+1) = [];
        varargin(argposition) = [];
    end    
    argposition = find(cellfun(@(x) strcmpi(x, 'range') , varargin));
    if argposition
        range = lower(varargin{argposition + 1});
        varargin(argposition+1) = [];
        varargin(argposition) = [];
    end    
    argposition = find(cellfun(@(x) strcmpi(x, 'func') , varargin));
    if argposition
        func = lower(varargin{argposition + 1});
        varargin(argposition+1) = [];
        varargin(argposition) = [];
    end    
    argposition = find(cellfun(@(x) strcmpi(x, 'start') , varargin));
    if argposition
        start = lower(varargin{argposition + 1});
        varargin(argposition+1) = [];
        varargin(argposition) = [];
    end    
    argposition = find(cellfun(@(x) strcmpi(x, 'stop') , varargin));
    if argposition
        stop = lower(varargin{argposition + 1});
        varargin(argposition+1) = [];
        varargin(argposition) = [];
    end    
    
    if length(varargin) > 1
        % We have a list of terms rather than a list of named pairs
    
        % [newx,newy] = binspectra(xvals,yvals,xmode,range,func,start,stop)
        % [newx,newy] = binspectra(xmode,range,func,start,stop)
        switch length(varargin)
            case 2
                xmode = varargin{2};
            case 3
                xmode = varargin{2};
                range = varargin{3};
            case 4
                xmode = varargin{2};
                range = varargin{3};
                start = varargin{4};
            case 5
                xmode = varargin{2};
                range = varargin{3};
                start = varargin{4};
                stop  = varargin{5};
            otherwise
                err = MException(['CHI:', mfilename, ':IOError'], ...
                    'Cannot interpret the function arguments.');
                throw(err);
        end
    end    
    
    switch lower(xmode)
        case 'mass' 
            this = rebintolinear(this,range,func,start,stop);
        case 'time'
            x = this.xvals;
            y = this.data;
            [this.xvals,this.data] = utilties.rebincombine(x,y,range,func);
    %     case 'adaptive'
            %do something
    %     case 'wavenumber'
            %do something
        otherwise
            error('The xmode of conversion should be one of ''mass'' or ''time''.');
    end

    message = sprintf('rebinned: xmode=%s, range=%d, func=%s, start=%f, stop=%f',xmode,range,func,start,stop);
    this.history.add(message);
end

end % main function

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% rebin mass

function this = rebintolinear(this,binwidth,sumormean,startvalue,stopvalue)

    % Here we wish to combine a non-linear collection of channels into a
    % linear one. This is the case for time-to-mass conversion. 
    
    % Truncate data to match the required start and stop values. 
    % Define the start value as the first channel that contributes to that
    % bin. Similarly for the stop value using the last channel.
    indicies = this.indexat([startvalue-binwidth/2, stopvalue+binwidth/2]);
    this.xvals = this.xvals(indicies(1):indicies(2));
    y = this.data(:,indicies(1):indicies(2));
    
    
    
    
%     largestexistingxspacing = (x(end) - x(end-1));
%     if(binwidth < largestexistingxspacing)
%         message = ['binwidth is too small. Must be greater than ', num2str(largestexistingxspacing), '. See help info.'];
%         error(message);
%     end


    % Determine the limits of the new channel bins, and their centres. 
    halfbinwidth = binwidth/2;
    binedges   = (startvalue-halfbinwidth : binwidth : stopvalue+halfbinwidth)';
    bincentres = (startvalue : binwidth : stopvalue)';
    
    % Find the matrix index values for these new channel bins. 
    indicies = this.indexat(binedges);    
    
    % Make some space for the results
    if issparse(y)
        newy = sparse(this.numspectra,length(bincentres));
    else    
        newy = zeros(this.numspectra,length(bincentres));
    end
    
    % Combine the channels. 
    switch lower(sumormean)
        case 'sum'
            for i = 1:length(bincentres)
                % Include lower boundary, but not upper boundary
                newy(:,i) = sum(y(:,indicies(i):indicies(i+1)-1),2);
            end
        case 'mean'
            for i = 1:length(bincentres)
                % Include lower boundary, but not upper boundary
                newy(:,i) = mean(y(:,indicies(i):indicies(i+1)-1),2);
            end
        otherwise
            error('Please select either the sum, or the mean, of the channels.');
    end

    % TODO. Not sure which mean to use to define the new x values for the
    % summed channels. For linear data we need the arithmetic mean.
    % However, for ToF data we might be better off with the geometric mean.
    % Here we simply define the centre of the new channel bin as the mass
    % of that bin. This is equivalent to the arithmetic mean (I think).
    this.xvals = bincentres;
    this.data = newy;

end % function rebintolinear

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% rebin time

% function [newx,newy] = rebincombine(x,y,numchanstocombine,sumormean)
% 
%     % numchanstocombine is the number of channels to combine together.
%     % Each new channel is a combination of numchanstocombine old channels.
%     
% %     channels=length(x);
% %     start=(1:numchanstocombine:channels)';
% %     stop =(numchanstocombine:numchanstocombine:channels)';
% %     if length(start) ~= length(stop)
% %         stop=vertcat(stop,channels);
% %     end
% %     
%     
%     % Reshape the data such that we have a block of data that has the
%     % number of rows that need to be combined, then sum (or average). 
%     
% %     x = this.xvals;
% %     y = this.data;
%     
%     % Convert to columns of data since columns are quicker to work with. 
%     y = y';
%     [numchannels,numspectra] = size(y);
%     
%     % If the number of channels isn't divisible by numchanstocombine then
%     % append some zero-intensity channels at the end of the spectra to
%     % allow the reshape command to work. 
%     m = mod(numchannels,numchanstocombine);
%     additionalchannelsrequired = 0;
%     if m
%         additionalchannelsrequired = numchanstocombine-m;
%         y = vertcat(y, zeros(additionalchannelsrequired,numspectra));
%     end
% 
%     % Change the layout of the data such that we have columns containing
%     % the channels we wish to combine.
%     y = reshape(y,numchanstocombine,[]);
%         
%     % Combine the channels. 
%     switch lower(sumormean)
%         case 'sum'
%             newy = sum(y);
%         case 'mean'
%             newy = mean(y);
%         otherwise
%             error('Please select either the sum, or the mean, of the channels.');
%     end
%     
%     % Put the data back into the original shape. The number of channels
%     % will be reduced since we've combined them.
%     newy = reshape(newy,[],numspectra);
%     
%     % Revert to the original data layout. 
%     newy = newy';   
%     
%     % TODO. Not sure which mean to use to define the new x values for the
%     % summed channels. For linear data we need the arithmetic mean.
%     % However, for ToF data we might be better off with the geometric mean.
%     % Here we're using the arithmetic mean to get started. For small
%     % numchanstocombine this is a reasonable approximation. 
% 
%     [x, rotated] = columnvector(x);
% 
%     if additionalchannelsrequired
%         x = vertcat(x, zeros(additionalchannelsrequired,1));
%     end
%     
%     x = reshape(x,numchanstocombine,[]);
%     
%     newx = mean(x);
%     
%     if ~rotated
%         newx = newx';
%     end
%     
% end % function rebincombine
