function [] = JointPositions(AnalysisParameters)

for num_f = 1:numel(AnalysisParameters.filename) % for each file

    %% Loading data
    filename = AnalysisParameters.filename{num_f}(1:end-(numel(AnalysisParameters.General.Extension)-1));
    load('BiomechanicalModel.mat'); %#ok<LOAD>
    Human_model = BiomechanicalModel.OsteoArticularModel;
    load([filename '/InverseKinematicsResults.mat']); %#ok<LOAD>
    q = InverseKinematicsResults.JointCoordinates';
    if isfield(InverseKinematicsResults,'FreeJointCoordinates')
        q6dof = InverseKinematicsResults.FreeJointCoordinates';
    else
        PelvisPosition = InverseKinematicsResults.PelvisPosition;
        PelvisOrientation = InverseKinematicsResults.PelvisOrientation;
    end
    nbframe = size(q,1);

    %% Get rid of the 6DOF joint
    if isfield(InverseKinematicsResults,'FreeJointCoordinates')
        Human_model(Human_model(end).child).mother = 0;
        Human_model = Human_model(1:(numel(Human_model)-6));
    end

    %% Pelvis position
    if isfield(InverseKinematicsResults,'FreeJointCoordinates')
        p_pelvis = q6dof(:,1:3);  % frame i : p_pelvis(i,:)
        r_pelvis = cell(size(q6dof,1),1);
        for i = 1:size(q6dof,1)
            r_pelvis{i} = Rodrigues([1 0 0]',q6dof(i,4))*Rodrigues([0 1 0]',q6dof(i,5))*Rodrigues([0 0 1]',q6dof(i,6)); % matrice de rotation en fonction des rotations successives (x,y,z) : frame i : r_pelvis{i}
        end
    else
        p_pelvis = cell2mat(PelvisPosition)';
        r_pelvis  = PelvisOrientation';
    end

    %% Computation
    JointPositions = cell(numel(Human_model),1);
    JointOrientations = cell(numel(Human_model),nbframe);
    for i=1:nbframe
        Human_model(1).p = p_pelvis(i,:)';
        Human_model(1).R = r_pelvis{i};
        for j=2:numel(Human_model)
            Human_model(j).q = q(i,j);
        end
        Human_model = ForwardKinematics(Human_model,1);
        for j = 1:numel(Human_model)
            JointPositions{j}(:,i) = Human_model(j).p;
            JointOrientations{j,i} = Human_model(j).R;
        end
    end
    
    %% Saving data
    InverseKinematicsResults.JointPositions = JointPositions;
    InverseKinematicsResults.JointOrientations = JointOrientations;
    save([filename '/InverseKinematicsResults.mat'], 'InverseKinematicsResults');
    
end

end