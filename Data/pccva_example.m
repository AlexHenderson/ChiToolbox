fromfile = load('../Data/utidata.mat');
data = ChiIRSpectralCollection(fromfile.wavenumbers,fromfile.uti);

metadata = ChiMetadataSheet('../Data/uti_metadata.xlsx');

data.classmembership = metadata.membership('Bacteria');
data.plot('grouped','mean')

data.vectornorm.removeco2.plot('grouped','mean')

pcaresult = data.pca();
pcaresult.plotscores(1,2);

pcaresult = data.vectornorm.pca();
pcaresult.plotscores(1,2);
pcaresult.plotloadings(1);
pcaresult.plotloadings(2);

cvaresult = data.vectornorm.pccva();
cvaresult.plotscores(1,2);
cvaresult.plotloadings(1);
cvaresult.plotloadings(2);

% overfitting
cvaresult = data.vectornorm.pccva(30);
cvaresult.plotscores(1,2);
cvaresult.plotloadings(1);
cvaresult.plotloadings(2);

