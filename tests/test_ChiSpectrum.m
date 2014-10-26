function test_suite = test_ChiSpectrum
initTestSuite;

function [cs] = setup
xvals = [1:10];
yvals = [10:20];
cs = ChiSpectrum(xvals,yvals);

function test_channels(cs)
assertEqual(cs.channels(), 10);

function test_sum(cs)
assertEqual(cs.sum(), 165);

function test_sumrangeindex(cs)
assertEqual(cs.sumrangeindex(3,6), 54);

function test_sumrangex(cs)
assertEqual(cs.sumrangex(6,3), 54);

function test_subspectrumindex(cs)
expected = ChiSpectrum([3,4,5,6],[12,13,14,15]);
assertEqual(cs.subspectrumindex(3,6), expected);

function test_subspectrumxvals(cs)
expected = ChiSpectrum([3,4,5,6],[12,13,14,15]);
assertEqual(cs.subspectrumxvals(6,3), expected);

