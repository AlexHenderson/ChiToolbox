function [ output ] = ChiVectorNormalise( input )
%CHIVECTORNORMALISE Vector normalisation
%   Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

if (isa(input,'ChiSpectrum') || isa(input,'ChiImage'))

    output = input.clone();

    if (isa(input,'ChiImage'))
        % subtract the mean intensity % wrong to do this here
%        output.data = output.data - repmat(mean(output.data),size(output.data,1),1);

        % square the intensities
        L2norm = output.data .^2;

        % determine the sum of the squares (row based)
        L2norm = sum(L2norm,2);

        % take sqrt
        L2norm = sqrt(L2norm);
        
        % avoid divide by zero error (see explanation below)
        L2norm(L2norm==0) = 1;                

%         slow = false;   % Fix this for the time being
%         if (slow)
%             for col = 1:output.channels
%                 % divide the data by the vector length ([n,m])
%                 output.data(:,col) = output.data(:,col) ./ L2norm;   
%             end
%         else

            % Generate a sparse matrix where the diagonal is of the inverse of the L2norm
            multiplier = 1 ./ L2norm;
            multiplier_diag = spdiags(multiplier,0,length(multiplier),length(multiplier));

            % divide the data by the vector length ([n,m])
            output.data = multiplier_diag * output.data; 
            
%         end
        
    end
    
    if (isa(input,'ChiSpectrum'))
        % http://www.mathworks.co.uk/help/matlab/ref/norm.html
        output.data = output.data ./ norm(output.data);
    end
    
    output.history.add('vector normalised');
    input.history.add('vector normalised');
    
else
    err = MException('CHI:ChiVectorNormalise:WrongDataType', ...
        'Input is not a ChiSpectrum or a ChiImage');
    throw(err);
end

end

%% Notes
% This is vector normalisation of each pixel in a hyperspectral image,
% independent of any other pixel. 

%% Explanation
% If the L2Norm is 0 we can set it to 1. This is becasue the only way in
% which we can get a value of 0 for the L2norm is if all the values that
% are involved in its generation are 0. Therefore we would be dividing 0 by
% 0. Dividing 0 by 1 gives, effectively, the same result, but without the
% error.
