% ToDo

%% ADD...

% PLS
% CVA
% PCCVA
% kfoldpccva
% 
% remove CO
% Remove regions
% keep regions
% 
% measurearea
% 
% read a collection of spectra
% 
% first and second derivative

% error ellipse

%% ALSO DO...

% Add help to each function
% Add overall package-based help

% Add option to produce a new figure to all plot functions

%% OCTAVE...

% Does everything work in Octave?
% figure handles with nargout
% gscatter
% 
% Which packages are required? stats, io, another? nan?
% 
% hello_octave.m
% hello_matlab.m

%% OPTIONAL...

% kmeans
% rmies
% Raman baseline removal

% other normalisations (other than vectornorm)




##Data types ##

Need to be able to handle the following data types: 

1D (spectrum)
2D (picture)
3D (hyperspectral image)
4D (hyperspectral 3D image)

Spatially modified
2D with pixels missing
3D with pixels missing
4D with pixels missing

Spectrally modified
1D sparse or with spectral ranges removed
3D sparse or with spectral ranges removed
4D sparse or with spectral ranges removed

Combinations
3D sparse with pixels missing
4D sparse with pixels missing

Collections
1D collection offset (number of spectra that are not spectrally aligned)
1D collection aligned (number of spectra that are spectrally aligned)

Groups of collections
1D collection offset (number of spectra that are not spectrally aligned)
1D collection aligned (number of spectra that are spectrally aligned)
For example, spectra from treated and untreated samples. 

Groups of collections
Spatially aware groups of 1D collections aligned (spectra from distinct regions of a 3D image)
Spatially aware groups of 1D collections aligned (spectra from distinct regions of a 4D image)
For example, we want to be able to handle the pixels (spectra) from distinct regions of a 
hyperspectral image and work on them separately, before combining them back and rendering them in 2/3/4D. 
We may also wish to know how close these distinct regions are. 


