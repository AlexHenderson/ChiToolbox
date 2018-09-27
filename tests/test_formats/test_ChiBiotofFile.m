classdef test_ChiBiotofFile < matlab.unittest.TestCase

    
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
                this.filenameimage = 'D:\Data_SIMS\Biotof data\2D (XYT)\2BDSISO.XYT';
            else
                this.filenameimage = 'D:\Data_SIMS\Biotof data\2D (XYT)\2BDSISO.XYT';
                this.filenamespectrum = 'D:\Data_SIMS\Biotof data\SIMS UTI\positive UTI\cf102a2.dat';
                this.filenamespectra = {'D:\Data_SIMS\Biotof data\SIMS UTI\positive UTI\cf102a2.dat';'D:\Data_SIMS\Biotof data\SIMS UTI\positive UTI\cf102a3.dat';'D:\Data_SIMS\Biotof data\SIMS UTI\positive UTI\cf102b2.dat';'D:\Data_SIMS\Biotof data\SIMS UTI\positive UTI\cf102b3.dat';'D:\Data_SIMS\Biotof data\SIMS UTI\positive UTI\cf102c1.dat';'D:\Data_SIMS\Biotof data\SIMS UTI\positive UTI\cf102c2.dat';'D:\Data_SIMS\Biotof data\SIMS UTI\positive UTI\cf102c3.dat'};            
            end
            this.testimage = ChiBiotofFile.open(this.filenameimage);            
            this.testspectrum = ChiBiotofFile.open(this.filenamespectrum);            
            this.testspectra = ChiBiotofFile.open(this.filenamespectra);            
        end
    end    
    
    % =====================================================================
    methods (Test)
        
      % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_displayimage(this)
            this.testimage.display;
        end
   
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
            this.verifyTrue(iscell(this.testimage.filenames));
            this.verifyTrue(length(this.testimage.filenames) == 1);
            this.verifyTrue(iscell(this.testspectrum.filenames));
            this.verifyTrue(length(this.testspectrum.filenames) == 1);
            this.verifyTrue(iscell(this.testspectra.filenames));
            this.verifyTrue(length(this.testspectra.filenames) == 7);
        end
      % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end

