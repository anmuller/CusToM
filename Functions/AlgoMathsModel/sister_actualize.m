function [Human_model]=sister_actualize(Human_model,j,i)
% Addition of a sister to a solid
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure) 
%   - j: number of one sister
%   - i: number of the new sister
%   OUTPUT
%   - Human_model: actualize osteo-articular model (see the Documentation
%   for the structure)
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________  

if Human_model(j).sister == 0
    Human_model(j).sister = i;
    return;
end

[Human_model]=sister_actualize(Human_model,Human_model(j).sister,i);

end