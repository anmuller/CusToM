classdef SolverTestCycling < matlab.unittest.TestCase
    methods(Test)
        function InverseKinematicsTest(testCase)
            
            actualpath = pwd;
            cd ..
            cd ..
            Installation;
            cd(actualpath);
            
            load('AnalysisParameters.mat');
            InverseKinematics(AnalysisParameters);
            
            path_expectation = 'JOTH_Fin_125HzModif_Expected';
            path =  'JOTH_Fin_125HzModif';
            
            
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
            
            path_expectation = 'JOTH_Fin_125HzModif_Expected';
            path =  'JOTH_Fin_125HzModif';
            
            
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
            
            path_expectation = 'JOTH_Fin_125HzModif_Expected';
            path =  'JOTH_Fin_125HzModif';
            
            
            InverseDynamicsResults_Expected = load([path_expectation, '/InverseDynamicsResults.mat']);
            InverseDynamicsResults = load([path, '/InverseDynamicsResults.mat']);
            
            testCase.assertEqual(InverseDynamicsResults,InverseDynamicsResults_Expected,'RelTol',0.01,'AbsTol',0.1);
            
        end
        
        
        
        function MuscleComputationTest(testCase)
            
            actualpath = pwd;
            cd ..
            cd ..
            Installation;
            cd(actualpath);
            
            
            load('AnalysisParameters.mat');
            MuscleForcesComputationNum(AnalysisParameters);
            
            path_expectation = 'JOTH_Fin_125HzModif_Expected';
            path =  'JOTH_Fin_125HzModif';
            
            MuscleForcesComputationResults_Expected = load([path_expectation, '/MuscleForcesComputationResults.mat']);
            MuscleForcesComputationResults = load([path, '/MuscleForcesComputationResults.mat']);
            
            MuscleForcesComputationResults=MuscleForcesComputationResults.MuscleForcesComputationResults;
            MuscleForcesComputationResults_Expected = MuscleForcesComputationResults_Expected.MuscleForcesComputationResults;
            
            testCase.assertEqual(MuscleForcesComputationResults.MuscleActivations,MuscleForcesComputationResults_Expected.MuscleActivations,'RelTol',1e-2,'AbsTol',1e-2);
            testCase.assertEqual(MuscleForcesComputationResults.MuscleForces,MuscleForcesComputationResults_Expected.MuscleForces,'RelTol',0.05,'AbsTol',1);
            testCase.assertEqual(MuscleForcesComputationResults.MuscleLengths,MuscleForcesComputationResults_Expected.MuscleLengths,'RelTol',0.01,'AbsTol',1e-3);
            testCase.assertEqual(MuscleForcesComputationResults.MuscleLeverArm,MuscleForcesComputationResults_Expected.MuscleLeverArm,'RelTol',0.01,'AbsTol',1e-3);
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

