function [NbPointsPrediction,nb_ms,fmk,C_mk,C_ms,C_pt_p,num_s_mass_center,color0,color1,Prediction,Aopt,external_forces,color_vect_force,external_forces_pred,color_vect_force_p,lmax_vector_visual,coef_f_visual,ForceplatesData]=ColorsAnimation(filename,Muscles,AnimateParameters,Human_model,ModelParameters,AnalysisParameters,external_forces_anim,forceplate,mass_centers_anim, mod_marker_anim ,exp_marker_anim,Markers_set,Force_Prediction_points,muscles_anim,external_forces_p)



fmk=[];
C_mk=[];
C_ms=[];
C_pt_p=[];
color0=[];
color1=[];
Prediction=[];
Aopt=[];
external_forces=[];
color_vect_force=[];
external_forces_pred=[];
color_vect_force_p=[];
lmax_vector_visual=[];
coef_f_visual=[];
ForceplatesData=[];
num_s_mass_center=[];
nb_ms=[];
NbPointsPrediction=[];

if mod_marker_anim || exp_marker_anim || mass_centers_anim
    if mod_marker_anim || exp_marker_anim
        nb_set= mod_marker_anim + exp_marker_anim;
        % Creating a mesh with all the marker to do only one gpatch
        nbmk=numel(Markers_set);
        fmk=1:1:nbmk*nb_set;
        C_mk = zeros(nbmk*nb_set,3); % RGB;
        if mod_marker_anim && ~exp_marker_anim
            C_mk(1:nbmk,:)=repmat([255 102 0]/255,[nbmk 1]);
        elseif ~mod_marker_anim && exp_marker_anim
            C_mk(1:nbmk,:)=repmat([0 153 255]/255,[nbmk 1]);
        elseif mod_marker_anim && exp_marker_anim
            C_mk(1:nbmk,:)=repmat([255 102 0]/255,[nbmk 1]);
            C_mk(nbmk+1:nbmk*nb_set,:)=repmat([0 153 255]/255,[nbmk 1]);
        end
    end
    if mass_centers_anim
        num_s_mass_center=find([Human_model.Visual]);
        nb_ms = length(num_s_mass_center);
        C_ms(1:nb_ms,:)=repmat([34,139,34]/255,[nb_ms 1]);
    end
end




if Force_Prediction_points
    %% Creation of a structure to add contact points
    for i=1:numel(AnalysisParameters.Prediction.ContactPoint)
        Prediction(i).points_prediction_efforts = AnalysisParameters.Prediction.ContactPoint{i}; %#ok<AGROW>
    end
    Prediction=verif_Prediction_Humanmodel(Human_model,Prediction);
    NbPointsPrediction = numel(Prediction);
    C_pt_p(1:NbPointsPrediction,:)=repmat([100,139,34]/255,[NbPointsPrediction 1]);
end

if muscles_anim
    color0 = [0.9 0.9 0.9];
    color1 = [1 0 0];
    if isfield(AnimateParameters,'Mode') && isequal(AnimateParameters.Mode, 'GenerateParameters')
        Aopt = ones(numel(Muscles),1);
    else
        load([filename '/MuscleForcesComputationResults.mat']); %#ok<LOAD>
        Aopt = MuscleForcesComputationResults.MuscleActivations;
    end
end


%% External forces

if external_forces_anim
    load([filename '/ExternalForcesComputationResults.mat']); %#ok<LOAD>
    if ~isfield(ExternalForcesComputationResults,'ExternalForcesExperiments')
        error('External Forces from the Experiments have not been computed on this trial')
    end
    external_forces = ExternalForcesComputationResults.ExternalForcesExperiments;
    color_vect_force = [53 210 55]/255;
end


if external_forces_p
    color_vect_force_p = 1-([53 210 55]/255);
    load([filename '/ExternalForcesComputationResults.mat']); %#ok<LOAD>
    if ~isfield(ExternalForcesComputationResults,'ExternalForcesPrediction')
        error('ExternalForcesPrediction have not been computed on this trial')
    end
    external_forces_pred = ExternalForcesComputationResults.ExternalForcesPrediction;
end


if external_forces_anim || external_forces_p  %vector normalization
    lmax_vector_visual = 1; % longueur max du vecteur (en m)
    coef_f_visual=(ModelParameters.Mass*9.81)/lmax_vector_visual;
end


if forceplate
    if isequal(AnalysisParameters.ExternalForces.Method, @DataInC3D)
        h = btkReadAcquisition([filename '.c3d']);
        ForceplatesData = btkGetForcePlatforms(h);
    elseif isequal(AnalysisParameters.ExternalForces.Method, @PF_IRSST)
        load([filename '.mat']); %#ok<LOAD>
    end
end



end