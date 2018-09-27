classdef test_ChiRenishawFile < matlab.unittest.TestCase

    
    properties
        filenameimage = [];
        filenamespectrum = [];
        filenamespectra = [];
        filenamespectra_singlefile = [];
        testimage = [];
        testspectrum = [];
        testspectra = [];
        testspectra_singlefile = [];
    end
    
    % =====================================================================
    methods (TestMethodSetup)
        function setup(this)
            if strcmp(getenv('COMPUTERNAME'),'BOMBARDIER')
                this.filename = '';
            else
                this.filenamespectrum = 'D:\Data_Raman\Kat\Single point spectra\532nm Raman\All_WDF\ARGININE_532_Cell1_1.wdf';
                this.filenamespectra = {'D:\Data_Raman\Jo\HL60 BaP MeOH_big cell_532_1x3_600gr.wdf';'D:\Data_Raman\Kat\Single point spectra\532nm Raman\All_WDF\ASPARAGINE_532_Cell2_1.wdf'};
                this.filenameimage = 'D:\Data_Raman\Jo\Test images\WORKS_HL60 BAPMeOH 785 100% 1x6acc 600gr.wdf';
                this.filenamespectra_singlefile = 'D:\Data_Raman\Jo\HL60 BaP MeOH_big cell_532_1x3_600gr.wdf';
            end
            
            this.testimage = ChiRenishawFile.read(this.filenameimage);            
            this.testspectrum = ChiRenishawFile.read(this.filenamespectrum);
            this.testspectra = ChiRenishawFile.read(this.filenamespectra);            
            this.testspectra_singlefile = ChiRenishawFile.read(this.filenamespectra_singlefile);            
            
        end
    end    
    
    % =====================================================================
    methods (Test)
        
      % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_displayimage(this)
            this.testimage.display;
        end
      % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_displayspectra(this)
            this.testspectra.display;
        end
      % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_displayspectra_singlefile(this)
            this.testspectra_singlefile.display;
        end
      % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_displayspectrum(this)
            this.testspectrum.display;
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
                this.verifyTrue(length(this.testspectra.filenames) == 2);
            end
            if ~isempty(this.filenamespectra_singlefile)
                this.verifyTrue(iscell(this.testspectra_singlefile.filenames));
                this.verifyTrue(length(this.testspectra_singlefile.filenames) == 1);
            end
        end
        
      % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end

