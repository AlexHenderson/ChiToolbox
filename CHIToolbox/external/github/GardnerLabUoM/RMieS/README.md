# RMieS #

### Resonant Mie Scattering EMSC (RMieS-EMSC) correction for infrared spectroscopy ###

Paul Bassan, Achim Kohler, Harald Martens, Joe Lee and Peter Gardner

This work is the result of a collaboration between the University of Manchester, UK, and Nofima Mat, UMB, Norway.

## Background ##

The algorithm is described in a paper in Analyst [1] and the fundamental physics of resonant Mie scattering is described in [2]. The first Mie scattering modification of EMSC is given in [3] and the original EMSC is given in [4]. 

This algorithm is ideally suited to correct IR data from cells that are strong scatterers of infrared radiation and give rise to distortions in the baseline. It was originally developed for analysis of single cell spectra but is equally suitable to spectra from a collection of cells. 

The algorithm does require a reference spectrum which is similar to the sample under investigation. We have found that the following will work for most biological cells, either (i) the average spectrum from a many single cell spectra or (ii) the spectrum of a thin film of Matrigel<sup>&reg;</sup>. You can input your own reference if you have one. We have found, using simulated data [1], that as long as the original reference is reasonably suitable, then the iterative method ensures that the corrected spectrum very closely resembles the pure absorption spectrum, but we make no guarantee of this in every case. 

The algorithm is still underdevelopment so do not get disheartened if it does not give perfect results first time. 

We hope that you will find this algorithm useful.


