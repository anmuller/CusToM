function [Thigh_Mass, Shank_Mass, Foot_Mass]= LegSegMass(Leg_Mass)
% Leg mass distribution between each segment
%   
%	Based on:
%	Dumas, R., Cheze, L., & Verriest, J. P., 2007.
%	Adjustments to McConville et al. and Young et al. body segment inertial parameters. Journal of biomechanics, 40(3), 543-553.
%
%   INPUT
%   - Leg_Mass: total mass of the leg
%   OUTPUT
%   - Thigh_Mass: mass of the thigh
%   - Shank_Mass: mass of the shank
%   - Foot_Mass: mass of the foot
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
Thigh_Mass=0.6721*Leg_Mass;
Shank_Mass=0.2623*Leg_Mass;
Foot_Mass=0.0656*Leg_Mass;

end
