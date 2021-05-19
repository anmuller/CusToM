classdef SolverTestPickAndPlace < matlab.unittest.TestCase
    methods(Test)
        function InverseKinematicsTest(testCase)
            
            actualpath = pwd;
            cd ..
            cd ..
            Installation;
            cd(actualpath);
            
            load('AnalysisParameters.mat');
            InverseKinematics(AnalysisParameters);
            
            path_expectation = 'PickAndPlace_Expected';
            path =  'PickAndPlace';
            
            
            InverseKinematicsResults_Expected = load([path_expectation, '/InverseKinematicsResults.mat']);
            InverseKinematicsResults = load([path, '/InverseKinematicsResults.mat']);
            
            testCase.assertEqual(InverseKinematicsResults,InverseKinematicsResults_Expected,'RelTol',0.1,'AbsTol',0.01);
        end
        
        function BiomechanicalModelTest(testCase)
            
            
            actualpath = pwd;
            cd ..
            cd ..
            Installation;
            cd(actualpath);
            
            
            load('ModelParameters.mat');
            load('AnalysisParameters.mat');
            
            CalibrateModelGenerationNum(ModelParameters,AnalysisParameters);
            
        end
    end
end

