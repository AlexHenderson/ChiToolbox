function test_suite = test_ChiCloneable
initTestSuite;

function [obj] = setup
xvals = [1:10];
yvals = [11:20];
obj = ChiSpectrum(xvals,yvals);

function test_clone_same(obj)

cloned = clone(obj);
assertEqual(obj, cloned);

function test_clone_different(obj)

cloned = clone(obj);
changed = obj.subspectrum(6,3);
assertFalse(cloned == changed);

