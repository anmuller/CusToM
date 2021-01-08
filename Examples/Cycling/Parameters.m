function [ModelParameters,AnalysisParameters]=Parameters

%% ModelParameters
ModelParameters=struct();

ModelParameters.Size=1.70; 
ModelParameters.Mass=70; 

ModelParameters.PelvisLowerTrunk=@PelvisLowerTrunk;
ModelParameters.UpperTrunk=@UpperTrunkClavicle;
ModelParameters.Head=@Skull;
ModelParameters.LeftLeg=@Leg;
ModelParameters.RightLeg=@Leg;
ModelParameters.LeftArm=@Arm_model_Pennestri;
ModelParameters.RightArm=@Arm_model_Pennestri;

ModelParameters.Root='PelvisSacrum';

ModelParameters.Markers=@Marker_set2;
ModelParameters.MarkersOptions=1;
ModelParameters.MarkersRemoved={};

ModelParameters.Muscles={@ArmMusclesPennestri, @ArmMusclesPennestri};
ModelParameters.MusclesOptions={'Right','Left'};

%% AnalysisParameters
AnalysisParameters=struct();
AnalysisParameters.General.FilterActive=1;
AnalysisParameters.General.FilterCutOff=10;
AnalysisParameters.General.InputData=@C3dProcessedData;
AnalysisParameters.General.InputDataOptions={};
AnalysisParameters.General.Extension='*.c3d';

AnalysisParameters.CalibIK.filename='';
AnalysisParameters.CalibIK.Active=0;
AnalysisParameters.CalibIK.Frames.Method=@UniformlyDistributed;
AnalysisParameters.CalibIK.Frames.NbFrames=30;
AnalysisParameters.CalibIK.LengthAdd={};
AnalysisParameters.CalibIK.LengthDelete={};
AnalysisParameters.CalibIK.AxisAdd={};
AnalysisParameters.CalibIK.AxisDelete={};
AnalysisParameters.CalibIK.MarkersCalibModif={};

AnalysisParameters.filename='';
AnalysisParameters.IK.Active=0;
AnalysisParameters.IK.Method=2; % LM
AnalysisParameters.IK.FilterActive=1;
AnalysisParameters.IK.FilterCutOff=5;

AnalysisParameters.CalibID.Active=0;

AnalysisParameters.ID.Active=0;

%% MUSCLE FORCES
AnalysisParameters.Muscles.Active=0;
AnalysisParameters.Muscles.Method=1;
AnalysisParameters.Muscles.Costfunction=@PolynomialFunction;
AnalysisParameters.Muscles.CostfunctionOptions=2;
AnalysisParameters.Muscles.MuscleModel=@SimpleMuscleModel;

AnalysisParameters.CalibMuscles=0;

end
