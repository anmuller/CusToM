function [error] = CostFunctionSymbolicCalib(q,k,Pelvis_position,Pelvis_rotation,list_function,Rcut,pcut,real_markers,nbcut,list_function_markers,f)
% Cost function used for the geometrical calibration step
%   
%   INPUT
%   - q: vector of joint coordinates at a given instant
%   - k: vector of homothety coefficient
%   - Pelvis_position: position of the pelvis at the considered instant
%   - Pelvis_rotation: rotation of the pelvis at the considered instant
%   - positions : matrix of experimental marker positions
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

for c=1:nbcut
            if c==1          
        [Rcut(:,:,c),pcut(:,:,c)]=list_function{c}(Pelvis_position,Pelvis_rotation,q,k,[],[]);
        else
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