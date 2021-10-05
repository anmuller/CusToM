function Qt=QuatSlerpAtHome(Q0,Q1,t)
% Computes the spherical linear interpolation between two quaternions
% INPUTS:
%       Q0: Quaternion at start of interpolation
%       Q1: Quaternion at end of interpolation
%       t:  Interpolation factor between [0,1]
% OUTPUTS:
%       Qt: Quaternion interpolated
%
% See Shoemake, Ken. "Animating Rotation with Quaternion Curves." ACM SIGGRAPH Computer Graphics Vol. 19, Issue 3, 1985, pp. 345–354.
Q0_inv  = QuatInverseAtHome(Q0);
Qt      = Q0*QuatPowerAtHome((Q0_inv*Q1),t);