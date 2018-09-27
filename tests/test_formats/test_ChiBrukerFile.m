classdef test_ChiBrukerFile < matlab.unittest.TestCase

    
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
%                 this.filenameimage = 'D:\Data_SIMS\Biotof data\2D (XYT)\2BDSISO.XYT';
                this.filenamespectrum = 'D:\Data_FTIR\James\Bruker MAT Files\k562_ctrl_test2.mat';
                this.filenamespectra = {'D:\Data_FTIR\James\Bruker MAT Files\k562_dmso_t20_r1.mat';'D:\Data_FTIR\James\Bruker MAT Files\k562_PL63_t20_r3.mat'};            
            end
%             this.testimage = ChiBrukerFile.open(this.filenameimage);            
            this.testspectrum = ChiBrukerFile.open(this.filenamespectrum);            
            this.testspectra = ChiBrukerFile.open(this.filenamespectra);            
        end
    end    
    
    % =====================================================================
    methods (Test)
        
      % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_displayimage(this)
            if ~isempty(this.filenameimage)
                this.testimage.display;
            end
        end
   
      % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_displayspectrum(this)
            if ~isempty(this.filenamespectrum)
                this.testspectrum.display;
            end
        end
   
      % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_displayspectra(this)
            if ~isempty(this.filenamespectra)
                this.testspectra.display;
            end
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

