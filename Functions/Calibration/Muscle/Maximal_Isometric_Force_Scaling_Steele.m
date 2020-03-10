function [F_scaled] = Maximal_Isometric_Force_Scaling_Steele...
    (Muscles,ModelParameters,H_ref)
%MAXIMAL_ISOMETRIC_FORCE_SCALING_ Summary of this function goes here
%   Detailed explanation goes here

% REF
%   - Steele, K.M., van der Krogt, M.M., Schwartz, M.H., Delp, S.L., 2012. 
%       How much muscle strength is required to walk in a crouch gait?  
%       Journal of Biomechanics 45, 2564–2569.

F0 = [Muscles.f0]';

H_subject = ModelParameters.Size;

if nargin<3
    H_ref = 1.80;
end

k = (H_subject/H_ref)^2;

F_scaled = k*F0 ;

end

