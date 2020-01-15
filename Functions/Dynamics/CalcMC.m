function mc=CalcMC(Human_model,j)
% Additional function that computes the global mass of the jth segments.
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   - j: current solid
%   OUTPUT
%   - mc: total mass of the solids
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
if j==0
    mc=0;
else
    mc=Human_model(j).m*(Human_model(j).p+Human_model(j).R*Human_model(j).c);
    mc=mc+CalcMC(Human_model,Human_model(j).sister)+CalcMC(Human_model,Human_model(j).child);
end