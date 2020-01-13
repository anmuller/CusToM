function [Humerus_Mass, Forearm_Mass, Hand_Mass]= ArmSegMass(Arm_Mass)
% Arm mass distribution between each segment
%
%	Based on:
%	Dumas, R., Cheze, L., & Verriest, J. P., 2007.
%	Adjustments to McConville et al. and Young et al. body segment inertial parameters. Journal of biomechanics, 40(3), 543-553.
%
%   INPUT
%   - Arm_Mass: total mass of the arm
%   OUTPUT
%   - Humerus_Mass: mass of the humerus
%   - Forearm_Mass: mass of the forearm
%   - Hand_Mass: mass of the hand
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
Humerus_Mass=0.5106*Arm_Mass;
Forearm_Mass=0.3617*Arm_Mass;
Hand_Mass=0.1277*Arm_Mass;

end
