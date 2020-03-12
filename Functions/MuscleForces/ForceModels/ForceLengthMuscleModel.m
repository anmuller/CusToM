function [Fa,Fp] = ForceLengthMuscleModel(lm_norm,Vm,Fmax)
% Computation of the muscle forces parameters in the case of a force-length
% Muscle model : F = Fmax*(A*fa(lm_norm)+fp(lm_norm))
%
%   Adapted from:
%       - Sarshari, E., 2018
%       A Closed-Loop EMG-Assisted Shoulder Model, Ch. 5: An initialization
%       technique for Hill-type musculotendon models, 75-87. EPFL
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

fl=exp(-(lm_norm-1).^2/0.0955);
fp=0.067*exp(3.832*(lm_norm - 1)) + 0.00378;

Fa = Fmax.*fl;
Fp = Fmax.*fp;
end

