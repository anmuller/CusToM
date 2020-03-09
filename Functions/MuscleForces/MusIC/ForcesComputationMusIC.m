function [MuscleForcesComputationResults] = ForcesComputationMusIC(filename, BiomechanicalModel, AnalysisParameters)
% Computation of the muscle forces estimation step by using the MusIC method
%
%	Associated publications :
%	- Muller, A., Pontonnier, C., & Dumont, G., 2018.
%	 The MusIC method: a fast and quasi-optimal solution to the muscle forces estimation problem. Computer methods in biomechanics and biomedical engineering, 21(2), 149-160.
%	- Muller, A., Demore, F., Pontonnier, C., & Dumont, G., 2017. 
%	MusIC makes the muscles work together. In XVI International Symposium on Computer Simulation in Biomechanics (p. 2).
%
%   INPUT
%   - filename: name of the file to process (character string)
%   - BiomechanicalModel: musculoskeletal model
%   OUTPUT
%   - MuscleForcesComputationResults: results of the muscle forces
%   estimation step (see the Documentation for the structure) 
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

if ~isfield(BiomechanicalModel,['MusICDatabase_' char(AnalysisParameters.Muscles.Costfunction) num2str(AnalysisParameters.Muscles.CostfunctionOptions) '_' num2str(AnalysisParameters.Muscles.DatabaseDensity(1)) '_' num2str(AnalysisParameters.Muscles.DatabaseDensity(2))])
    disp('MusIC Database Generation ...')
    eval(['[BiomechanicalModel.MusICDatabase_' char(AnalysisParameters.Muscles.Costfunction) num2str(AnalysisParameters.Muscles.CostfunctionOptions) '_' num2str(AnalysisParameters.Muscles.DatabaseDensity(1)) '_' num2str(AnalysisParameters.Muscles.DatabaseDensity(2)) '] = MusICDatabaseGeneration(BiomechanicalModel, AnalysisParameters);']) 
    disp('... MusIC Database Generation done')
    save('BiomechanicalModel','BiomechanicalModel');
end

disp(['Forces Computation (' filename ') ...'])

%% Loading variables
Moment_Arms = BiomechanicalModel.MomentArms;
Muscles = BiomechanicalModel.Muscles;
C = BiomechanicalModel.MuscularCoupling;
Database = eval(['BiomechanicalModel.MusICDatabase_' char(AnalysisParameters.Muscles.Costfunction) num2str(AnalysisParameters.Muscles.CostfunctionOptions) '_' num2str(AnalysisParameters.Muscles.DatabaseDensity(1)) '_' num2str(AnalysisParameters.Muscles.DatabaseDensity(2))]);
load([filename '/InverseKinematicsResults']) %#ok<LOAD>
load([filename '/InverseDynamicsResults']) %#ok<LOAD>

if isfield(BiomechanicalModel,'Generalized_Coordinates')
q_map_unsix = BiomechanicalModel.Generalized_Coordinates.q_map_unsix;
q = q_map_unsix'*[InverseKinematicsResults.FreeJointCoordinates(end,:);...
    InverseKinematicsResults.JointCoordinates(2:end,:);
    InverseKinematicsResults.JointCoordinates(1,:);
    InverseKinematicsResults.FreeJointCoordinates(1:end-1,:)];

torques = q_map_unsix'*[InverseDynamicsResults.DynamicResiduals.t6dof(end,:);...
    InverseDynamicsResults.JointTorques(2:end,:);
    InverseDynamicsResults.JointTorques(1,:);
    InverseDynamicsResults.DynamicResiduals.f6dof;
    InverseDynamicsResults.DynamicResiduals.t6dof(1:end-1,:)];
else
  q=InverseKinematicsResults.JointCoordinates;  
  torques=InverseDynamicsResults.JointTorques;
end

%%  Detection of joint concerned by the muscle
n=0;
for i=1:size(Moment_Arms,1)
    for j=1:size(Moment_Arms,2)
        if ~isnumeric(Moment_Arms{i,j})
           n=n+1;
           art_muscles(n)=i; %#ok<AGROW>
           break
        end
    end
end

%% Preliminary computation

% list to interpolate
for i=1:numel(art_muscles)
    k=0;
    for j=1:numel(art_muscles)
        if C(art_muscles(i),art_muscles(j))
            k=k+1;
            listX(i).X{k,1} = Database(i).Q{art_muscles(j),1}; %#ok<AGROW>
        end
    end
end

% Muscle_art
Muscle_art=cell(size(Moment_Arms,2),1);
for i=1:size(Moment_Arms,1)
    for j=1:size(Moment_Arms,2)
        if ~isnumeric(Moment_Arms{i,j})
            Muscle_art{j,1}=[Muscle_art{j,1} find(art_muscles==i)];
        end
    end
end

% FMusIC
NbMuscles = numel(Muscles);
nb_frame=size(q,2);
FMusIC=zeros(NbMuscles,nb_frame);
AMusIC=zeros(size(FMusIC));

%% Computation of muscle forces

h = waitbar(0,['Forces Computation (' filename ')']);

