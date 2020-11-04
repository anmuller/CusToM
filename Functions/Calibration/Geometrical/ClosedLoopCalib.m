function [c,ceq] = ClosedLoopCalib(Pelvis_position,Pelvis_rotation,q,k,pcut,Rcut,nb_ClosedLoop) %#ok<*INUSL>
% Non-linear equation used in the geometrical calibration step for closed loops
%
%   INPUT
%   - Pelvis_position: position of the pelvis at the considered instant
%   - Pelvis_rotation: rotation of the pelvis at the considered instant
%   - q: vector of joint coordinates at a given instant
%   - k: vector of homothety coefficient
%   - pcut: position of geometrical cuts
%   - Rcut: rotation of geometrical cuts
%   - nb_ClosedLoop: number of closed loop in the model
%   OUTPUT
%   - c: non-linar inequality
%   - ceq: non-linear equality
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

c=[];

% nb_eq=0; % initialisation du nb d'équation (initialization of the number of equations)
if nb_ClosedLoop == 0   % si il n'y a pas de boucle fermée --> pas de contrainte non linéaire (no closed loop and no non linear constraint)
    ceq=[];
else
    ceq=zeros(nb_ClosedLoop*7,1);
    for i=1:nb_ClosedLoop
    
%         eval(['[R,p] = fCL' num2str(i) '(Pelvis_position,Pelvis_rotation,q,k,pcut,Rcut);'])  
        eval(['[~,ceqi] = fCL' num2str(i) '(Pelvis_position,Pelvis_rotation,q,k,pcut,Rcut);'])  
        ceq(1+7*(i-1):7*i,1) = ceqi;
%         for z=1:3
%         nb_eq=nb_eq+1; % incrémentation du nombre d'équations (incrementation of the number of equations)
%         ceq(nb_eq,1)=p(z); 
%         end
% 
%         for z=1:3
%         nb_eq=nb_eq+1; % incrémentation du nombre d'équations (incrementation of the number of equations)
%         ceq(nb_eq,1)=R(z,z)-1; 
%         end
% 
%         nb_eq=nb_eq+1; % incrémentation du nombre d'équations (incrementation of the number of equations)
%         ceq(nb_eq,1)=R(1,2); 
%         nb_eq=nb_eq+1; % incrémentation du nombre d'équations (incrementation of the number of equations)
%         ceq(nb_eq,1)=R(1,3); 
%         nb_eq=nb_eq+1; % incrémentation du nombre d'équations (incrementation of the number of equations)
%         ceq(nb_eq,1)=R(2,3);   
    end   
end

end