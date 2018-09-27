classdef test_ChiThermoFile < matlab.unittest.TestCase

    
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
                this.filename = '';
            else
                this.filenamespectrum = 'D:\Data_FTIR\Ansaf\HL60 fixed set 1 20uL REPEAT 1_2018-04-13T16-41-48.spc';
                this.filenamespectra = {'D:\Data_FTIR\Anu\66002_2018-02-21T15-10-41.spc';'D:\Data_FTIR\Anu\66002_2018-02-21T15-13-55.spc';'D:\Data_FTIR\Anu\66003_2018-02-21T16-17-53.spc'};
            end
            
            this.testspectrum = ChiThermoFile.read(this.filenamespectrum);            
            this.testspectra = ChiThermoFile.read(this.filenamespectra);            
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
                this.verifyTrue(length(this.testspectra.filenames) == 3);
            end
        end
        
      % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end

