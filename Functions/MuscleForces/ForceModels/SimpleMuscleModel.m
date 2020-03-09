function [Fa,Fp] = SimpleMuscleModel(Lm_norm,Vm,Fmax)
% Computation of the muscle forces parameters in the case of a simple
% Muscle model : F = Fmax*A
%
%   INPUT
%   - Lm_norm : Muscle length ratio to optimal length
%   OUTPUT
%   - Fl : Vector of force-length relationship
%   - Fp : Vector of passive forces relationship
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

fl=ones(size(Lm_norm));
fp=zeros(size(Lm_norm));

Fa = Fmax.*fl;
Fp = Fmax.*fp;
end

