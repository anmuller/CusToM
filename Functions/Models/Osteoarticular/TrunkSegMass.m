function [Pelvis_Mass, LowerTrunk_Mass, Thorax_Mass, Skull_Mass,Scapula_Mass,Clavicle_Mass]= TrunkSegMass(Trunk_Mass)
% Trunk mass distribution between each segment
%
%	Based on:
%       Dumas, R., Cheze, L., & Verriest, J. P., 2007.
%       Adjustments to McConville et al. and Young et al. body segment inertial parameters. Journal of biomechanics, 40(3), 543-553.
%
%       Klein Breteler, M. D., Spoor, C. W., & Van der Helm, F. C. T. (1999). 
%       Measuring muscle and joint geometry parameters of a shoulder for modeling purposes. Journal of Biomechanics, 32(11), 1191–1197.
%
%   INPUT
%   - Trunk_Mass: total mass of the trunk
%   OUTPUT
%   - Pelvis_Mass: mass of the pelvis
%   - LowerTrunk_Mass: mass of the lower trunk
%   - UpperTrunk_Mass: mass of the upper trunk
%   - Skull_Mass: mass of the skull
%   - Scapula_Mass: mass of a scapula
%   - Clavicle_Mass: mass of a clavicle
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
Pelvis_Mass = 0.26*Trunk_Mass;
LowerTrunk_Mass = 0;
Thorax_Mass = 0.573*Trunk_Mass;
Skull_Mass = 0.13*Trunk_Mass;

% Shoulder elements mass adapted from (Klein Breteler et al., 1999)
Scapula_Mass = 0.0152*Trunk_Mass;
Clavicle_Mass = 0.00327*Trunk_Mass;
end




