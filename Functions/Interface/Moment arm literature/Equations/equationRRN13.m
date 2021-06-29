function y=equationRRN13(b,q)
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
%   - y : vector resulting from the equation (13)
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
q3=q(:,3);


if size(b,1)<30
    b=[b ; zeros(30-size(b,1),1)];    
    disp('Attention il manque des coeffs pour ce muscle (RRN13)');
end

c=b(1);
a=b(2:end);

y = c+a(1).*q2+a(2).*q3+a(3).*q2.^2+a(4).*q3.^2+a(5).*q2.^3+a(6).*q3.^3+a(7).*q1.*q2+a(8).*q2.*q3+a(9).*q1.*q2.*q3+a(10).*q1.^2.*q2+a(11).*q1.*q2.^2+a(12).*q2.^2.*q3+...
+a(13).*q1.*q3.^2+a(14).*q2.*q3.^2+a(15).*q1.^3.*q2+a(16).*q1.^3.*q3+a(17).*q1.*q2.^3+a(18).*q2.^3.*q3+a(19).*q1.*q3.^3+a(20).*q2.*q3.^3+a(21).*q1.^2.*q2.^2.*q3.^2+...
+a(22).*q1.^4+a(23).*q2.^4+a(24).*q3.^4+a(25).*q1.^2.*q2.^2+a(26).*q2.^2.*q3.^2+a(27).*q1.^2.*q2.*q3+a(28).*q1.*q2.^2.*q3+a(29).*q1.*q2.*q3.^2;





y=y';


end





