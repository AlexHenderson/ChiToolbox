function j105toimzml(mass,data,width,height,isPositiveIon,isCentroided,filename)

% j105toimzml  Saves data in the imzML file format. 
%
% Syntax
%   j105toimzml(mass,data,width,height,isPositiveIon,isCentroided);
%   j105toimzml(mass,data,width,height,isPositiveIon,isCentroided,filename);
%
% Description
%   j105toimzml(mass,data,width,height,isPositiveIon,isCentroid) requests a
%   filename from the user to save the imzml file(s) to. The data variable
%   must be a matrix with spectra in rows, not a 3d hypercube. width and
%   height are in pixels. isPositiveIon is a logical (true/false). If the
%   data is a collection of peaks, rather than a continuous spectrum, the
%   isCentroided variable should be true, otherwise false.
%
%   j105toimzml(mass,data,width,height,isPositiveIon,isCentroided,filename)
%   saves the data to the filename provided.
% 
% Notes
%   Writing an imzML/ibd file pair takes a long time and uses a lot of disc
%   space. Just sayin'...
% 
%   If the data is centroided (peak-picked) the number of peaks per pixel
%   must be the same for all pixels. 
% 
%   More information on the imzml file format is available from
%   https://ms-imaging.org/wp/imzml/
%
% Copyright (c) 2017, Alex Henderson.
% Licenced under the GNU General Public License (GPL) version 3.

% Contact email: alex.henderson@manchester.ac.uk
% Licenced under the GNU General Public License (GPL) version 3
% http://www.gnu.org/copyleft/gpl.html
% Other licensing options are available, please contact Alex for details
% If you use this file in your work, please acknowledge the author(s) in
% your publications. 

% Info...
% https://ms-imaging.org/wp/wp-content/uploads/2009/08/specifications_imzML1.1.0_RC1.pdf

% This version of the code is designed to write peaks that have been
% identified from the total ion spectrum with their limits applied to each
% pixel. Therefore the lengths of the mz array and intensity array are the
% same for every pixel.
% If the method of selecting peaks changes then we will need to modify this
% code to write different length mzarrays for each pixel. 
% Of course, for each pixel the number of mz values is the same as the
% number of intensity values, but these could change from pixel-to-pixel. 

%% Things we could use, but don't know about

% ToDo: create an ontology for SIMS and add SIMS related software

% Full name and location of the original data file in vendor's format
% filenamestub = 'myfile';
% fullfilename = 'c:\data\myfile.j105';  % original file that this data was culled from
% Date and time of acquisition
% contactName = 'J105 user';
% contactOrganization = 'Top University';
% contactAddress = 'A Lab Near You';
% contactEmail = 'j105user@example.com';
% isPositiveIon = true;
% Ionoptika software name and version
% pixel dimensions in micron
% instrument configuration and serial number

%% Request an output filename from the user
if ~exist('filename','var')
    filename = putfilename('*.imzml', 'imzML Files (*.imzml)');
    filename = filename{1};
end    

[pathstr,name] = fileparts(filename);
filenamestub = fullfile(pathstr,name);

%% Making some assumptions here...
massTypeMatlab = 'float';
massTypeXml = '32-bit float';
massTypeSize = 4;
intensityTypeMatlab = 'int32';
intensityTypeXml = '32-bit integer';
intensityTypeSize = 4;

numScans = size(data,1);    % number of spectra

%% Generate UUID
% http://uk.mathworks.com/matlabcentral/fileexchange/21709-uuid-generation
uuid = java.util.UUID.randomUUID;
uuidstr = upper(char(uuid));
uuidnohyphen = strrep(uuidstr,'-','');
uuidlist = reshape(uuidnohyphen,2,16)';

%% Create ibd file
ibdfilename = [filenamestub,'.ibd'];

% todo: use try catch
fid = fopen(ibdfilename,'wb','l');

% Write UUID
for i = 1:16
    fwrite(fid,hex2dec(uuidlist(i,:)));
end

if isCentroided
    % Need to write peak mass positions and intensities for each spectrum     
    for i = 1:numScans
        % Need to write peak mass positions and intensities for each spectrum     
        % Write m/z array
        fwrite(fid,mass,massTypeMatlab,'l');
        % Write out the related spectral peaks
        fwrite(fid,data(i,:),intensityTypeMatlab,'l');
    end
