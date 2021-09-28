function [error] = OptCalibrationSymbolic(q,k,nb_frame,Pelvis_position,Pelvis_rotation,real_markers)
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
positions=zeros(3,length(real_markers));
for f=1:nb_frame    % somme des erreurs pour chacune des frames s�lectionn�es (sum of reconstruction error for a set of selected frames)
    for m=1:length(real_markers)
        positions(:,m) = real_markers(m).position(f,:)';
    end
    error = error + CostFunctionSymbolicCalib(q(:,f),k,Pelvis_position{f},Pelvis_rotation{f},positions(:));
end
end