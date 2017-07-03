function output = ChiSumNormalise(input)
%CHISUMNORMALISE Normalise data to unity
%   Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

if (isa(input,'ChiSpectrum') || isa(input,'ChiImage'))

    output = input.clone();

    if isa(input,'ChiImage')
        
        % Calculate sums of spectra
        sums = sum(output.data,2);
        
        % Avoid divide by zero error (see explanation below)
        sums(sums==0) = 1;                

%         slow = false;   % Fix this for the time being
%         if (slow)
%             for col = 1:output.channels
%                 % divide the data by the spectral sums ([n,m])
%                 output.data(:,col) = output.data(:,col) ./ sums;   
%             end
%         else

        % Generate a sparse matrix where the diagonal is of the inverse
        % of the sums
        multiplier = 1 ./ sums;
        multiplier_diag = spdiags(multiplier,0,length(multiplier),length(multiplier));

        % divide the data by the spectral sums ([n,m])
        output.data = multiplier_diag * output.data; 
            
%         end
        
    end
    
    if isa(input,'ChiSpectrum')
        output.data = output.data / output.sum();
    end
    
    output.history.add(['SumNormalise, ', numpcs, ' PCs']);
    input.history.add(['SumNormalise, ', numpcs, ' PCs']);

else
    err = MException('CHI:ChiSumNormalise:WrongDataType', ...
        'Input is not a ChiSpectrum or a ChiImage');
    throw(err);
end

end
