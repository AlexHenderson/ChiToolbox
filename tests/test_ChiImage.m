function test_suite = test_ChiImage
initTestSuite;

function [obj] = setup
% ChiImage(xvals,yvals,reversex,xlabel,ylabel,xpixels,ypixels)

yvals=magic(10);
yvals=cat(3,yvals,yvals+2);
yvals=cat(3,yvals,yvals+2);
yvals=cat(3,yvals,yvals+2);
yvals=cat(3,yvals,yvals+2);

dims=size(yvals);

xvals=1:dims(3);

obj = ChiImage(xvals,yvals,false,'','',dims(2),dims(1));

function test_channels(obj)
assertEqual(obj.channels(), 16);

function test_removerangefromindexvals(obj)
obj = obj.removerangefromindexvals(3,6);
assertEqual(obj.channels(), 12);

function test_removerangefromxvalues(obj)
obj = obj.removerangefromindexvals(3,6);
assertEqual(obj.channels(), 12);

function test_totalspectrum(obj)
expected=ChiSpectrum(obj.xvals,[5050,5250,5250,5450,5250,5450,5450,5650,5250,5450,5450,5650,5450,5650,5650,5850]);
assertEqual(obj.totalspectrum(), expected);

function test_totalspectrumfollowingremoval(obj)
obj = obj.removerangefromindexvals(3,6);
expectedxvals = [1,2,7,8,9,10,11,12,13,14,15,16];
expectedyvals = [5050,5250,5450,5650,5250,5450,5450,5650,5450,5650,5650,5850];
expected=ChiSpectrum(expectedxvals,expectedyvals);
assertEqual(obj.totalspectrum(), expected);

