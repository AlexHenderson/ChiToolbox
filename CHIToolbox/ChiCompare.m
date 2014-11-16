function [ output ] = ChiCompare( input1, input2, comparison )
%ChiCompare Comparison of inputs
%   Copyright (c) 2014 Alex Henderson (alex.henderson@manchester.ac.uk)

if (~(isa(input1,'ChiPicture') && isa(input2,'ChiPicture')) )
    err = MException('CHI:ChiCompare:ToDo', ...
        'Can only handle ChiPictures at the moment');
    throw(err);
end

if ((input1.xpixels == input2.xpixels) && (input1.ypixels == input2.ypixels))

    switch(lower(comparison))
        case 'ratio'
            data = input1.data ./ input2.data;
        case 'proportion'
            data = input1.data ./ (input1.data + input2.data);
        otherwise
            err = MException('CHI:ChiCompare:ToDo', ...
                'Can only handle ChiPictures at the moment');
            throw(err);
    end
    
else
    err = MException('CHI:ChiImage:DimensionalityError', ...
        'Picture sizes do not match');
    throw(err);
end
    
output = ChiPicture(data,input1.xpixels,input1.ypixels);
output.log = vertcat(output.log,['Generated a ', comparison]');
