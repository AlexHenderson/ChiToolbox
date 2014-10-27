function test_suite = test_ChiSpectrum
initTestSuite;

function [cs] = setup
xvals = [1:10];
yvals = [11:20];
cs = ChiSpectrum(xvals,yvals);

function test_channels(cs)
assertEqual(cs.channels(), 10);

function test_sum(cs)
assertEqual(cs.sum(), 155);

function test_sumrangeindex(cs)
assertEqual(cs.sumrangeindex(3,6), 58);

function test_sumrangex(cs)
assertEqual(cs.sumrangex(6,3), 58);

function test_subspectrumindex(cs)
expected = ChiSpectrum([3,4,5,6],[13,14,15,16]);
assertEqual(cs.subspectrumindex(3,6), expected);

function test_subspectrumxvals(cs)
expected = ChiSpectrum([3,4,5,6],[13,14,15,16]);
assertEqual(cs.subspectrumxvals(6,3), expected);

function test_removerangefromindexvals(cs)
expected = ChiSpectrum([1,2,7,8,9,10],[11,12,17,18,19,20]);
assertEqual(cs.removerangefromindexvals(3,6), expected);

function test_removerangefromxvalues(cs)
expected = ChiSpectrum([1,2,7,8,9,10],[11,12,17,18,19,20]);
assertEqual(cs.removerangefromxvalues(6,3), expected);

