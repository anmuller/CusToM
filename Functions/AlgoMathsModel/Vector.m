function [vector] = Vector(Point1,Bone1,Point2,Bone2,Human_model,q)
% Computation of the vector between two points
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
%   - vector : vector between the two studied points
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________






if Bone1 == Bone2
    if Point1==0
        A = zeros(3,1);
    else
        A=Human_model(Bone1).anat_position{Point1,2};
    end
    if Point2==0
        B= zeros(3,1);
    else
        B=Human_model(Bone2).anat_position{Point2,2};
    end
    vector = B-A;
    return
end

% finding the index of common antecedent (ppac:plus proche antecedent commun)

if Bone1>Bone2
    [solid1,solid2] = find_solid_path(Human_model,Bone1,Bone2);
else
    [solid2,solid1] = find_solid_path(Human_model,Bone2,Bone1);
end
ppac=solid1(1);


% Direct kinematics initialization (Initialisation de la cin�matique directe)
Human_model(ppac).p = zeros(3,1);
Human_model(ppac).R = eye(3);

% Computation of coordinates of point A (calcul des coordonn�es du point A)
if numel(solid1)==1
    if Point1==0
        A = Human_model(Bone1).c;
    else
        A = Human_model(Bone1).c+Human_model(Bone1).anat_position{Point1,2};
    end
else
    for n=solid1(2:end)
        m = Human_model(n).mother;
        if Human_model(n).joint == 1
            Human_model(n).p = Human_model(m).R * Human_model(n).b + Human_model(m).p;
            Human_model(n).R = Human_model(m).R * Rodrigues(Human_model(n).a,q(n)) * Rodrigues(Human_model(n).u,Human_model(n).theta);
        end
        if Human_model(n).joint == 2
            Human_model(n).p = Human_model(m).R * Human_model(n).b + Human_model(m).p+ q(n)*Human_model(n).a;
            Human_model(n).R = Human_model(m).R  * Rodrigues(Human_model(n).u,Human_model(n).theta);
        end
    end
    l = solid1(end);
    Human_model(l).c_global = Human_model(l).p + Human_model(l).R * Human_model(l).c;
    if Point1==0
        A = Human_model(l).c_global;
    else
        A = Human_model(l).c_global + Human_model(l).R * Human_model(Bone1).anat_position{Point1,2};
    end
end

% Computation of coordinates of point B (calcul des coordonn�es du point B)
if numel(solid2)==1
    if Point2==0
        B = Human_model(Bone2).c;
    else
        B = Human_model(Bone2).c+Human_model(Bone2).anat_position{Point2,2};
    end
else
    for n=solid2(2:end)
        m = Human_model(n).mother;
        if Human_model(n).joint == 1
            Human_model(n).p = Human_model(m).R * Human_model(n).b + Human_model(m).p;
            Human_model(n).R = Human_model(m).R * Rodrigues(Human_model(n).a,q(n)) * Rodrigues(Human_model(n).u,Human_model(n).theta);
        end
        if Human_model(n).joint == 2
            Human_model(n).p = Human_model(m).R * Human_model(n).b + Human_model(m).p+ q(n)*Human_model(n).a;
            Human_model(n).R = Human_model(m).R * Rodrigues(Human_model(n).u,Human_model(n).theta);
        end
    end
    l = solid2(end);
    Human_model(l).c_global = Human_model(l).p + Human_model(l).R * Human_model(l).c;
    if Point2==0
        B = Human_model(l).c_global;
    else
        B = Human_model(l).c_global + Human_model(l).R * Human_model(Bone2).anat_position{Point2,2};
    end
end

%Distance between A and B
vector = B-A;

end