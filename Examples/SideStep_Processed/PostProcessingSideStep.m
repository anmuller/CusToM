% Post Processing "SideStep" example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This example aimed at comparing the consistency of the computed External
% Forces with the Prediction algorithms on cut-off movement of a single 
% subject.
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
Solids = AnalysisParameters.ExternalForces.Options;

% Loading the Biomechanicalmodel file
load('BiomechanicalModel.mat')

% Solid list extracted from the OsteoarticularModel
Solid_list = {BiomechanicalModel.OsteoArticularModel.name}';

% Get the numbers of solids on which the forces are applied
[~,num_s]=intersect(Solid_list,Solids);

% Name of the trial treated
filename='ChgtDirection04';

% Loading external forces computation
load(fullfile(filename,'ExternalForcesComputationResults.mat'))

% Load experimental forces and forces from prediction algorithm.
GRF_Xp=ExternalForcesComputationResults.ExternalForcesExperiments;
GRF_Pred=ExternalForcesComputationResults.ExternalForcesPrediction;

% Number of frames
Nb_frames = numel(GRF_Xp);

% Get the forces applied on the solids
for ii=1:numel(num_s)
    cur_s=num_s(ii); %LFoot and RFoot
    for jj_f=1:Nb_frames
        % Prediction algorithms
        F_Pred.(Solids{ii})(jj_f,:) = GRF_Pred(jj_f).fext(cur_s).fext(:,1)';
        M_Pred.(Solids{ii})(jj_f,:) = GRF_Pred(jj_f).fext(cur_s).fext(:,2);
        % Experimental results
        F_Xp.(Solids{ii})(jj_f,:) = GRF_Xp(jj_f).fext(cur_s).fext(:,1)';
        M_Xp.(Solids{ii})(jj_f,:) = GRF_Xp(jj_f).fext(cur_s).fext(:,2)';
    end
end


%% Plot the result
Directions={'X','Y','Z'};
figure();
for ii=1:3
    subplot(2,3,ii)
    % LFoot
    plot(F_Pred.(Solids{1})(:,ii),'b-','LineWidth',2)
    hold on
    plot(F_Xp.(Solids{1})(:,ii),'b--','LineWidth',2)
    % RFoot
    plot(F_Pred.(Solids{2})(:,ii),'r-','LineWidth',2)
    plot(F_Xp.(Solids{2})(:,ii),'r--','LineWidth',2)
    
    xlim([1 203])
    xlabel('Frames')
    ylabel('Force (N)')
    title(['Force applied on Feets on the ' Directions{ii} '-direction'])
end

for ii=4:6
    subplot(2,3,ii)
    % LFoot
    plot(M_Pred.(Solids{1})(:,ii-3),'b-','LineWidth',2)
    hold on
    plot(M_Xp.(Solids{1})(:,ii-3),'b--','LineWidth',2)
    % RFoot
    plot(M_Pred.(Solids{2})(:,ii-3),'r-','LineWidth',2)
    plot(M_Xp.(Solids{2})(:,ii-3),'r--','LineWidth',2)
    
    xlim([1 203])
    xlabel('Frames')
    ylabel('Moment (Nm)')
    title(['Moment applied on Feets on the ' Directions{ii-3} '-direction'])
end

legend('Predicted on Left Foot','Experimental on Left Foot',...
    'Predicted on Right Foot','Experimental on Right Foot')

% On the graph, we can see that the predicted results are comparable to the
% experimental forces measured. However there is artefact when the foot is
% not on the plateforms. More work is needed on filters and algorithms to
% avoid it.