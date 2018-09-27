classdef test_ChiMettlerToledoFile < matlab.unittest.TestCase

    
    properties
        filenameimage = [];
        filenamespectrum = [];
        filenamespectra = [];
        testimage = [];
        testspectrum = [];
        testspectra = [];
    end
    
    % =====================================================================
    methods (TestMethodSetup)
        function setup(this)
            if strcmp(getenv('COMPUTERNAME'),'BOMBARDIER')
                this.filenameimage = '';
            else
                this.filenamespectrum = 'C:\Users\Alex\Dropbox (The University of Manchester)\shared\alexPapersAndData\dataibuprofenpaper\IBU calibration in ethanol\10gkg\ATR\IBU_calibration_10gkg_50H2O_16_11_2009 #4.asc';
                this.filenamespectra = {...
                    'C:\Users\Alex\Dropbox (The University of Manchester)\shared\alexPapersAndData\dataibuprofenpaper\IBU calibration in ethanol\10gkg\ATR\IBU_calibration_10gkg_50H2O_16_11_2009 #3.asc'; ...
                    'C:\Users\Alex\Dropbox (The University of Manchester)\shared\alexPapersAndData\dataibuprofenpaper\IBU calibration in ethanol\10gkg\ATR\IBU_calibration_10gkg_50H2O_16_11_2009 #4.asc'; ...
                    'C:\Users\Alex\Dropbox (The University of Manchester)\shared\alexPapersAndData\dataibuprofenpaper\IBU calibration in ethanol\10gkg\ATR\IBU_calibration_10gkg_50H2O_16_11_2009 #5.asc'; ...
                    'C:\Users\Alex\Dropbox (The University of Manchester)\shared\alexPapersAndData\dataibuprofenpaper\IBU calibration in ethanol\10gkg\ATR\IBU_calibration_10gkg_50H2O_16_11_2009 #6.asc'};
            end
            this.testspectrum = ChiMettlerToledoFile.open(this.filenamespectrum);
            this.testspectra = ChiMettlerToledoFile.open(this.filenamespectra);
        end
    end    
    
    % =====================================================================
    methods (Test)
        
      % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_displayspectrum(this)
            this.testspectrum.display;
        end
      % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_displayspectra(this)
            this.testspectra.display;
        end
      % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_checkfilenames(this)
            if ~isempty(this.filenameimage)
                this.verifyTrue(iscell(this.testimage.filenames));
                this.verifyTrue(length(this.testimage.filenames) == 1);
            end
            if ~isempty(this.filenamespectrum)
                this.verifyTrue(iscell(this.testspectrum.filenames));
                this.verifyTrue(length(this.testspectrum.filenames) == 1);
            end
            if ~isempty(this.filenamespectra)
                this.verifyTrue(iscell(this.testspectra.filenames));
                this.verifyTrue(length(this.testspectra.filenames) == 4);
            end
        end
   
      % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end
