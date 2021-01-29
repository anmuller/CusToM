function solids=PathConstruction(Human_model,solids_o_i)
% Finding all the real solids between given solids
%
%   INPUT
% - Human_model : osteo-articular model (see the Documentation for
%   the structure);
%   - solids_o_i : vector of 2 solids (origin and insertion)
%
%   OUTPUT
%   - solids : vecteur of  solids
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

[sp1,sp2]=find_solid_path(Human_model,solids_o_i(1),solids_o_i(2));
visu=find([Human_model.Visual]);

            
if length(sp1)~=1 && length(sp2)~=1
    common_ancestor = intersect(sp1,sp2);
    path = setdiff(unique([sp1,sp2]), common_ancestor);
else
    path =unique([sp1,sp2]);
end

  
solids_temp = intersect(path,visu);

if length(solids_temp) >2
    solids =  solids_temp(1);
    for k = 2:length(solids_temp)-1
        solids = [solids solids_temp(k) solids_temp(k)];
    end
    solids = [solids solids_temp(end)];
else
    solids = solids_temp;
end


end