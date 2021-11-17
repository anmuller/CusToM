function [error] = OptCalibrationSymbolic(q,k,nb_frame,Pelvis_position,Pelvis_rotation,real_markers,list_function,Rcut,pcut,nbcut,list_function_markers,weights)
% Cost function used for the calibration of the geometrical parameters
%   It corresponds to the sum of reconstruction error for a set of frames
%
%   INPUT
%   - q: vector of joint coordinates at a given instant
%   - k: vector of homothety coefficient
%   - nb_frame: number of frames
%   - Pelvis_position: position of the pelvis at the considered instant
%   - Pelvis_rotation: rotation of the pelvis at the considered instant
%   - real_markers: 3D position of experimental markers
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
% somme des erreurs pour chacune des frames s�lectionn�es (sum of reconstruction error for a set of selected frames)
for f=1:nb_frame  
    
    error = error + CostFunctionSymbolicCalib(q(:,f),k,Pelvis_position{f},Pelvis_rotation{f},list_function,Rcut,pcut,real_markers,nbcut,list_function_markers,f,weights);

end
end