else
    % we put the mass vector out, then the data as a block
    % Write m/z array
    fwrite(fid,mass,massTypeMatlab,'l');
    % Write out the spectra 
    fwrite(fid,data',intensityTypeMatlab,'l');
end
fclose(fid);

%% Calculate the MD5 hash of the ibd file
Opt.Method = 'MD5';
Opt.Format = 'HEX';
Opt.Input = 'file';
md5 = DataHash(ibdfilename, Opt);

%% Create imzml file
document = com.mathworks.xml.XMLUtils.createDocument('mzML');

mzML = document.getDocumentElement;
mzML.setAttribute('xmlns','http://psi.hupo.org/ms/mzml');
mzML.setAttribute('xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');
mzML.setAttribute('xsi:schemaLocation','http://psi.hupo.org/ms/mzml http://psidev.info/files/ms/mzML/xsd/mzML1.1.0_idx.xsd');
mzML.setAttribute('version','1.1');

%% cvList
cvList = document.createElement('cvList');
cvList.setAttribute('count','3');
cvList.appendChild(createNode(document,'cv',...
    'id','MS', ...
    'fullName','Proteomics Standards Initiative Mass Spectrometry Ontology', ...
    'version','1.3.1', ...
    'URI','http://psidev.info/ms/mzML/psi-ms.obo'));    % ToDo: Check uri
    
cvList.appendChild(createNode(document,'cv',...
    'id','UO', ...
    'fullName','Unit Ontology', ...
    'version','1.15', ...
    'URI','http://obo.cvs.sourceforge.net/obo/obo/ontology/phenotype/unit.obo'));    % ToDo: Check uri

cvList.appendChild(createNode(document,'cv',...
    'id','IMS', ...
    'fullName','Imaging MS Ontology', ...
    'version','0.9.1', ...
    'URI','http://www.maldi-msi.org/download/imzml/imagingMS.obo'));    % ToDo: Check uri

mzML.appendChild(cvList);

%% fileDescription
fileDescription = document.createElement('fileDescription');

    fileContent = getFileContent(document,uuid,isCentroided,md5);
    fileDescription.appendChild(fileContent);

% We don't have this information to hand    
%     sourceFileList = document.createElement('sourceFileList');
%     sourceFileList.setAttribute('count','1');   % Probably only ever one source file (image)
%         sourceFile = getSourceFile(document,fullfilename);
%         sourceFileList.appendChild(sourceFile);
%     fileDescription.appendChild(sourceFileList);
% 
%     contact = getContact(document,contactName,contactOrganization,contactAddress,contactEmail);
%     fileDescription.appendChild(contact);

mzML.appendChild(fileDescription);

%% referenceableParamGroupList
referenceableParamGroupList = document.createElement('referenceableParamGroupList');
referenceableParamGroupList.setAttribute('count','4');

    referenceableParamGroup = getReferenceableParamGroupMzArray(document,massTypeXml);
    referenceableParamGroup.setAttribute('id','mzArray');
    referenceableParamGroupList.appendChild(referenceableParamGroup);

    referenceableParamGroup = getReferenceableParamGroupIntensityArray(document,intensityTypeXml);
    referenceableParamGroup.setAttribute('id','intensityArray');
    referenceableParamGroupList.appendChild(referenceableParamGroup);

    referenceableParamGroup = getReferenceableParamGroupScan1(document);
    referenceableParamGroup.setAttribute('id','scan1');
    referenceableParamGroupList.appendChild(referenceableParamGroup);

    referenceableParamGroup = getReferenceableParamGroupSpectrum1(document,isPositiveIon);
    referenceableParamGroup.setAttribute('id','spectrum1');
    referenceableParamGroupList.appendChild(referenceableParamGroup);

mzML.appendChild(referenceableParamGroupList);

%% sampleList
sampleList = document.createElement('sampleList');
sampleList.setAttribute('count','1');

    sample = getSample(document);
    sample.setAttribute('id','sample1');
    sample.setAttribute('name','Sample1');
    sampleList.appendChild(sample);

mzML.appendChild(sampleList);

%% softwareList
softwareList = document.createElement('softwareList');
softwareList.setAttribute('count','2');

    software = getCustomSoftware(document);
    software.setAttribute('id','IonoptikaJ105Software');
    software.setAttribute('version','Unknown');
    softwareList.appendChild(software);

    software = getCustomSoftware(document);
    software.setAttribute('id','MATLAB');
    software.setAttribute('version',version('-release'));
    softwareList.appendChild(software);
    
    
mzML.appendChild(softwareList);

%% scanSettingsList
scanSettingsList = document.createElement('scanSettingsList');
scanSettingsList.setAttribute('count','1');

    scanSettings = getScanSettings(document,width,height);
    scanSettings.setAttribute('id','scansettings1');
    scanSettingsList.appendChild(scanSettings);

mzML.appendChild(scanSettingsList);

%% instrumentConfigurationList
instrumentConfigurationList = document.createElement('instrumentConfigurationList');
instrumentConfigurationList.setAttribute('count','1');

    instrumentConfiguration = getInstrumentConfiguration(document);
    instrumentConfigurationList.appendChild(instrumentConfiguration);

mzML.appendChild(instrumentConfigurationList);

%% dataProcessingList
dataProcessingList = document.createElement('dataProcessingList');
dataProcessingList.setAttribute('count','2');

    dataProcessing = getDataProcessing(document);
    dataProcessingList.appendChild(dataProcessing);

mzML.appendChild(dataProcessingList);

%% run
run = document.createElement('run');
run.setAttribute('defaultInstrumentConfigurationRef','IonoptikaJ105');
% run.setAttribute('defaultSourceFileRef','sf1');
run.setAttribute('id','Experiment01');
run.setAttribute('sampleRef','sample1');
% run.setAttribute('startTimeStamp','2009-08-11T15:59:44');

    % The spectra live here...
    
    if isCentroided
        spectrumList = insertProcessedSpectra(document,mass,massTypeSize,data,intensityTypeSize,width,height,numScans);
    else
        spectrumList = insertContinuousSpectra(document,mass,massTypeSize,data,intensityTypeSize,width,height,numScans);
    end
    
    run.appendChild(spectrumList);

mzML.appendChild(run);


%% Write to disc
xmlfilename = [filenamestub,'.imzml'];
xmlwrite(xmlfilename,document);
% type(xmlFileName);

end     % function imzml

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function fileContent = getFileContent(document,uuid,isCentroid,md5)

fileContent = createNode(document,'fileContent');

% MUST supply a *child* term of MS:1000524 (data file content) one or more times
fileContent.appendChild(createNode(document,'cvParam',...
    'cvRef','MS', ...
    'accession','MS:1000579', ...
    'name','MS1 spectrum', ...
    'value',''));

% MAY supply a *child* term of MS:1000525 (spectrum representation) only once
% centroid or profile
if isCentroid
    fileContent.appendChild(createNode(document,'cvParam',...
        'cvRef','MS', ...
        'accession','MS:1000127', ...
        'name','centroid spectrum', ...
        'value',''));
else    
    fileContent.appendChild(createNode(document,'cvParam',...
        'cvRef','MS', ...
        'accession','MS:1000128', ...
        'name','profile spectrum', ...
        'value',''));
end

% MUST supply a *child* term of IMS:1000003 (ibd binary type) only once
% e.g.: IMS:1000030 (continuous)
% e.g.: IMS:1000031 (processed)
if isCentroid
    fileContent.appendChild(createNode(document,'cvParam',...
        'cvRef','IMS', ...
        'accession','IMS:1000031', ...
        'name','processed', ...
        'value',''));
else
    fileContent.appendChild(createNode(document,'cvParam',...
        'cvRef','IMS', ...
        'accession','IMS:1000030', ...
        'name','continuous', ...
        'value',''));
end

% MUST supply a *child* term IMS:1000009 (ibd checksum) only once
% e.g.: IMS:1000090 (ibd MD5)
% e.g.: IMS:1000091 (ibd SHA-1)
fileContent.appendChild(createNode(document,'cvParam',...   
    'cvRef','IMS', ...
    'accession','IMS:1000090', ...
    'name','ibd MD5', ...
    'value',num2str(md5))); 

% MUST supply a *child* term IMS:1000008 (ibd identification) only once
% e.g.: IMS:1000080 (universally unique identifier)
% ToDo: Check correct format of uuid
uuid = ['{', upper(char(uuid)), '}'];
fileContent.appendChild(createNode(document,'cvParam',...
    'cvRef','IMS', ...
    'accession','IMS:1000080', ...
    'name','universally unique identifier', ...
    'value',uuid)); 

% MAY supply a *child* term IMS:1000007 (ibd file) only once
% e.g.: IMS:1000070 (external binary uri)
%   "Location as an URI where to find the ibd file."
% Not used here

end % getFileContent

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function sourceFile = getSourceFile(document,fullfilename)

[pathstr,name,ext] = fileparts(fullfilename);

% Todo: check this parses correctly without the trailing path delimiter
sourceFile = createNode(document,'sourceFile', ...
    'id','sf1', ...
    'name',[name,ext], ...
    'location',pathstr');

% There is no Ionoptika J105 format listed in the MS ontology
% sourceFile.appendChild(createNode(document,'cvParam',...
%     'cvRef','MS', ...
%     'accession','MS:1000563', ...
%     'name','Thermo RAW file', ...
%     'value',''));
% 
% sourceFile.appendChild(createNode(document,'cvParam',...
%     'cvRef','MS', ...
%     'accession','MS:1000768', ...
%     'name','Thermo nativeID format', ...
%     'value',''));
% 
% sourceFile.appendChild(createNode(document,'cvParam',...
%     'cvRef','MS', ...
%     'accession','MS:1000569', ...
%     'name','SHA-1', ...
%     'value','7623BE263B25FF99FDF017154B86FAB742D4BB0B'));

end % sourceFile

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function contact = getContact(document,name,org,address,email)

contact = createNode(document,'contact');

% todo: best done via varargin
contact.appendChild(createNode(document,'cvParam',...
    'cvRef','MS', ...
    'accession','MS:1000586', ...
    'name','contact name', ...
    'value',name));

contact.appendChild(createNode(document,'cvParam',...
    'cvRef','MS', ...
    'accession','MS:1000590', ...
    'name','contact organization', ...
    'value',org));

contact.appendChild(createNode(document,'cvParam',...
    'cvRef','MS', ...
    'accession','MS:1000587', ...
    'name','contact address', ...
    'value',address));

contact.appendChild(createNode(document,'cvParam',...
    'cvRef','MS', ...
    'accession','MS:1000589', ...
    'name','contact email', ...
    'value',email));

end % contact

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function referenceableParamGroup = getReferenceableParamGroupMzArray(document,massTypeXml)

referenceableParamGroup = createNode(document,'referenceableParamGroup');

referenceableParamGroup.appendChild(createNode(document,'cvParam',...
    'cvRef','MS', ...
    'accession','MS:1000576', ...
    'name','no compression', ...
    'value',''));

referenceableParamGroup.appendChild(createNode(document,'cvParam',...
    'cvRef','MS', ...
    'accession','MS:1000514', ...
    'name','m/z array', ...
    'value','', ...
    'unitCvRef','MS', ...
    'unitAccession','MS:1000040', ...
    'unitName','m/z'));

referenceableParamGroup.appendChild(createNode(document,'cvParam',...
    'cvRef','IMS', ...
    'accession','IMS:1000101', ...
    'name','external data', ...
    'value','true'));

switch massTypeXml
    case '32-bit float'
        referenceableParamGroup.appendChild(createNode(document,'cvParam',...
            'cvRef','MS', ...
            'accession','MS:1000521', ...
            'name','32-bit float', ...
            'value',''));
    case '64-bit float'
        referenceableParamGroup.appendChild(createNode(document,'cvParam',...
            'cvRef','MS', ...
            'accession','MS:1000523', ...
            'name','62-bit float', ...
            'value',''));
    case '32-bit integer'
        referenceableParamGroup.appendChild(createNode(document,'cvParam',...
            'cvRef','MS', ...
            'accession','MS:1000519', ...
            'name','32-bit integer', ...
            'value',''));
    case '64-bit integer'
        referenceableParamGroup.appendChild(createNode(document,'cvParam',...
            'cvRef','MS', ...
            'accession','MS:1000522', ...
            'name','64-bit integer', ...
            'value',''));
    otherwise 
        ME = MException('imzmlError:DataTypeError','Unrecognised data type');
        throw(ME);
end

end % getReferenceableParamGroupMzArray

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function referenceableParamGroup = getReferenceableParamGroupIntensityArray(document,intensityTypeXml)

referenceableParamGroup = createNode(document,'referenceableParamGroup');

referenceableParamGroup.appendChild(createNode(document,'cvParam',...
    'cvRef','MS', ...
    'accession','MS:1000576', ...
    'name','no compression', ...
    'value',''));

referenceableParamGroup.appendChild(createNode(document,'cvParam',...
    'cvRef','MS', ...
    'accession','MS:1000515', ...
    'name','intensity array', ...
    'value','', ...
    'unitCvRef','MS', ...
    'unitAccession','MS:1000131', ...
    'unitName','number of counts'));

referenceableParamGroup.appendChild(createNode(document,'cvParam',...
    'cvRef','IMS', ...
    'accession','IMS:1000101', ...
    'name','external data', ...
    'value','true'));

switch intensityTypeXml
    case '32-bit float'
        referenceableParamGroup.appendChild(createNode(document,'cvParam',...
            'cvRef','MS', ...
            'accession','MS:1000521', ...
            'name','32-bit float', ...
            'value',''));
    case '64-bit float'
        referenceableParamGroup.appendChild(createNode(document,'cvParam',...
            'cvRef','MS', ...
            'accession','MS:1000523', ...
            'name','62-bit float', ...
            'value',''));
    case '32-bit integer'
        referenceableParamGroup.appendChild(createNode(document,'cvParam',...
            'cvRef','MS', ...
            'accession','MS:1000519', ...
            'name','32-bit integer', ...
            'value',''));
    case '64-bit integer'
        referenceableParamGroup.appendChild(createNode(document,'cvParam',...
            'cvRef','MS', ...
            'accession','MS:1000522', ...
            'name','64-bit integer', ...
            'value',''));
    otherwise 
        ME = MException('imzmlError:DataTypeError','Unrecognised data type');
        throw(ME);
end

end % getReferenceableParamGroupIntensityArray

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function referenceableParamGroup = getReferenceableParamGroupScan1(document)

referenceableParamGroup = createNode(document,'referenceableParamGroup');

referenceableParamGroup.appendChild(createNode(document,'cvParam',...
    'cvRef','MS', ...
    'accession','MS:1000093', ...
    'name','increasing m/z scan', ...
    'value',''));

referenceableParamGroup.appendChild(createNode(document,'cvParam',...
    'cvRef','MS', ...
    'accession','MS:1000095', ...
    'name','linear', ...
    'value',''));

% Doesn't really apply, but is it required?
% referenceableParamGroup.appendChild(createNode(document,'cvParam',...
%     'cvRef','MS', ...
%     'accession','MS:1000512', ...
%     'name','filter string', ...
%     'value','ITMS - p NSI Full ms [100,00-800,00]'));

end % getReferenceableParamGroupScan1

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function referenceableParamGroup = getReferenceableParamGroupSpectrum1(document,isPositiveIon)

referenceableParamGroup = createNode(document,'referenceableParamGroup');

referenceableParamGroup.appendChild(createNode(document,'cvParam',...
    'cvRef','MS', ...
    'accession','MS:1000579', ...
    'name','MS1 spectrum', ...
    'value',''));

referenceableParamGroup.appendChild(createNode(document,'cvParam',...
    'cvRef','MS', ...
    'accession','MS:1000511', ...
    'name','ms level', ...
    'value','0'));

referenceableParamGroup.appendChild(createNode(document,'cvParam',...
    'cvRef','MS', ...
    'accession','MS:1000128', ...
    'name','profile spectrum', ...
    'value',''));

if isPositiveIon
    referenceableParamGroup.appendChild(createNode(document,'cvParam',...
        'cvRef','MS', ...
        'accession','MS:1000130', ...
        'name','positive scan', ...
        'value',''));
else
    referenceableParamGroup.appendChild(createNode(document,'cvParam',...
        'cvRef','MS', ...
        'accession','MS:1000129', ...
        'name','negative scan', ...
        'value',''));
end

end % getReferenceableParamGroupSpectrum1

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function sample = getSample(document)

sample = createNode(document,'sample');

sample.appendChild(createNode(document,'cvParam',...
    'cvRef','MS', ...
    'accession','MS:1000001', ...
    'name','sample number', ...
    'value','1'));

end % getSample

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function software = getCustomSoftware(document)

software = createNode(document,'software');

software.appendChild(createNode(document,'cvParam',...
    'cvRef','MS', ...
    'accession','MS:1000799', ...
    'name','custom unreleased software tool', ...
    'value',''));

end % getCustomSoftware

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function scanSettings = getScanSettings(document,width,height)

scanSettings = createNode(document,'scanSettings');

% MUST supply a *child* term of IMS:1000049 (line scan direction) only once
% e.g.: IMS:1000492 (line scan bottom up)
% e.g.: IMS:1000491 (line scan left right)
% e.g.: IMS:1000490 (line scan right left)
% e.g.: IMS:1000493 (line scan top down)
scanSettings.appendChild(createNode(document,'cvParam',...
    'cvRef','IMS', ...
    'accession','IMS:1000493', ...
    'name','linescan top down', ...
    'value',''));

% MUST supply a *child* term of IMS:1000040 (scan direction) only once
% e.g.: IMS:1000400 (bottom up)
% e.g.: IMS:1000402 (left right)
% e.g.: IMS:1000403 (right left)
% e.g.: IMS:1000401 (top down)
scanSettings.appendChild(createNode(document,'cvParam',...
    'cvRef','IMS', ...
    'accession','IMS:1000402', ...
    'name','left right', ...
    'value',''));

% MUST supply a *child* term of IMS:1000048 (scan type) only once
% e.g.: IMS:1000480 (horizontal line scan)
% e.g.: IMS:1000481 (vertical line scan)
scanSettings.appendChild(createNode(document,'cvParam',...
    'cvRef','IMS', ...
    'accession','IMS:1000481', ...
    'name','vertical line scan', ...
    'value',''));

% MUST supply a *child* term of IMS:1000041 (scan pattern) only once
% e.g.: IMS:1000410 (meandering)
% e.g.: IMS:1000411 (one way)
% e.g.: IMS:1000412 (random access)
scanSettings.appendChild(createNode(document,'cvParam',...
    'cvRef','IMS', ...
    'accession','IMS:1000413', ...
    'name','flyback', ...
    'value',''));

% Not mandated, but a good idea!
scanSettings.appendChild(createNode(document,'cvParam',...
    'cvRef','IMS', ...
    'accession','IMS:1000042', ...
    'name','max count of pixel x', ...
    'value',num2str(width)));

scanSettings.appendChild(createNode(document,'cvParam',...
    'cvRef','IMS', ...
    'accession','IMS:1000043', ...
    'name','max count of pixel y', ...
    'value',num2str(height)));

% SHOULD supply a *child* term of IMS:1000040 (image) one or more times
% e.g.: IMS:1000044 (max dimension x)
% e.g.: IMS:1000045 (max dimension y)
% e.g.: IMS:1000046 (pixel size)
% However, we don't know the dimensions so...
% scanSettings.appendChild(createNode(document,'cvParam',...
%     'cvRef','IMS', ...
%     'accession','IMS:1000044', ...
%     'name','max dimension x', ...
%     'value','300', ...
%     'unitCvRef','UO', ...
%     'unitAccession','UO:0000017', ...
%     'unitName','micrometer'));
% scanSettings.appendChild(createNode(document,'cvParam',...
%     'cvRef','IMS', ...
%     'accession','IMS:1000045', ...
%     'name','max dimension y', ...
%     'value','300', ...
%     'unitCvRef','UO', ...
%     'unitAccession','UO:0000017', ...
%     'unitName','micrometer'));
% scanSettings.appendChild(createNode(document,'cvParam',...
%     'cvRef','IMS', ...
%     'accession','IMS:1000046', ...
%     'name','pixel size x', ...
%     'value','100', ...
%     'unitCvRef','UO', ...
%     'unitAccession','UO:0000017', ...
%     'unitName','micrometer'));
% scanSettings.appendChild(createNode(document,'cvParam',...
%     'cvRef','IMS', ...
%     'accession','IMS:1000047', ...
%     'name','pixel size y', ...
%     'value','100', ...
%     'unitCvRef','UO', ...
%     'unitAccession','UO:0000017', ...
%     'unitName','micrometer'));


% MALDI nonsense
% scanSettings.appendChild(createNode(document,'cvParam',...
%     'cvRef','MS', ...
%     'accession','MS:1000836', ...
%     'name','dried dropplet', ...
%     'value',''));
% scanSettings.appendChild(createNode(document,'cvParam',...
%     'cvRef','MS', ...
%     'accession','MS:1000835', ...
%     'name','matrix solution concentration', ...
%     'value','10'));
% scanSettings.appendChild(createNode(document,'cvParam',...
%     'cvRef','MS', ...
%     'accession','MS:1000834', ...
%     'name','matrix solution', ...
%     'value','DHB'));

end % getScanSettings

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function instrumentConfiguration = getInstrumentConfiguration(document)

instrumentConfiguration = createNode(document,'instrumentConfiguration');
instrumentConfiguration.setAttribute('id','IonoptikaJ105');

% Todo: No identifier for Ionoptika exists in psi-ms 
% Todo: Could add a customisation (MS:1000032) for the ion gun type

% instrumentConfiguration.appendChild(createNode(document,'cvParam',...
%     'cvRef','MS', ...
%     'accession','MS:1000557', ...
%     'name','LTQ FT Ultra', ...
%     'value',''));
% instrumentConfiguration.appendChild(createNode(document,'cvParam',...
%     'cvRef','MS', ...
%     'accession','MS:1000529', ...
%     'name','instrument serial number', ...
%     'value','none'));

    componentList = createNode(document,'componentList');
    componentList.setAttribute('count','3');
    
        % source component
        source = createNode(document,'source');
        source.setAttribute('order','1');
    
% MAY supply a *child* term of MS:1000482 (source attribute) one or more times
% e.g.: MS:1000392 (ionization efficiency)
% e.g.: MS:1000486 (source potential)
% e.g.: MS:1000843 (wavelength)
% e.g.: MS:1000844 (focus diameter x)
% e.g.: MS:1000845 (focus diameter y)
% e.g.: MS:1000846 (pulse energy)
% e.g.: MS:1000847 (pulse duration)
% e.g.: MS:1000848 (attenuation)
% e.g.: MS:1000849 (impact angle)
% e.g.: MS:1000850 (gas laser)
% et al.
% Todo: Could also put the extraction potential under cone voltage
% (MS:1000876)
        source.appendChild(createNode(document,'cvParam',...
            'cvRef','MS', ...
            'accession','MS:1000486', ...
            'name','source potential', ...
            'value',''));

% MUST supply term MS:1000008 (ionization type) or any of its children only once
% e.g.: MS:1000070 (atmospheric pressure chemical ionization)
% e.g.: MS:1000071 (chemical ionization)
% e.g.: MS:1000074 (fast atom bombardment ionization)
% e.g.: MS:1000075 (matrix-assisted laser desorption ionization)
% e.g.: MS:1000227 (multiphoton ionization)
% e.g.: MS:1000239 (atmospheric pressure matrix-assisted laser desorption ionization)
% e.g.: MS:1000255 (flowing afterglow)
% e.g.: MS:1000257 (field desorption)
% e.g.: MS:1000258 (field ionization)
% e.g.: MS:1000259 (glow discharge ionization)
% et al.
        source.appendChild(createNode(document,'cvParam',...
            'cvRef','MS', ...
            'accession','MS:1000402', ...
            'name','secondary ionization', ...
            'value',''));

% MAY supply a *child* term of MS:1000007 (inlet type) only once
% e.g.: MS:1000055 (continuous flow fast atom bombardment)
% e.g.: MS:1000056 (direct inlet)
% e.g.: MS:1000058 (flow injection analysis)
% e.g.: MS:1000059 (inductively coupled plasma)
% e.g.: MS:1000060 (infusion)
% e.g.: MS:1000061 (jet separator)
% e.g.: MS:1000062 (membrane separator)
% e.g.: MS:1000063 (moving belt)
% e.g.: MS:1000064 (moving wire)
% e.g.: MS:1000065 (open split)
% et al.
% None apply


% MAY supply a *child* term of IMS:1000002 (sample stage) one or more times
% e.g.: IMS:1000200 (position accuracy)
% e.g.: IMS:1000201 (step size)
% e.g.: IMS:1000202 (target material)
% Todo: Could put the pixel size here under step size

% Todo: could use this to describe the sample
%         source.appendChild(createNode(document,'cvParam',...
%             'cvRef','IMS', ...
%             'accession','IMS:1000202', ...
%             'name','target material', ...
%             'value','Conductive Glas'));
    
        componentList.appendChild(source);  % component 1 of 3

        % analyzer component
        analyzer = createNode(document,'analyzer');
        analyzer.setAttribute('order','2');
        
        % Todo: could put the quad and electrostatic analyser in this list
    
        analyzer.appendChild(createNode(document,'cvParam',...
            'cvRef','MS', ...
            'accession','MS:1000084', ...
            'name','time-of-flight', ...
            'value',''));

        analyzer.appendChild(createNode(document,'cvParam',...
            'cvRef','MS', ...
            'accession','MS:1000106', ...
            'name','reflectron on', ...
            'value',''));

        componentList.appendChild(analyzer);  % component 2 of 3
        
        % detector component
        detector = createNode(document,'detector');
        detector.setAttribute('order','3');
    
        % This is not ideal since postacceleration detector involved photons
        % and ours does not. 
        detector.appendChild(createNode(document,'cvParam',...
            'cvRef','MS', ...
            'accession','MS:1000114', ...
            'name','microchannel plate detector', ...
            'value',''));

        % todo: is this right? Transient recorder?
        detector.appendChild(createNode(document,'cvParam',...
            'cvRef','MS', ...
            'accession','MS:1000117', ...
            'name','analog-digital convertor', ...
            'value',''));

        componentList.appendChild(detector);  % component 3 of 3

    instrumentConfiguration.appendChild(componentList);
        
    softwareRef = createNode(document,'softwareRef');
    softwareRef.setAttribute('ref','IonoptikaJ105Software');

    instrumentConfiguration.appendChild(softwareRef);

end % getInstrumentConfiguration

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function dataProcessing = getDataProcessing(document)

dataProcessing = createNode(document,'dataProcessing');
dataProcessing.setAttribute('id','J105Processing');

% ToDO: Data processing actions?

    processingMethod = createNode(document,'processingMethod');
    processingMethod.setAttribute('order','1');
    processingMethod.setAttribute('softwareRef','IonoptikaJ105Software');
%     processingMethod.appendChild(createNode(document,'cvParam',...
%         'cvRef','MS', ...
%         'accession','MS:1000594', ...
%         'name','low intensity data point removal', ...
%         'value',''));
    dataProcessing.appendChild(processingMethod);

%     processingMethod = createNode(document,'processingMethod');
%     processingMethod.setAttribute('order','2');
%     processingMethod.setAttribute('softwareRef','MATLAB');
%     processingMethod.appendChild(createNode(document,'cvParam',...
%         'cvRef','MS', ...
%         'accession','MS:1000544', ...
%         'name','Conversion to mzML', ...
%         'value',''));
%     dataProcessing.appendChild(processingMethod);

end % getInstrumentConfiguration

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function node = createNode(doc,name,varargin)
% name is a string
% attributes is a struct

numargs = length(varargin);

if rem(numargs,2)
    ME = MException('xmlerror','Odd number of attributes');
    throw(ME);
end

attr = reshape(varargin,2,[]);
attr = attr';
numargs = size(attr,1);

node = doc.createElement(name);

for i = 1:numargs
    node.setAttribute(attr{i,1},attr{i,2});
end

end

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function spectrumList = insertContinuousSpectra(document,mass,massTypeSize,data,dataTypeSize,width,height,numScans)

str16 = num2str(16);
mzArrayLengthStr = num2str(length(mass));
mzArrayEncodedLengthStr = num2str(length(mass) * massTypeSize);
IntensityLengthStr = num2str(size(data,2));
IntensityEncodedLengthStr = num2str(size(data,2) * dataTypeSize);
IntensityEncodedLength = size(data,2) * dataTypeSize;

spectrumList = document.createElement('spectrumList');
spectrumList.setAttribute('count',num2str(numScans));
spectrumList.setAttribute('defaultDataProcessingRef','J105Processing');

% First data point is after the UUID and mass array
dataOffset = 16 + (length(mass) * massTypeSize);

for i = 1:numScans

    [y,x] = ind2sub([height,width],i);
    
    spectrum = createNode(document,'spectrum');
    spectrum.setAttribute('id',['Scan=',num2str(i)]);
    spectrum.setAttribute('defaultArrayLength','0');
    spectrum.setAttribute('index',num2str(i-1));    % zero-based
    
    referenceableParamGroupRef = createNode(document,'referenceableParamGroupRef');
    referenceableParamGroupRef.setAttribute('ref','spectrum1');
    spectrum.appendChild(referenceableParamGroupRef);

    scanList = createNode(document,'scanList');
    scanList.setAttribute('count','1');
    scanList.appendChild(createNode(document,'cvParam',...
        'cvRef','MS', ...
        'accession','MS:1000795', ...
        'name','no combination', ...
        'value',''));

    scan = createNode(document,'scan');
    scan.setAttribute('instrumentConfigurationRef','IonoptikaJ105');
    scan.appendChild(createNode(document,'referenceableParamGroupRef',...
        'ref','scan1'));
    scan.appendChild(createNode(document,'cvParam',...
        'cvRef','IMS', ...
        'accession','IMS:1000050', ...
        'name','position x', ...
        'value',num2str(x)));
    scan.appendChild(createNode(document,'cvParam',...
        'cvRef','IMS', ...
        'accession','IMS:1000051', ...
        'name','position y', ...
        'value',num2str(y)));

    scanList.appendChild(scan);
    spectrum.appendChild(scanList);

    
    binaryDataArrayList = createNode(document,'binaryDataArrayList');
    binaryDataArrayList.setAttribute('count','2');

    % mzarray
    binaryDataArray = createNode(document,'binaryDataArray');
    binaryDataArray.setAttribute('encodedLength','0');
    binaryDataArray.appendChild(createNode(document,'referenceableParamGroupRef',...
        'ref','mzArray'));
    binaryDataArray.appendChild(createNode(document,'cvParam',...
        'cvRef','IMS', ...
        'accession','IMS:1000102', ...
        'name','external offset', ...
        'value',str16));  % The mzarray is always just after the UUID
    binaryDataArray.appendChild(createNode(document,'cvParam',...
        'cvRef','IMS', ...
        'accession','IMS:1000103', ...
        'name','external array length', ...
        'value',mzArrayLengthStr)); % Always the same for continuous data
    binaryDataArray.appendChild(createNode(document,'cvParam',...
        'cvRef','IMS', ...
        'accession','IMS:1000104', ...
        'name','external encoded length', ...
        'value',mzArrayEncodedLengthStr));% Always the same for continuous data
    binaryDataArray.appendChild(createNode(document,'binary'));

    binaryDataArrayList.appendChild(binaryDataArray);
    
    % intensityarray
    binaryDataArray = createNode(document,'binaryDataArray');
    binaryDataArray.setAttribute('encodedLength','0');
    binaryDataArray.appendChild(createNode(document,'referenceableParamGroupRef',...
        'ref','intensityArray'));
    binaryDataArray.appendChild(createNode(document,'cvParam',...
        'cvRef','IMS', ...
        'accession','IMS:1000102', ...
        'name','external offset', ...
        'value',num2str(dataOffset)));
    binaryDataArray.appendChild(createNode(document,'cvParam',...
        'cvRef','IMS', ...
        'accession','IMS:1000103', ...
        'name','external array length', ...
        'value',IntensityLengthStr)); % Always the same for continuous data
    binaryDataArray.appendChild(createNode(document,'cvParam',...
        'cvRef','IMS', ...
        'accession','IMS:1000104', ...
        'name','external encoded length', ...
        'value',IntensityEncodedLengthStr));% Always the same for continuous data
    binaryDataArray.appendChild(createNode(document,'binary'));

    binaryDataArrayList.appendChild(binaryDataArray);
    
    spectrum.appendChild(binaryDataArrayList);

    spectrumList.appendChild(spectrum);
    
    dataOffset = dataOffset + IntensityEncodedLength;
    
end

end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function spectrumList = insertProcessedSpectra(document,mass,massTypeSize,data,dataTypeSize,width,height,numScans)

% This version of the code is designed to write peaks that have been
% identified from the total ion spectrum with their limits applied to each
% pixel. Therefore the lengths of the mz array and intensity array are the
% same for every pixel.
% If the method of selecting peaks changes then we will need to modify this
% code to write different length mzarrays for each pixel. 
% Of course, for each pixel the number of mz values is the same as the
% number of intensity values, but these could change from pixel-to-pixel. 

mzArrayLengthStr = num2str(length(mass));
mzArrayEncodedLength = length(mass) * massTypeSize;
mzArrayEncodedLengthStr = num2str(mzArrayEncodedLength);

IntensityLengthStr = num2str(size(data,2));
IntensityEncodedLength = size(data,2) * dataTypeSize;
IntensityEncodedLengthStr = num2str(IntensityEncodedLength);

spectrumList = document.createElement('spectrumList');
spectrumList.setAttribute('count',num2str(numScans));
spectrumList.setAttribute('defaultDataProcessingRef','J105Processing');

% First data point is after the UUID and mass array
% dataOffset = 16 + (length(mass) * massTypeSize);
dataOffset = 16;

for i = 1:numScans

    [y,x] = ind2sub([height,width],i);
    
    spectrum = createNode(document,'spectrum');
    spectrum.setAttribute('id',['Scan=',num2str(i)]);
    spectrum.setAttribute('defaultArrayLength','0');
    spectrum.setAttribute('index',num2str(i-1));    % zero-based
    
    referenceableParamGroupRef = createNode(document,'referenceableParamGroupRef');
    referenceableParamGroupRef.setAttribute('ref','spectrum1');
    spectrum.appendChild(referenceableParamGroupRef);

    scanList = createNode(document,'scanList');
    scanList.setAttribute('count','1');
    scanList.appendChild(createNode(document,'cvParam',...
        'cvRef','MS', ...
        'accession','MS:1000795', ...
        'name','no combination', ...
        'value',''));

    scan = createNode(document,'scan');
    scan.setAttribute('instrumentConfigurationRef','IonoptikaJ105');
    scan.appendChild(createNode(document,'referenceableParamGroupRef',...
        'ref','scan1'));
    scan.appendChild(createNode(document,'cvParam',...
        'cvRef','IMS', ...
        'accession','IMS:1000050', ...
        'name','position x', ...
        'value',num2str(x)));
    scan.appendChild(createNode(document,'cvParam',...
        'cvRef','IMS', ...
        'accession','IMS:1000051', ...
        'name','position y', ...
        'value',num2str(y)));

    scanList.appendChild(scan);
    spectrum.appendChild(scanList);

    
    binaryDataArrayList = createNode(document,'binaryDataArrayList');
    binaryDataArrayList.setAttribute('count','2');

    % mzarray
    binaryDataArray = createNode(document,'binaryDataArray');
    binaryDataArray.setAttribute('encodedLength','0');
    binaryDataArray.appendChild(createNode(document,'referenceableParamGroupRef',...
        'ref','mzArray'));
    binaryDataArray.appendChild(createNode(document,'cvParam',...
        'cvRef','IMS', ...
        'accession','IMS:1000102', ...
        'name','external offset', ...
        'value',num2str(dataOffset)));  
    binaryDataArray.appendChild(createNode(document,'cvParam',...
        'cvRef','IMS', ...
        'accession','IMS:1000103', ...
        'name','external array length', ...
        'value',mzArrayLengthStr)); % Always the same for continuous data
    binaryDataArray.appendChild(createNode(document,'cvParam',...
        'cvRef','IMS', ...
        'accession','IMS:1000104', ...
        'name','external encoded length', ...
        'value',mzArrayEncodedLengthStr));% Always the same for continuous data
    binaryDataArray.appendChild(createNode(document,'binary'));

    binaryDataArrayList.appendChild(binaryDataArray);
    
    dataOffset = dataOffset + mzArrayEncodedLength;
    
    % intensityarray
    binaryDataArray = createNode(document,'binaryDataArray');
    binaryDataArray.setAttribute('encodedLength','0');
    binaryDataArray.appendChild(createNode(document,'referenceableParamGroupRef',...
        'ref','intensityArray'));
    binaryDataArray.appendChild(createNode(document,'cvParam',...
        'cvRef','IMS', ...
        'accession','IMS:1000102', ...
        'name','external offset', ...
        'value',num2str(dataOffset)));
    binaryDataArray.appendChild(createNode(document,'cvParam',...
        'cvRef','IMS', ...
        'accession','IMS:1000103', ...
        'name','external array length', ...
        'value',IntensityLengthStr)); % Always the same for continuous data
    binaryDataArray.appendChild(createNode(document,'cvParam',...
        'cvRef','IMS', ...
        'accession','IMS:1000104', ...
        'name','external encoded length', ...
        'value',IntensityEncodedLengthStr));% Always the same for continuous data
    binaryDataArray.appendChild(createNode(document,'binary'));

    binaryDataArrayList.appendChild(binaryDataArray);
    
    spectrum.appendChild(binaryDataArrayList);

    spectrumList.appendChild(spectrum);
    
    dataOffset = dataOffset + IntensityEncodedLength;
    
end

end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function filename = putfilename(filter,filtername)

%   Function: putfilename
%   Usage: [filename] = putfilename(filter, filtername);
%
%   Collects a single filename from the user.
%   For multiple filenames use getfilenames.m
%
%   'filter' and 'filtername' are strings of the form...
%       filter = '*.mat'
%       filtername = 'MAT Files (*.mat)'
%   'filename' is a char array containing the name of the file including
%   the path
%
%   (c) May 2011, Alex Henderson
%

% Mostly based on getfilenames and tweaked to only accept a single filename

filetypes = {   filter, filtername; ...
                '*.*',  'All Files (*.*)'};

% example...            
%filetypes = {   '*.mat',  'MAT Files (*.mat)'; ...
%                '*.*',    'All Files (*.*)'};

setappdata(0,'UseNativeSystemDialogs',false);

[filename,pathname] = uiputfile(filetypes);

if (isfloat(filename) && (filename == 0))
    disp('Error: No filename selected');
    filename = 0;
    return;
end

if iscell(filename)
    % change from a row of filenames to a column of filenames
    % if only one file is selected we have a single string (not a cell
    % array)
    filename = filename';
else
    % convert the filename to a cell array (with one entry)
    filename = cellstr(filename);
end

for i = 1:size(filename,1)
    filename{i,1} = [pathname,filename{i,1}];
end

end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
