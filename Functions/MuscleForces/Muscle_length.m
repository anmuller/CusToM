function [Lmt] = Muscle_length(Human_model,Muscles,q)
% Computation of the muscle/tendon length
%   
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure) 
%   - Muscles: set of muscles (see the Documentation for the structure)
%   - q: vector of joint coordinates at a given instant
%   - m: number of the muscle in the set
%   OUTPUT
%   - length of the muscle/tendon
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

Lmt = 0;
for p=1:(numel(Muscles.path)-1)
    % distance between p and p+1 point
    M_Bone = Muscles.num_solid(p); % number of the solid which contains this position
    M_pos = Muscles.num_markers(p); % number of the anatomical landmark in this solid
    N_Bone = Muscles.num_solid(p+1);
    N_pos = Muscles.num_markers(p+1);
    Lmt = Lmt + distance_point(M_pos,M_Bone,N_pos,N_Bone,Human_model,q);
end

end

