function [Lmt,Wrapside] = Muscle_lengthNum(Human_model,Muscles,q)
% Computation of the muscle/tendon length
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure)
%   - Muscles: set of muscles (see the Documentation for the structure)
%   - q: vector of joint coordinates at a given instant
%   - m: number of the muscle in the set
%   OUTPUT
%   - Lmt length of the muscle/tendon
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
Wrapside=[];

if isfield(Muscles,'wrap') && ~isempty([Muscles.wrap])
    %find the wrap
    Wrap = [Human_model.wrap]; names = {Wrap.name}'; [~,ind]=intersect(names,Muscles.wrap{1});
    cur_Wrap=Wrap(ind);
    for p=1:(numel(Muscles.path)-1)
        % distance between p and p+1 point
        M_Bone = Muscles.num_solid(p); % number of the solid which contains this position
        M_pos = Muscles.num_markers(p); % number of the anatomical landmark in this solid
        N_Bone = Muscles.num_solid(p+1);
        N_pos = Muscles.num_markers(p+1);
        Wrapside=Muscles.wrapside;
        [L]=distance_point_wrap(M_pos,M_Bone,N_pos,N_Bone,Human_model,q,cur_Wrap,Wrapside,0);
        Lmt = Lmt + L;
    end
else
    for p=1:(numel(Muscles.path)-1)
        M_Bone = Muscles.num_solid(p); % number of the solid which contains this position
        M_pos = Muscles.num_markers(p); % number of the anatomical landmark in this solid
        N_Bone = Muscles.num_solid(p+1);
        N_pos = Muscles.num_markers(p+1);
        Lmt = Lmt + distance_point(M_pos,M_Bone,N_pos,N_Bone,Human_model,q);
    end
    
end

