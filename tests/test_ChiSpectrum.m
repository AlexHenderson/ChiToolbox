function test_suite = test_ChiSpectrum
initTestSuite;

function [cs] = setup
xvals = [1:10];
yvals = [11:20];
cs = ChiSpectrum(xvals,yvals);

function test_numChannels(cs)
assertEqual(cs.numChannels(), 10);

function test_sum(cs)
assertEqual(cs.sum(), 155);

function test_sumrangeidx(cs)
assertEqual(cs.sumrangeidx(3,6), 58);

function test_sumrange(cs)
assertEqual(cs.sumrange(6,3), 58);

function test_subspectrumidx(cs)
expected = ChiSpectrum([3,4,5,6],[13,14,15,16]);
sub = cs.subspectrumidx(3,6);
expected.history = sub.history;
assertEqual(sub, expected);

function test_subspectrum(cs)
expected = ChiSpectrum([3,4,5,6],[13,14,15,16]);
sub = cs.subspectrum(3,6);
expected.history = sub.history;
assertEqual(sub, expected);

function test_removerangeidx(cs)
expected = ChiSpectrum([1,2,7,8,9,10],[11,12,17,18,19,20]);
remo = cs.removerangeidx(3,6);
expected.history = remo.history;
assertEqual(remo, expected);

function test_removerange(cs)
expected = ChiSpectrum([1,2,7,8,9,10],[11,12,17,18,19,20]);
remo = cs.removerange(3,6);
expected.history = remo.history;
assertEqual(remo, expected);

