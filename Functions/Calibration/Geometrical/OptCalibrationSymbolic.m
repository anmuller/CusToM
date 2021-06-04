function [error] = OptCalibrationSymbolic(q,k,Human_model,real_markers,nb_frame,list_function,list_function_markers,Pelvis_position,Pelvis_rotation,Rcut,pcut)
% Cost function used for the calibration of the geometrical parameters
%   It corresponds to the sum of reconstruction error for a set of frames 
%   
%   INPUT
%   - q: vector of joint coordinates at a given instant
%   - k: vector of homothety coefficient
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure) 
%   - real_markers: 3D position of experimental markers
%   - nb_frame: number of frames
%   - list_function: list of functions used for the evaluation of the geometrical cuts position
%   - list_function_markers: list of functions used for the evaluation of the
%   markers position 
%   - Pelvis_position: position of the pelvis at the considered instant
%   - Pelvis_rotation: rotation of the pelvis at the considered instant
%   - Rcut: pre-initialization of Rcut
%   - pcut: pre-initialization of pcut
%   OUTPUT
%   - error: cost function value
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

    error=0;
    for f=1:nb_frame    % somme des erreurs pour chacune des frames sélectionnées (sum of reconstruction error for a set of selected frames)
        error = error + CostFunctionSymbolicCalib(q(:,f),k,Human_model,real_markers,f,list_function,list_function_markers,Pelvis_position{f},Pelvis_rotation{f},Rcut,pcut);   
    end
end