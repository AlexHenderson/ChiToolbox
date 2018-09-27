classdef test_ChiAgilentFile < matlab.unittest.TestCase

    
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
                this.filenameimage = 'C:\Data_FTIR\Caryn\piece-of-24hr dewax s51\24hr dewax s51.dms';
            else
                this.filenameimage = 'D:\Data_FTIR\Caryn\piece-of-24hr dewax s51\24hr dewax s51.dms';
            end
            this.testimage = ChiAgilentFile.read(this.filenameimage);
        end
    end    
    
    % =====================================================================
    methods (Test)
        
      % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_displayimage(this)
            this.testimage.display;
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
                this.verifyTrue(length(this.testspectra.filenames) == 1);
            end
        end
      % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end

