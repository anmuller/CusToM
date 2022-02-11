function y=equationRRN4(a,q)
% Computing  y as a function of a and q, as defined in :
% Rankin, J. W., & Neptune, R. R. (2012).
%Musculotendon lengths and moment arms for a
%three-dimensional upper-extremity model.
%Journal of Biomechanics, 45(9), 1739–1744.
%https://doi.org/10.1016/j.jbiomech.2012.03.010
%
%   INPUT
%   - a : coefficients
%   - q : vector of coordinates at the current instant
%
%   OUTPUT
%   - y : vector resulting from the equation (4)
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

q1=q(:,1);
q2=q(:,2);


if length(a)<12
    a=[a ; zeros(12-size(a,1),1)];    
    disp('Attention il manque des coeffs pour ce muscle (RRN4)');
end

y=a(1) + a(2)*q1 + a(3)*q1.^2 + a(4)*q1.^3  + a(5)*q2 + a(6)*q2.^2 + a(7)*q2.^3+...
    a(8)*q1.*q2 + a(9)*q1.^2.*q2 + a(10)*q1.*q2.^2 + a(11)*q1.^3.*q2 + a(12)*q1.*q2.^3;


y=y';


end