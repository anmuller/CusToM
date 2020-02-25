function [solid_1_path,solid_2_path]=find_solid_path_ClosedLoop(Human_model,i,k)
% Identification of the hierarchical path between two solids of a closed
% loop
% This function should not be used for path finding of two solids that are
% easily connected in the model tree, as it is more complex than the
% regular find_solid_path.m function
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure)
%   - i: number of the first solid
%   - k: number of the second solid
%   OUTPUT
%   - solid_path: hierarchical path
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
% Path to tree root starting from solid i

solid_1_root_path = find_solid_root_path(Human_model,i);

% Path to tree root starting from solid k

solid_2_root_path = find_solid_root_path(Human_model,k);


% Finding closest common solid to both root paths

common_ancestors = intersect(solid_1_root_path,solid_2_root_path);
nearest_ancestor = max(common_ancestors);
solid_1_ancestor_ind = find(solid_1_root_path==nearest_ancestor);
solid_2_ancestor_ind = find(solid_2_root_path==nearest_ancestor);


% % If the path between both solids is easy (simple line on tree) ...
% % There is no need to go into more detail
% if nearest_ancestor==k
%     solid_path = solid_1_root_path(solid_1_ancestor_ind:end);
%
% elseif nearest_ancestor==i
%     solid_path = solid_2_root_path(solid_2_ancestor_ind:end);
%
% If the path between both solids is a lace on tree
% else

if i>k % Starting from smallest solid increment
    solid_1_path = solid_1_root_path(solid_1_ancestor_ind:end);
    solid_2_path = sort(solid_2_root_path(solid_2_ancestor_ind:end),'descend');
else
    solid_1_path = sort(solid_1_root_path(solid_1_ancestor_ind:end),'descend');
    solid_2_path = solid_2_root_path(solid_2_ancestor_ind:end);
end

% end

end

function solid_root_path=find_solid_root_path(Human_model,i,solid_root_path)

if nargin < 3   % if first incrementation
    solid_root_path=i;
    
elseif i==1
    solid_root_path = [1 solid_root_path];
    return
end


j=Human_model(i).mother; % number of the mother

solid_root_path=[j solid_root_path]; % Number (dent) of the mother is added into the global path

if j == 1  % If Mother corresponds to the solid that closes the loop
    return;
else
    [solid_root_path]=find_solid_root_path(Human_model,j,solid_root_path);
end

end

