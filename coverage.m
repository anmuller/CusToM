%% Test case from Cycling Example
import matlab.unittest.TestSuite
import matlab.unittest.TestRunner
import matlab.unittest.plugins.CodeCoveragePlugin

addpath(genpath('Functions'));
addpath(genpath('Tests'));

d = dir('Functions');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
for idx=1:length(nameFolds)
    nameFolds{idx} =['Functions/', nameFolds{idx}];
end

suite = testsuite('Tests/Cycling/SolverTestCycling.m');
runner = TestRunner.withTextOutput;
runner.addPlugin(CodeCoveragePlugin.forFolder(nameFolds))

testCase  = SolverTestCycling;
res = runner.run(suite);
