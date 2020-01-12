function [k]=NbSolidUpstream(Human_model,j,k)
% Computation of the number of solids hierarchically higher than the solid j
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the structure)
%   - j: number of the solid to study
%   - k: number of solids hierarchically higher (updated at each call)
%   OUTPUT
%   - k: number of solids hierarchically higher
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

i=Human_model(j).mother;

if (i ~= 0)
    if isequal(size(Human_model(i).KinematicsCut),[0 0])
	k=k+1;
    else
        return;
    end
else
    return;
end

[k]=NbSolidUpstream(Human_model,i,k);

end