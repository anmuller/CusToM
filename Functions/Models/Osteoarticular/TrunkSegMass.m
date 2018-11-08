function [Pelvis_Mass, LowerTrunk_Mass, UpperTrunk_Mass, Skull_Mass]= TrunkSegMass(Trunk_Mass)
% Trunk mass distribution between each segment
%
%	Based on:
%	Dumas, R., Cheze, L., & Verriest, J. P., 2007.
%	Adjustments to McConville et al. and Young et al. body segment inertial parameters. Journal of biomechanics, 40(3), 543-553.
%
%   INPUT
%   - Trunk_Mass: total mass of the trunk
%   OUTPUT
%   - Pelvis_Mass: mass of the pelvis
%   - LowerTrunk_Mass: mass of the lower trunk
%   - UpperTrunk_Mass: mass of the upper trunk
%   - Skull_Mass: mass of the skull
%________________________________________________________
%
% Licence
% Toolbox distributed under 3-Clause BSD License
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
Pelvis_Mass = 0.26*Trunk_Mass;
LowerTrunk_Mass = 0;
UpperTrunk_Mass = 0.61*Trunk_Mass;
Skull_Mass = 0.13*Trunk_Mass;

end




