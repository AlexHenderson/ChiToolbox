function test_suite = test_ChiSwap
initTestSuite;

function test_differentNumbers
[a,b]=ChiSwap(1,2);
assertEqual([a,b], [2,1]);

function test_sameNumbers
[a,b]=ChiSwap(5,5);
assertEqual([a,b], [5,5]);

function test_errorTooManyVariables
assertExceptionThrown(@() ChiSwap(1, 2, 3), 'MATLAB:TooManyInputs');
