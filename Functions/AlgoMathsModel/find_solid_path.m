function [solid_path]=find_solid_path(Human_model,i,k,solid_path)
% Identification of the hierarchical path between two solids
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure) 
%   - i: number of the first solid
%   - k: number of the second solid
%   - solid_path: hierarchical path (updated at each call)
%   OUTPUT
%   - solid_path: hierarchical path
%________________________________________________________
%
% Licence
% Toolbox distributed under 3-Clause BSD License
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

if i==1
    solid_path = 1;
    return
end

if nargin < 4   % if first incrementation
    solid_path=i;
end

j=Human_model(i).mother; % number of the mother (numéro de la mère)

solid_path=[j solid_path]; % Number (dent) of the mother is added into the global path

if j == k  % If Mother corresponds to the solid that closes the loop
    return;
else
    [solid_path]=find_solid_path(Human_model,j,k,solid_path);
end

end