function Qp=QuatPowerAtHome(Q,pow)
% Computes the power of a quaternion
% Scalar-first convention
% See : Dam, Erik B., Martin Koch, Martin Lillholm. "Quaternions, Interpolation, and Animation." University of Copenhagen, København, Denmark, 1998.
Qp=exp(pow*log(Q));