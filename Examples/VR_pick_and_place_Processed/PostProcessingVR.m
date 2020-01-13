% Post Processing "VR" example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This example aimed at getting the joint angles of the elbow and the shoulder
% from inverse kinematics
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%_______________________________________________________

% Loading the Biomechanicalmodel file
load('BiomechanicalModel.mat')

% Solid list extracted from the OsteoarticularModel
Solid_list = {BiomechanicalModel.OsteoArticularModel.name}';

% Get the numbers of solids of interests
Solids = {'RShoulder_J1';'RShoulder_J2';'RHumerus';'RElbow_J1';'RForearm'};
[~,num_s]=intersect(Solid_list,Solids,'stable');

%RShoulder_J1 rotates around Y-axis
BiomechanicalModel.OsteoArticularModel(num_s(1)).a;
%RShoulder_J2 rotates around X-axis
BiomechanicalModel.OsteoArticularModel(num_s(2)).a;
%RHumerus rotates around Y-axis
BiomechanicalModel.OsteoArticularModel(num_s(3)).a;
% Rotation Y-X-Y sequence of the Shoulder following ISB recommandation

%RElbow_J1 rotates around Z-axis Flexion/Extension
BiomechanicalModel.OsteoArticularModel(num_s(4)).a;
%RForearm rotates around Y-axis Int/Ext Rotation
BiomechanicalModel.OsteoArticularModel(num_s(5)).a;
%Folowing ISB recommandation

% Name of the trial treated
filename='Record_12';

% Loading Inverse Kinematic results
load(fullfile(filename,'InverseKinematicsResults.mat'))

%% Reconstruction Error

% Computing the mean reconstruction error over the trial for each frames
RE_mean = mean(InverseKinematicsResults.ReconstructionError,1);

figure;
plot(RE_mean,'b-','LineWidth',2);
xlabel('Frames');
ylabel('Mean Reconstruction Error (m)');
title('Mean reconstruction error over the trial for each frames')

% Computing the global mean reconstruction error for the total amount of
% frames
% disp('Global Mean Reconstruction Error (in m)')
RE_global_mean = mean(mean(InverseKinematicsResults.ReconstructionError,1));


%% Joint Angles

% Number of frames
Nb_frames = size(InverseKinematicsResults.JointCoordinates,2);

% Get the angles of interest
q=InverseKinematicsResults.JointCoordinates(num_s,:)*180/pi ; % from radian to degrees

figure;

subplot(2,3,1)
plot(q(1,:),'b-','LineWidth',2);% in degrees
xlabel('Frames')
ylabel('Angle (°)')
title([ Solids{1} ' First Y-axis Shoulder rotation'])
xlim([0 Nb_frames])

subplot(2,3,2)
plot(q(2,:),'b-','LineWidth',2);% in degrees
xlabel('Frames')
ylabel('Angle (°)')
title([ Solids{2} ' Second X-axis Shoulder rotation'])
xlim([0 Nb_frames])

subplot(2,3,3)
plot(q(3,:),'b-','LineWidth',2);% in degrees
xlabel('Frames')
ylabel('Angle (°)')
title([ Solids{3} ' Third Y-axis Shoulder rotation'])
xlim([0 Nb_frames])

subplot(2,3,4)
plot(q(4,:),'b-','LineWidth',2);% in degrees
xlabel('Frames')
ylabel('Angle (°)')
title([ Solids{4} ' First Z-axis rotation - Elbow Flexion/Extension'])
xlim([0 Nb_frames])

subplot(2,3,5)
plot(q(5,:),'b-','LineWidth',2);% in degrees
xlabel('Frames')
ylabel('Angle (°)')
title([ Solids{5} ' Second Y-axis rotation - Elbow Int/Ext Rotation'])
xlim([0 Nb_frames])


% On the graph, we can see the angles from inverse kinematics for the 
% selected angles of the shoulder and the elbow. A 4th order zerolag
% butterworth filter was applied on these angles with a cutoff frequency of
% 5 Hz as it is specify in the Analysis parameters.