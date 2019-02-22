classdef test_ChiSpectrum < matlab.unittest.TestCase

    
    properties
        spectrum
        xvals = 1:10;
        yvals = 11:20;
    end
    
    % =====================================================================
    methods (TestMethodSetup)
        function createChiSpectrum(this)
            % comment
            this.spectrum = ChiSpectrum(this.xvals,this.yvals);
        end
    end    
    
    % =====================================================================
    methods (Test)
        
        function test_numchannels(this)
            this.verifyEqual(this.spectrum.numchannels(), 10);
        end
   
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_sum(this)
            this.verifyEqual(this.spectrum.sum(), 155);
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_sumrangeidx(this)
            this.verifyEqual(this.spectrum.sumrangeidx(3,6), 58);
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_sumrange(this)
            this.verifyEqual(this.spectrum.sumrange(6,3), 58);
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_keeprangeidx(this)
            expected = ChiSpectrum([3,4,5,6],[13,14,15,16]);
            known = this.spectrum.keeprangeidx(3,6);
            % Remove history since this adds a 'Cloned' statement
            known.history = [];
            expected.history = [];
            this.verifyEqual(known, expected);
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_keeprange(this)
            expected = ChiSpectrum([3,4,5,6],[13,14,15,16]);
            known = this.spectrum.keeprange(3,6);
            % Remove history since this adds a 'Cloned' statement
            known.history = [];
            expected.history = [];
            this.verifyEqual(known, expected);
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_removerangeidx(this)
            expected = ChiSpectrum([1,2,7,8,9,10],[11,12,17,18,19,20]);
            known = this.spectrum.removerangeidx(3,6);
            % Remove history since this adds a 'Cloned' statement
            known.history = [];
            expected.history = [];
            this.verifyEqual(known, expected);
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_removerange(this)
            expected = ChiSpectrum([1,2,7,8,9,10],[11,12,17,18,19,20]);
            known = this.spectrum.removerange(3,6);
            % Remove history since this adds a 'Cloned' statement
            known.history = [];
            expected.history = [];
            this.verifyEqual(known, expected);
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_clone_same(this)
            cloned = this.spectrum.clone();
            cloned.history = [];
            this.spectrum.history = [];
            this.verifyEqual(this.spectrum, cloned);
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_clone_different(this)
            cloned = this.spectrum.clone();
            changed = this.spectrum.keeprange(6,3);
            cloned.history = [];
            changed.history = [];
            this.verifyNotEqual(cloned, changed);
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
    
end

