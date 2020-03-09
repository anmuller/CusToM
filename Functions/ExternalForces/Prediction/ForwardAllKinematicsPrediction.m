function [Human_model,Prediction] = ForwardAllKinematicsPrediction(Human_model,Prediction,j)
% Computation of spacial position, velocity and acceleration for each solid used for the prediction of ground reaction forces
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure) 
%   - Prediction: contact points for the ground reaction forces
%   - j: current solid
%   OUTPUT
%   - Human_model: osteo-articular model with additional computations (see
%   the Documentation for the structure)  
%   - Prediction: contact points for the ground reaction forces with
%   additional computations
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

if j==0
    return;
end

%%
if j~=1
    i=Human_model(j).mother;
    %% Position et Orientation
    Human_model(j).p=Human_model(i).R*Human_model(j).b+Human_model(i).p;
    Human_model(j).R=Human_model(i).R*Rodrigues(Human_model(j).a,Human_model(j).q)*Rodrigues(Human_model(j).u,Human_model(j).theta);
    %% Vitesse spatiale
    sw=Human_model(i).R*Human_model(j).a;
    sv=cross(Human_model(j).p,sw);
    Human_model(j).w=Human_model(i).w+sw*Human_model(j).dq;
    Human_model(j).v0=Human_model(i).v0+sv*Human_model(j).dq;
    %% Accélération spatiale
    dsv=cross(Human_model(i).w,sv)+cross(Human_model(i).v0,sw);
    dsw=cross(Human_model(i).w,sw);
    Human_model(j).dw=Human_model(i).dw+dsw*Human_model(j).dq+sw*Human_model(j).ddq;
    Human_model(j).dv0=Human_model(i).dv0+dsv*Human_model(j).dq+sv*Human_model(j).ddq;
    Human_model(j).sw=sw;
    Human_model(j).sv=sv;
end
    %% Position et vitesse des points de contact avec l'extérieur
    for m=1:numel(Prediction)
        if Prediction(m).exist && Prediction(m).num_solid == j
            Prediction(m).pos_anim = (Human_model(j).R * (Human_model(j).c + Human_model(j).anat_position{Prediction(m).num_markers,2}) + Human_model(j).p);
            Prediction(m).vitesse = Human_model(j).v0 + cross(Human_model(j).w,Prediction(m).pos_anim); % calcul de la vitesse
        end
    end
% end

[Human_model,Prediction]=ForwardAllKinematicsPrediction(Human_model,Prediction,Human_model(j).sister);
[Human_model,Prediction]=ForwardAllKinematicsPrediction(Human_model,Prediction,Human_model(j).child);

end