[1]
Resonant Mie Scattering (RMieS) correction of infrared spectra from highly scattering biological samples    
Paul Bassan, Achim Kohler, Harald Martens, Joe Lee, Hugh J. Byrne, Paul Dumas, Ehsan Gazi, Michael Brown, Noel Clarke and Peter Gardner      
*Analyst*. **135**(2) (2010) 268-277. doi:[10.1039/b921056c](https://doi.org/10.1039/b921056c)

[2]
Resonant Mie scattering in infrared spectroscopy of biological materials &ndash; understanding the 'dispersion artefact'   
Paul Bassan, Hugh J. Byrne, Franck Bonnier, Joe Lee, Paul Dumas and Peter Gardner   
*Analyst*. **134**(8) (2009) 1586-1593. doi:[10.1039/b904808a](https://doi.org/10.1039/b904808a)    

[3]
Estimating and Correcting Mie Scattering in Synchrotron-Based Microscopic Fourier Transform Infrared Spectra by Extended Multiplicative Signal Correction.   
Kohler, A.; Sule-Suso, J.; Sockalingum, G. D.; Tobin, M.; Bahrami, F.; Yang, Y.; Pijanka, J.; Dumas, P.; Cotte, M.; Martens, H.    
*Appl Spectrosc* **62** (2008) 259-266 doi:[10.1366/000370208783759669](https://doi.org/10.1366/000370208783759669)

[4]
Martens, H.; Stark, E. 
Extended multiplicative signal correction and spectral interference subtraction: New preprocessing methods for near infrared spectroscopy   
Harald Martens and Edward Stark   
*Journal of Pharmaceutical and Biomedical Analysis* **9** (1991) 625-635. doi:[10.1016/0731-7085(91)80188-F](https://doi.org/10.1016/0731-7085(91)80188-F)  

## Licence and Disclaimer ##

This code is licensed under the GNU Lesser General Public License v3.0. A copy of this licence is enclosed. 
   
The algorithm is provided 'as is' without warranty of any kind, either express or implied, including, but not limited to, the implied warranties of fitness for a purpose, or the warranty of non-infringement. 

## Installation ##

The correction algorithm requires MATLAB. Download the [zip file](https://github.com/GardnerLabUoM/RMieS/archive/master.zip) and unzip. Transfer the contents to a convenient location. Add the root of the folder to your MATLAB path. 

The algorithm and necessary files are now ready for use. Please read following sections on how to use the algorithm.

A Matrigel<sup>&reg;</sup> spectrum is the built-in reference spectrum. You can use a custom spectrum which is explained later in this document.

Using the RMieS\_EMSC\_v5 algorithm:

1. Have your data ready in MATLAB in the form of:
	- A column vector for the wavenumber values in ascending order. Dimension should be [K x 1]
	- A row matrix of your spectra (spectra in rows). Dimension should be [N x K], where N is the number of spectra, and K is the number of absorbance values which is the same as the number of wavenumber values.

2. Call the wavenumber vector “WN”

3. Call the spectra data matrix “ZRaw”

4. Copy and paste the following into your command window or m-file script:

    ```matlab
    correction_options =  [ ...              
      0;  	 % 1. Desired resolution, (0 keeps original resolution)              
      1000;  % 2. Lower wavenumber range (min value is 1000)        
      4000;  % 3. Upper wavenumber range (max value is 4000)   
      1;  	 % 4. Number of iterations   
      2;     % 5. Mie theory option (smooth or RMieS)   
      7;     % 6. Number of principal components used (8 recommended)   
      2;     % 7. Lower range for scattering particle diameter / um   
      8;     % 8. Upper range for scattering particle diamter / um   
      1.1;   % 9. Lower range for average refractive index   
      1.5;   % 10. Upper range for average refractive index   
      10;    % 11. Number of values for each scattering parameter default 10   
      1;     % 12. Orthogonalisation, 0 = no, 1 = yes. (1 recommended)   
      1 ...  % 13. Which reference spectrum, 1 = Matrigel, 2 = Simulated   
    ];
    ```

1. Change the correction options as necessary, this is explained in more detail later.

6. Copy and paste the following command into the MATLAB command window or m-file, 
 
    ```matlab
    [WNout, ZCorr, History] = RMieS_EMSC_v5(WN, ZRaw, correction_options);
	```

7. The following is the output from the algorithm:
	- WNout – the new wavenumber vector that is output from the algorithm
	- ZCorr – the corrected spectra
	- History – a 3D matrix containing a history of the corrected spectra.

8. Also included is an m-file called “Test_interface” which is an example of some data being corrected and then plotted. This shows the basic outline of how to use the algorithm.


## Correction options ##

1. Desired resolution. Chops out columns of the data matrix to get data closest to the resolution specified. A value of “0” leaves the data in its current resolution.

2. Lower wavenumber region. The minimum wavenumber value in cm<sup>-1</sup> of the spectra. The current lowest is 1000 cm<sup>-1</sup> because the built in Matrigel<sup>&reg;</sup> reference spectrum starts at 1000 cm<sup>-1</sup>. If your own reference spectrum is provided, you can use the same range as that spectrum.

3. Upper wavenumber region. Current maximum is 4000 cm<sup>-1</sup> again due to the built-in Matrigel<sup>&reg;</sup> spectrum.

4. Number of iterations. 1 gives the first estimation.

5. Mie theory option:   
	1  = Non-resonant Mie correction (the Achim Kohler original)   
	2  = Resonant Mie (RMieS) correction   
	3  = Full Mie theory [under construction]

6. Number of principal components used from the decomposed Mie scattering curves matrix. Recommended is 7 or 8.

7. Lower range of the scattering particle radius in µm. Recommended value is 2.

8. Upper range of the scattering particle radius in µm. Recommended value is 8.

9. Lower range of the scattering particle average refractive index. Recommended value is 1.1.

10. Upper range of the scattering particle average refractive index. Recommended value is 1.5.

11. Number of equidistant values for the 3 parameters used for construction the Mie scattering curve matrix. Recommended is 10 resulting in 10x10x10 = 1000 curves. As this number increases the correction will take longer.

12. Gram Schmidt process option, 1 = on, 0 = off. Recommended value is 1. This basically makes the descriptive vectors orthogonal.

13. Which reference spectrum,   
	0 = uses the custom spectrum entered by the user.   
	1 = uses the built in Matrigel spectrum (recommended).   
	2 = uses a simulated spectrum, this was included for another purpose, not recommended.   


### Using a custom reference spectrum ###

The function works much the same as before; just a slight modification:

```matlab
[WNout, ZCorr, History] = RMieS_EMSC_v5(WN, ZRaw, correction_options, WN_ref, ZRef);
```

Where ```WN_ref``` and ```ZRef``` are the wavenumber and absorbance values for the reference spectrum. These should be column and row vectors respectively. This spectrum is automatically interpolated should it not be the same length as the ```ZRaw``` data. Ideally however, this should be the same length.


Other additional points:

1. The CO<sub>2</sub> region of the spectrum is automatically down-weighted and ignored in this algorithm. There is currently no compensation for water vapour issues.

2. The corrected spectra are normalised using the BASIC un-weighted EMSC approach. We advise that you look at your data and decide if this normalisation is suitable for your purposes. You can perform any further normalisations you wish to, without the concern of distorting your spectra.

3. The algorithm will correct any spectrum submitted to it. This might cause problems when dealing with images when a pixel from a blank region of the slide is present, so be careful with this!



Good luck with using the RMieS\_EMSC\_v5, we are very interested in hearing all comments and feedback, be it positive or negative, so that we can develop accordingly.

