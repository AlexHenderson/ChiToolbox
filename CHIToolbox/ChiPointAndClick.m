function ChiPointAndClick(input, favwave)

% filename='E:\SIMS data\Biotof data\2D (XYT)\2BDSISO.XYT';
% lowmass=0;
% highmass=100;
% [imagedata, mass, totalionimage] = xyt(filename, lowmass, highmass);

if (~isa(input,'ChiImage'))
    err = MException('CHI:ChiPointAndClick:WrongDataType', ...
        'Input is not a ChiImage');
    throw(err);
end    

figurehandle=figure;

    spectrumhandle=subplot(2,1,2);
    input.totalspectrum.plot();

    imagehandle=subplot(2,1,1);
    if (~exist('favwave','var'))
        input.totalimage.imagesc();colormap('hot');
    else
        input.sumrange(favwave).imagesc();colormap('hot');
    end

mousebutton=1;    
while(mousebutton == 1)
    [xlocation,ylocation,mousebutton] = ginput(1);

    switch(gca)
        case imagehandle
%            disp('imagehandle');
            xlocation=floor(xlocation);
            ylocation=floor(ylocation);
            if ((xlocation > 0) && (xlocation < input.xpixels)...
                    &&(ylocation > 0) && (ylocation < input.ypixels))
                subplot(2,1,2)
                input.spectrumat(xlocation,ylocation).plot();
            end
            title(['x=', num2str(xlocation),' y=', num2str(ylocation)]);
            axes(imagehandle);

        case spectrumhandle
            disp(['spectrumhandle: ', input.xlabel, '=', num2str(xlocation), ' ', input.ylabel, '=', num2str(ylocation)]);
            
        case figurehandle
            disp('figurehandle');
        otherwise
            disp('unknown handle');
    end
    
end
