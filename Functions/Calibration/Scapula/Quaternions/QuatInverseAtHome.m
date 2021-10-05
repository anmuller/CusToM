function Qinv=QuatInverseAtHome(Q)
%Computes the inverse of a Quaternion
%Scalar first convention
%See Stevens, Brian L., Frank L. Lewis, Aircraft Control and Simulation, Wiley–Interscience, 2nd Edition.

Qinv=conj(Q)./(norm(Q)^2);