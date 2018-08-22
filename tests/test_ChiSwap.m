classdef test_ChiSwap < matlab.unittest.TestCase

    
    properties
    end
    
    % =====================================================================
    methods (Test)

        function test_differentNumbers(this)
            [a,b] = ChiSwap(1,2);
            this.verifyEqual([a,b], [2,1]);
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_sameNumbers(this)
            [a,b] = ChiSwap(5,5);
            this.verifyEqual([a,b], [5,5]);
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%         function test_errorTooManyVariables(this)
%             this.verifyError(ChiSwap(1, 2, 3), 'MATLAB:TooManyInputs');
%         end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end
end

