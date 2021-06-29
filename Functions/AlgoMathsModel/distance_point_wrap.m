function [L,Typ,wrapside] = distance_point_wrap(Point1,Bone1,Point2,Bone2,Human_model,q,Wrap,wrapside,EnforcedWrap)
% Computation of the distance between two points. The commented
% "Vizualisation wrapping" section is addressed to developpers to vizualize
% and to check correct wrapping.
%
%   INPUT
%   - Point1: position of the anatomical position of the first studied
%   point on its solid
%   - Bone1: number of the solid containing the first studied point
%   - Point2: position of the anatomical position of the second studied
%   point on its solid
%   - Bone2: number of the solid containing the second studied point
%   - Human_model: osteo-articular model (see the Documentation for the structure)
%   - q: vector of joint coordinates at a given instant
%   OUTPUT
%   - L: distance between the two studied points
%   - Typ: relative orientation of the two points (-1 ou 1)
%   - Wrapside: side of wrapping (1 or 2)
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud, Pauline Morin and
% Georges Dumont
%________________________________________________________

if Bone1 == Bone2
    A=Human_model(Bone1).anat_position{Point1,2};
    B=Human_model(Bone2).anat_position{Point2,2};
    L = norm(B-A);
    Typ = sign(B(2)-A(2));
    return
end

% finding the index of common antecedent (ppac:plus proche antecedent commun)
t = 1;
t1 = find_solid_path(Human_model,Bone1,1);
t2 = find_solid_path(Human_model,Bone2,1);
t3 = find_solid_path(Human_model,Wrap.num_solid,1);
while t<=min([numel(t1),numel(t2),numel(t3)]) && t1(t)==t2(t) && t1(t)==t3(t)
    ppac = t1(t);
    ppac_t = t;
    t = t + 1;
end

% minimal paths
solid1 = t1(ppac_t:end);
solid2 = t2(ppac_t:end);
wrap_path = t3(ppac_t:end);

% Direct kinematics initialization (Initialisation de la cinématique directe)
Human_model(ppac).p = zeros(3,1);
Human_model(ppac).R = eye(3);

% Computation of coordinates of point A (calcul des coordonnées du point A)
if numel(solid1)==1
    A = Human_model(Bone1).c+Human_model(Bone1).anat_position{Point1,2};
else
    for n=solid1(2:end)
        m = Human_model(n).mother;
        Human_model(n).p = Human_model(m).R * Human_model(n).b + Human_model(m).p;
        Human_model(n).R = Human_model(m).R * Rodrigues(Human_model(n).a,q(n)) * Rodrigues(Human_model(n).u,Human_model(n).theta);
    end
    l = solid1(end);
    Human_model(l).c_global = Human_model(l).p + Human_model(l).R * Human_model(l).c;
    A = Human_model(l).c_global + Human_model(l).R * Human_model(Bone1).anat_position{Point1,2};
end

% Computation of coordinates of point B (calcul des coordonnées du point B)
if numel(solid2)==1
    B = Human_model(Bone2).c+Human_model(Bone2).anat_position{Point2,2};
else
    for n=solid2(2:end)
        m = Human_model(n).mother;
        Human_model(n).p = Human_model(m).R * Human_model(n).b + Human_model(m).p;
        Human_model(n).R = Human_model(m).R * Rodrigues(Human_model(n).a,q(n)) * Rodrigues(Human_model(n).u,Human_model(n).theta);
    end
    l = solid2(end);
    Human_model(l).c_global = Human_model(l).p + Human_model(l).R * Human_model(l).c;
    B = Human_model(l).c_global + Human_model(l).R * Human_model(Bone2).anat_position{Point2,2};
end


% Computation of coordinates of the Wrap
if numel(wrap_path)==1
    Wc = Human_model(Wrap.num_solid).c+Wrap.location; % wrap_center
    R_i_w = Wrap.orientation;
    T_Ri_Rw = [R_i_w, Wc;[0 0 0],1];
else
    for n=wrap_path(2:end)
        m = Human_model(n).mother;
        Human_model(n).p = Human_model(m).R * Human_model(n).b + Human_model(m).p;
        Human_model(n).R = Human_model(m).R * Rodrigues(Human_model(n).a,q(n)) * Rodrigues(Human_model(n).u,Human_model(n).theta);
    end
    l = wrap_path(end);
    Human_model(l).c_global = Human_model(l).p + Human_model(l).R * Human_model(l).c;
    Wc = Human_model(l).c_global + Human_model(l).R * Wrap.location; % wrap_center
    R_i_w = Human_model(l).R*Wrap.orientation;
    T_Ri_Rw = [R_i_w, Wc;[0 0 0],1];
end



% Compute A and B in Wrap frame
Aw=T_Ri_Rw\[A;1];   Aw(4)=[];
Bw=T_Ri_Rw\[B;1];   Bw(4)=[];

%% Vizualisation of wraping 
% fastscatter3(A); hold on;
% fastscatter3(B)
% fastscatter3(Wc)

% subplot(1,2,2)
% fastscatter3(Aw); hold on;
% fastscatter3(Bw)
% fastscatter3([0 0 0]); axis equal
% Vérifier les longueurs les distances entre les points


% fastscatter3(A); hold on;
% fastscatter3(B)
% fastscatter3(Wc)
%%

% Is there an intersection between the cylinder and the straight line
% between Aw and Bw
% intersection_droite_cylindre(Aw, Bw, [0 0 0], Wrap.radius, -Wrap.h, +Wrap.h)
if Wrap.type=='C'
    if Intersect_line_cylinder(Aw, Bw, Wrap.R) || EnforcedWrap
        [L,~,~,~,wrapside]=CylinderWrapping(Aw, Bw, Wrap.R, wrapside);
        Typ = sign(Bw(2)-Aw(2));
    else
        %Distance between A and B
        L = norm(B-A);
        Typ = sign(B(2)-A(2));
        wrapside=[];
    end
elseif Wrap.type=='S'
    if Intersect_line_sphere(Aw, Bw, Wrap.R) || EnforcedWrap
        [L,~,~,~,wrapside]=SphereWrapping(Aw, Bw, Wrap.R, wrapside);
        Typ = sign(Bw(2)-Aw(2));
    else
        %Distance between A and B
        L = norm(B-A);
        Typ = sign(B(2)-A(2));
        wrapside=[];
    end
end

end