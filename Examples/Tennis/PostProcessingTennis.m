% Post Processing "SideStep" example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This example aimed at observing weight transfer during tennis serve using
% only magnetic and inertial measurement units (MIMU). The motion capture
% was performed directly on a tennis court
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%_______________________________________________________

% Loading the Analysis file
load('AnalysisParameters.mat')

% Get the solid names on which the forces are applied
Solids = {'RightFoot','RightToe','LeftFoot','LeftToe'};

% Loading the Biomechanicalmodel file
load('BiomechanicalModel.mat')

% Solid list extracted from the OsteoarticularModel
Solid_list = {BiomechanicalModel.OsteoArticularModel.name}';

% Get the numbers of solids on which the forces are applied
[~,num_s,num_so] = intersect(Solid_list,Solids);
[~,so] = sort(num_so); num_s = num_s(so);

% Name of the trial treated
filename = 'tennis_frames_3328-4207';

% Loading external forces computation
load(fullfile(filename,'ExternalForcesComputationResults.mat'))

% Loading the time vector
load(fullfile(filename,'ExperimentalData.mat'))

% Load predicted ground reaction forces
GRF = ExternalForcesComputationResults.ExternalForcesPrediction;

% Number of frames
Nb_frames = numel(GRF);

% Get the forces applied on the solids
for jj_f = 1:Nb_frames
    F.RightFoot(jj_f,:) = GRF(jj_f).fext(num_s(1)).fext(:,1) + ...
        GRF(jj_f).fext(num_s(2)).fext(:,1);
    F.LeftFoot(jj_f,:) = GRF(jj_f).fext(num_s(3)).fext(:,1) + ...
        GRF(jj_f).fext(num_s(4)).fext(:,1);
end

%% Plot the result
figure
plot(ExperimentalData.Time,F.RightFoot(:,3),'b','LineWidth',2)
hold on
plot(ExperimentalData.Time,F.LeftFoot(:,3),'r','LineWidth',2)
xlim([0 max(ExperimentalData.Time)])
xlabel('Time (s)')
ylabel('Force (N)')
title('Vertical force applied on feet')
legend({'Right foot','Left foot'})
