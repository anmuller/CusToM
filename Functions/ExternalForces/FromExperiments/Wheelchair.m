function [ExternalForcesComputationResults] = Wheelchair(filename, BiomechanicalModel, AnalysisParameters)
% Computation of the external forces for a cycling application
%
%   INPUT
%   - filename: name of the file to process (character string)
%   - BiomechanicalModel: musculoskeletal model
%   - AnalysisParameters: parameters of the musculoskeletal analysis,
%   automatically generated by the graphic interface 'Analysis' 
%   OUTPUT
%   - ExternalForcesComputationResults: results of the external forces
%   computation (see the Documentation for the structure) 
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

Human_model = BiomechanicalModel.OsteoArticularModel;
load([filename '/ExperimentalData.mat']); %#ok<LOAD>
time = ExperimentalData.Time;
real_markers = ExperimentalData.MarkerPositions;
nbframe=numel(time);
f_mocap=1/time(2);

% Initialisation
for f=1:nbframe
    for n=1:numel(Human_model)
        external_forces(f).fext(n).fext=zeros(3,2); %#ok<AGROW,*SAGROW>
    end
end

% Handrim forces
load([filename '.mat']); %#ok<LOAD>
Right_Handrim = FRET.MechAct.RD;
Left_Handrim = FRET.MechAct.RG;
f_wheelchair = FRET.Frequence;
Right_Handrim = resample(Right_Handrim,f_mocap,f_wheelchair);
Left_Handrim = resample(Left_Handrim,f_mocap,f_wheelchair);

% Filtrage des donn�es (data filtering)
if AnalysisParameters.ExternalForces.FilterActive
    for i=1:numel(Right_Handrim)
        Right_Handrim(i)=filt_data(Right_Handrim(i),AnalysisParameters.ExternalForces.FilterCutOff,f_mocap);
    end
    for i=1:numel(Left_Handrim)
        Left_Handrim(i)=filt_data(Left_Handrim(i),AnalysisParameters.ExternalForces.FilterCutOff,f_mocap);
    end
end

% Wheelchair frame
list_markers_wheelchair={'FRMA';'FRMRG';'FRMRD';'FRMAVG';'FRMAVD'};
for i=1:numel(list_markers_wheelchair) % finding number of marker
    for j=1:numel(real_markers)
        if strcmp(list_markers_wheelchair{i},real_markers(j).name)
            list_markers_wheelchair{i,2}=j;
        end
    end
end

%% Handrim forces are added in variable external_forces
% Wheelchair frame computation based on marker position
A           = cell{nb_frame,1};
pWheelchair = cell{nb_frame,1};
xWheelchair = cell{nb_frame,1};
yWheelchair = cell{nb_frame,1};
zWheelchair = cell{nb_frame,1};
RWheelchair = cell{nb_frame,1};
for i=1:nbframe
    % Center of wheelchair frame (midpoint between right and left wheel)
    A{i}            =(real_markers(list_markers_wheelchair{2,2}).position(i,:)+real_markers(list_markers_wheelchair{3,2}).position(i,:))/2;
    pWheelchair{i}  =A{i}';
    % Wheelchair frame z-axis
    zWheelchair_i   =(real_markers(list_markers_wheelchair{3,2}).position(i,:)-real_markers(list_markers_wheelchair{2,2}).position(i,:));
    zWheelchair{i}  =zWheelchair_i/norm(zWheelchair_i);
    yWheelchair{i}  =[0 0 1];
    xWheelchair{i}  =cross(zWheelchair{i},yWheelchair{i});
    zWheelchair{i}   =cross(xWheelchair{i},yWheelchair{i});
    RWheelchair{i}  =[xWheelchair{i}' yWheelchair{i}' zWheelchair{i}'];
end

% Right Handrim forces
Solid_name='RHand';  
Solid=find(strcmp({Human_model.name},Solid_name));
[external_forces] = addPlatformForces(external_forces, Solid, pWheelchair, RWheelchair, -[Right_Handrim],COP);

% Left Handrim forces
Solid_name='LHand';  
Solid=find(strcmp({Human_model.name},Solid_name));
[external_forces] = addPlatformForces(external_forces, Solid, pWheelchair, RWheelchair, -[Left_Handrim(1:6)], COP);
% Sauvegarde des donn�es
if exist([filename '/ExternalForcesComputationResults.mat'],'file')
    load([filename '/ExternalForcesComputationResults.mat']);
end
ExternalForcesComputationResults.ExternalForcesExperiments = external_forces;

end