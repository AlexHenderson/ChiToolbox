
# CHI Toolbox #
## Centre for Hyperspectral Imaging at the University of Manchester ##


MATLAB code for handling hyperspectral data generated by SIMS and FTIR instruments.

Author: Alex Henderson <alex.henderson@manchester.ac.uk>

Start date 17 March 2014 (although coding has been in progress for many years). Still work in progress...

If you find a problem with the Toolbox, please leave a message on the Bitbucket site [https://bitbucket.org/AlexHenderson/chitoolbox/issues](https://bitbucket.org/AlexHenderson/chitoolbox/issues "https://bitbucket.org/AlexHenderson/chitoolbox/issues"), or email Alex. 

## File formats
The following file formats are supported:

- Agilent (FTIR)
	- Single FTIR images (.seq files) using ChiAgilentFile
	- Mosaicked FTIR images (.dms files) using ChiAgilentFile    
- Biotof (ToFSIMS)
	-  Retrospective image files (*.xyt files) using ChiBiotofFile
- Bruker (FTIR)
	- Multiple spectra exported as a .mat file using ChiBrukerFile
- Ionoptika (ToFSIMS)
	-  Retrospective image files exported in the .h5 format using ChiIonoptikaFile
- Renishaw (Raman)
	- WiRE Version 4 (*.wdf files), single spectra, multiple spectra, images using ChiRenishawFile
- Thermo Fisher Scientific GRAMS SPC (Generic)
	- Data stored in .spc files using ChiThermoFile


## Example usage:

### Example 1
Assuming you have a .spc file in this location: C:\mydata\myfile.spc
    
    filename = 'C:\mydata\myfile.spc';
    myfile = ChiSPCFile.open(filename);
	myfile.plot;



----------
### Example 2
Assuming you have multiple SPC files in the same folder

    myfile = ChiSPCFile.open();

A dialog box will open allowing you to navigate to the location of the files. Select as many as required.  

	myfile.plot;			% overlay of the spectra
	myfile.plot('mean');	% mean of the spectra
	
	myfile.history.log		% list of filenames

Perform principal components analysis
	
	pca2 = myfile.pca;
	pca2.plotloadings(1);	% the loading on pc 1
	pca2.plotloadings(2);	% the loading on pc 2
	pca2.plotscores(1,2);	% scores plot of pcs 1 and 2

----------
### Example 3
Vector normalisation 

    myfile = ChiSPCFile.open();

A dialog box will open allowing you to navigate to the location of the files. Select as many as required.  


Both the following lines do the same thing, producing a **copy** of the data that has been vector normalised.

	myfilevn = myfile.vectornorm;
	myfilevn = vectornorm(myfile);

The following line vector normalises the data *in situ* and does not produce a copy. Note the original variable is **modified** (nothing changes the files on disc). 

	myfile.vectornorm;


----------
### Example 4
Assuming there are 8 SPC files and you have some *a priori* knowledge. Assume there are three classes of data 'alpha', 'beta' and 'gamma' and the files are in the order: beta, gamma, gamma, beta, beta, beta, alpha, alpha

    spectra = ChiSPCFile.open();	% select the 8 files

	apriori = ChiClassMembership('myinfo','beta',1, 'gamma',2, 'beta',3, 'alpha',2);
	spectra.classmembership = apriori;

	spectra.plot					% overlay of all spectra
	spectra.plot('byclass')			% overlay of all spectra with the same classes in the same colour
	spectra.plot('mean')			% mean of the 8 spectra
	spectra.plot('mean','byclass')	% mean of each of the classes 

	pca3 = spectra.pca;
	pca3.plotscores(1,2);	% scores plot of pcs 1 and 2 labelled according to the class structure

----------
### Example 5
Assuming you have an Agilent FTIR image tile in this location: C:\mydata\myfile.seq
    
    filename = 'C:\mydata\myfile.seq';
    myimage = ChiAgilentFile.open(filename);

	myimage.display;		% total intensity image
	myimage.plot('mean');	% the average spectrum across all pixels in the image
	myimage.plot('std'); 	% the average spectrum, with the standard deviation shaded, across all pixels in the image

To perform principal components analysis on the image

	pcaresult = myimage.pca;
	pcaresult.imagepc(1);		% scores image of principal component 1
	pcaresult.plotloading(1);	% loading on pc 1
	pcaresult.plotexplainedvariance;	% percentage explained variance
	pcaresult.plotcumexplainedvariance;	% cumulative percentage explained variance, with a line at 95%

