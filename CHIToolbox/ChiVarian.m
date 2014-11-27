function obj = ChiVarian(filename)

if (~exist('filename', 'var'))
    filename=ChiGetFilename('*.dms;*.seq', 'Varian Image Files (*.dms,*.seq)');

    if (isfloat(filename) && (filename==0))
        return;
    end
    
    filename=filename{1};
end

[pathstr,name,ext] = fileparts(filename);

switch(ext)
    case {'.dms','.dmt'}
        [wavenumbers, data, width, height, filename, acqdate]=readvarianmosaic(filename);
    case {'.seq','.bsp'}
        [wavenumbers, data, filename, acqdate]=readvarian_v3(filename);
        dims = size(data);
        height = dims(1);
        width = dims(2);
    otherwise
        error('problem reading varian file');
end
            
obj = ChiImage(wavenumbers,data,true,'wavenumber (cm^-1)','absorbance',width,height);
obj.info = filename;
obj.history.add(['filename: ', filename]);
