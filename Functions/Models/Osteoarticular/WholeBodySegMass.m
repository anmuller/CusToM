function [Trunk_Mass, Arm_Mass, Leg_Mass]= WholeBodySegMass(BodyMass)
% Whole body mass distribution between each body part
%
%	Based on:
%	Dumas, R., Cheze, L., & Verriest, J. P., 2007.
%	Adjustments to McConville et al. and Young et al. body segment inertial parameters. Journal of biomechanics, 40(3), 543-553.
%
%   INPUT
%   - BodyMass: total mass of the body
%   OUTPUT
%   - Trunk_Mass: mass of the trunk
%   - Arm_Mass: mass of the arm
%   - Leg_Mass: mass of the leg
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
Trunk_Mass=0.542*BodyMass;
Arm_Mass=0.047*BodyMass;
Leg_Mass=0.183*BodyMass;

end
