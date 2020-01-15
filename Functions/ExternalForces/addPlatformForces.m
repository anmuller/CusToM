function [external_forces] = addPlatformForces(external_forces, Solid, p, R, F, CoP)
% Addition of an external force corresponding to a platform forces
%   The CoP position is defined as an input of this function
%
%   INPUT
%   - external_forces: external forces applied on the subject
%   - Solid: number of the solid which is in contact with the platform
%   - p: position of the platform origin in the motion capture frame
%   - R: rotation matrix of the plateform frame in the motion capture frame
%   - F: forces and moments on the platform [Fx Fy Fz Mx My Mz]
%   - CoP: CoP position
%   OUTPUT
%   - external_forces: actualized external forces applied on the subject 
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

nb_frame=numel(external_forces);

%% Calcul de l'effort résultant

FR0=zeros(nb_frame,3);
if iscell(p) == 1 % plateforme mobile (computation of resulting forces)
    for i=1:nb_frame
       FR0(i,:)=(R{i}*F(i,1:3)')';    
    end
else  % plateforme fixe
    for i=1:nb_frame
       FR0(i,:)=(R*F(i,1:3)')';    
    end
end

%% Calcul du moment au point 0

% Utilisation du moment à l'origine de la plateforme (Moment expressed at origin of the platform frame)
    % Moment obtenu avec la plate-forme : M(O)=M(I)+OI^F   (Mp0 = Mp + CoP0 ^ F)
    Mp=zeros(nb_frame,3);
    Mp0=zeros(nb_frame,3);
    if iscell(p) == 1 % plateforme mobile (mobile platform)
        for i=1:nb_frame
            Mp(i,:)=(R{i}*F(i,4:6)')';
            Mp0(i,:)=Mp(i,:) + cross(p{i}',FR0(i,:));
        end
    else
        for i=1:nb_frame
            Mp(i,:)=(R*F(i,4:6)')';
            Mp0(i,:)=Mp(i,:) + cross(p',FR0(i,:));
        end
    end        
    
%% Modification de "external_forces"

for i=1:nb_frame    
   external_forces(i).fext(Solid).fext=external_forces(i).fext(Solid).fext + [FR0(i,:)' Mp0(i,:)'];    
end


% on initialise le domaine Visual si il n'existe pas encore (adding a visual domain if not yet existing)
if ~any(strcmp('Visual',fieldnames(external_forces)))
    external_forces(1).Visual=[];
end

% on ajoute un vecteur 6x1 dans le domaine Visual : point d'origine et point d'arrivé du vecteur force
% adding a 6x1 vector in the visual domain:  origin and end points of force vector
for i=1:numel(external_forces) % pour chaque frame
    if iscell(p) == 1 % plateforme mobile
        pt_origin=p{i}+R{i}*CoP(i,:)';
    else
        pt_origin=p+R*CoP(i,:)';
    end
    pt_end=FR0(i,:)';
    external_forces(i).Visual = [external_forces(i).Visual [pt_origin;pt_end]];
end

end