function results = ChiTestFormats()

clc;

import matlab.unittest.TestSuite

filename = mfilename('fullpath');
[pathstr,name,ext] = fileparts(filename); %#ok<ASGLU>

testSuiteFolder = TestSuite.fromFolder(pathstr);

if nargout
    results = run(testSuiteFolder);
else
    run(testSuiteFolder);
end