% initial coefficient to weight the bi-objective optimization 
epsilon_init = 1e-3; epsilon = epsilon_init;
epsilon_factor = 10; % multiplication factor for epsilon variation

tic
for i=1:nb_frame
%     i
    %% Computation of muscle moment arms
    M = zeros(numel(art_muscles),numel(Muscles));
    c=0;
    for m=art_muscles
        c=c+1;
        for j=1:numel(Muscles)
            if isnumeric(Moment_Arms{m,j})
                M(c,j)=0;
            else
                M(c,j) = Moment_Arms{m,j}(q(:,i));
            end
        end
    end
    %% Fmax
    Fmax=[Muscles.f0]';
    %% Interpolation
    % Finding in the database the closest available values
    AlphaDatabase = zeros(numel(Muscles),numel(art_muscles));
    TorquesDatabase = zeros(numel(art_muscles),1);
    for j = 1:numel(art_muscles) % for each joint
        if torques(art_muscles(j),i) > 0 % positive torque
            InterResults = InterpnVector(listX(j).X,Database(j).RatioPos,q(Database(j).list_coupling,i));
        else
            InterResults = InterpnVector(listX(j).X,Database(j).RatioNeg,q(Database(j).list_coupling,i));
        end
        AlphaDatabase(Database(j).art_mus,j) = InterResults(1:(end-1));
        TorquesDatabase(j,:) = InterResults(end);
    end
	% Weight of each joint in the barycentric interpolation
    Beta = torques(art_muscles,i)./TorquesDatabase;
	% Associated forces for each joint are computated
    Finter = zeros(size(AlphaDatabase));
    for j=1:numel(art_muscles)
        asum=(Beta(j)*TorquesDatabase(j,:))/(sum(M(j,:)'.*Fmax.*AlphaDatabase(:,j)));
        Finter(:,j) = AlphaDatabase(:,j).*Fmax.*asum;
    end
    Finter = max(min(Fmax,Finter),0);
   
    %% Correction
    % Barycentric interpolation
	% Unique vector array of muscle forces computation
    Fsingle = zeros(size(Finter,1),1);
    for j=1:numel(Fsingle)
        Fsingle(j,1) = sum(Finter(j,Muscle_art{j,1})'.*abs(torques(art_muscles(Muscle_art{j,1}),i)))/sum(abs(torques(art_muscles(Muscle_art{j,1}),i)));
    end
    Fsingle = max(min(Fmax,Fsingle),0);
    
    %% Minimization
    test_stop = 0; % indicator to stop loops 
    pos_active_set = [];
    pos_passive_set = [1:numel(Fsingle)]'; %#ok<NBRAK>
    iter=0;
    epsilon = max(epsilon_init,epsilon/epsilon_factor);
    while ~test_stop
        iter=iter+1;
        if iter > NbMuscles
            epsilon = epsilon*epsilon_factor; iter = 0;
        end
        % minimization
        [Fkp1,mu] = KKT_projection(Fsingle,Fmax,M,torques(art_muscles,i),pos_active_set,pos_passive_set,epsilon);
        test_max = max(max(-Fkp1,Fkp1-Fmax(pos_passive_set))); % on regarde la différence avec les limites
        if test_max > 0 % Conditions are not satisfied
            if test_max == max(-Fkp1) % maximum limit with 0
                pos_act = find(max(-Fkp1)==-Fkp1,1); % contraints number to enable in the pos_passive_set list
                pos_active_set = [pos_active_set;pos_passive_set(pos_act) 0];  %#ok<AGROW> % this ligne is added to active constraints
            else % max limit with Fmax
                pos_act = find(max(Fkp1-Fmax(pos_passive_set))==Fkp1-Fmax(pos_passive_set),1);
                pos_active_set = [pos_active_set;pos_passive_set(pos_act) 1];  %#ok<AGROW> % this ligne is added to active constraints
            end
            pos_passive_set=[pos_passive_set(1:pos_act-1);pos_passive_set(pos_act+1:end)]; % this ligne is added to passive constraints
        elseif numel(mu) && any(mu<0) %we can free an active contraint
                pos_pas = find(max(-mu)==-mu,1);
                pos_passive_set = [pos_passive_set;pos_active_set(pos_pas,1)]; %#ok<AGROW>
                pos_active_set = [pos_active_set(1:pos_pas-1,:);pos_active_set(pos_pas+1:end,:)]; % this ligne is removed from active constraints
        else
                test_stop = 1; % STOP
        end
%         pos_active_set
    end
    FMusIC(pos_passive_set,i) = Fkp1;
    if numel(pos_active_set)
        FMusIC(pos_active_set(:,1),i) = Fmax(pos_active_set(:,1)).*pos_active_set(:,2);
    end
    
    %% Computation of muscle activation
    AMusIC(:,i) = FMusIC(:,i)./Fmax;
    
    waitbar(i/nb_frame)
end
close(h)
% w=toc;

MuscleForcesComputationResults.MuscleActivations = AMusIC;
MuscleForcesComputationResults.MuscleForces = FMusIC;

disp(['... Forces Computation (' filename ') done'])

end


