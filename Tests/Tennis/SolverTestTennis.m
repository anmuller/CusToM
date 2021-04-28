classdef SolverTestTennis < matlab.unittest.TestCase
    methods(Test)
        function InverseKinematicsTest(testCase)
            
            actualpath = pwd;
            cd ..
            cd ..
            Installation;
            cd(actualpath);
            
            load('AnalysisParameters.mat');
            InverseKinematics(AnalysisParameters);
            
            path_expectation = 'tennis_Expected';
            path =  'tennis';
            
            
            InverseKinematicsResults_Expected = load([path_expectation, '/InverseKinematicsResults.mat']);
            InverseKinematicsResults = load([path, '/InverseKinematicsResults.mat']);
            
            testCase.assertEqual(InverseKinematicsResults,InverseKinematicsResults_Expected,'RelTol',0.1,'AbsTol',0.01);
        end
        
        function ExternalForcesComputationTest(testCase)
            
            actualpath = pwd;
            cd ..
            cd ..
            Installation;
            cd(actualpath);
            
            load('AnalysisParameters.mat');
            load('ModelParameters.mat');
            ExternalForcesComputation(AnalysisParameters, ModelParameters);
            
            path_expectation = 'tennis_Expected';
            path =  'tennis';
            
            
            ExperimentalData_Expected = load([path_expectation, '/ExperimentalData.mat']);
            ExperimentalData = load([path, '/ExperimentalData.mat']);
            
            testCase.assertEqual(ExperimentalData,ExperimentalData_Expected,'RelTol',1e-3,'AbsTol',1e-3);
            
            ExternalForcesComputationResults_Expected = load([path_expectation, '/ExternalForcesComputationResults.mat']);
            ExternalForcesComputationResults = load([path, '/ExternalForcesComputationResults.mat']);
            
            testCase.assertEqual(ExternalForcesComputationResults,ExternalForcesComputationResults_Expected,'RelTol',1e-3,'AbsTol',1e-3);
            
        end
               
        function InverseDynamicTest(testCase)
            
            actualpath = pwd;
            cd ..
            cd ..
            Installation;
            cd(actualpath);
            
            load('AnalysisParameters.mat');
            InverseDynamics(AnalysisParameters);
            
            path_expectation = 'tennis_Expected';
            path =  'tennis';
            
            
            InverseDynamicsResults_Expected = load([path_expectation, '/InverseDynamicsResults.mat']);
            InverseDynamicsResults = load([path, '/InverseDynamicsResults.mat']);
            
            testCase.assertEqual(InverseDynamicsResults,InverseDynamicsResults_Expected,'RelTol',0.01,'AbsTol',0.1);
            
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

