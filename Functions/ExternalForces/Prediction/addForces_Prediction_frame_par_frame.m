function [external_forces_pred] = addForces_Prediction_frame_par_frame(X,external_forces_pred,Prediction,Fmax,f)
% Addition of the predicted external forces in the variable external_forces
%
%   INPUT
%   - X: results of the optimization problem
%   - external_forces_pred: old external forces applied on the subject
%   - Prediction: contact points for the ground reaction forces
%   - Fmax: maximal forces available for each contact point
%   - f: current frame
%   OUTPUT
%   - external_forces_pred: actualized external forces applied on the subject
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

nb=numel(Prediction);

F_glob=X*Fmax;
F_glob=diag(F_glob);

for pred = 1:nb
    FR0= [F_glob(pred);F_glob(pred+nb);F_glob(pred+2*nb)]; 
    Mp0=cross(Prediction(pred).pos_anim(:),FR0);
    Solid=Prediction(pred).num_solid;
    external_forces_pred(f).fext(Solid).fext=external_forces_pred(f).fext(Solid).fext + [FR0 Mp0];
end

end

