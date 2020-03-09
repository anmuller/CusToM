function [error] = CostFunctionSymbolicCalib(q,k,Human_model,real_markers,f,list_function,list_function_markers,Pelvis_position,Pelvis_rotation,Rcut,pcut)
% Cost function used for the geometrical calibration step
%   
%   INPUT
%   - q: vector of joint coordinates at a given instant
%   - k: vector of homothety coefficient
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure) 
%   - real_markers: 3D position of experimental markers
%   - f: current frame
%   - list_function: list of functions used for the evaluation of the
%   geometrical cuts position 
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

for c=1:max([Human_model.KinematicsCut])
    [Rcut(:,:,c),pcut(:,:,c)]=...
        list_function{c}(Pelvis_position,Pelvis_rotation,q,k,pcut,Rcut);
end

nb_mk=numel(list_function_markers);

e=zeros(nb_mk,1);
for m=1:nb_mk
    e(m,1)= norm(list_function_markers{m}...
        (Pelvis_position,Pelvis_rotation,q,k,...
        pcut,Rcut) - real_markers(m).position(f,:)') ;    
end

W=eye(nb_mk); %Weighted markers each markers are weighted by one
error=e'*W*e;
end