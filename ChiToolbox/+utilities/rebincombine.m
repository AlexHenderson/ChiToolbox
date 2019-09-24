function [newx,newy] = rebincombine(x,y,numchanstocombine,sumormean)

    % numchanstocombine is the number of channels to combine together.
    % Each new channel is a combination of numchanstocombine old channels.
    
%     channels=length(x);
%     start=(1:numchanstocombine:channels)';
%     stop =(numchanstocombine:numchanstocombine:channels)';
%     if length(start) ~= length(stop)
%         stop=vertcat(stop,channels);
%     end
%     
    
    % Reshape the data such that we have a block of data that has the
    % number of rows that need to be combined, then sum (or average). 
    
    % Convert to columns of data since columns are quicker to work with. 
    y = y';
    [numchannels,numspectra] = size(y);
    
    % If the number of channels isn't divisible by numchanstocombine then
    % remove some channels at the end of the spectra to allow the reshape
    % command to work. 
    remainder = rem(numchannels,numchanstocombine);
    if remainder
        y = y(1:end-remainder,:);
    end

    % Change the layout of the data such that we have columns containing
    % the channels we wish to combine.
    y = reshape(y,numchanstocombine,[]);
        
    % Combine the channels. 
    switch lower(sumormean)
        case 'sum'
            newy = sum(y);
        case 'mean'
            newy = mean(y);
        otherwise
            error('Please select either the sum, or the mean, of the channels.');
    end
    
    % Put the data back into the original shape. The number of channels
    % will be reduced since we've combined them.
    newy = reshape(newy,[],numspectra);
    
    % Revert to the original data layout. 
    newy = newy';   
    
    % TODO. Not sure which mean to use to define the new x values for the
    % summed channels. For linear data we need the arithmetic mean.
    % However, for ToF data we might be better off with the geometric mean.
    % Here we're using the arithmetic mean to get started. For small
    % numchanstocombine this is a reasonable approximation. 

    x_is_columnvector = iscolumn(x);
    if ~x_is_columnvector
        x = utilities.force2col(x);
    end

    x = x(1:end-remainder);

    x = reshape(x,numchanstocombine,[]); % Also rotates the data
    
    newx = mean(x); % row vector
    
    if x_is_columnvector
        % rotate back to a column vector
        newx = utilities.force2col(newx);
    end
    
end % function rebincombine
