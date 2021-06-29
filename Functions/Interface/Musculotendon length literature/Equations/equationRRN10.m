function y=equationRRN10(b,q)
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
%   - y : vector resulting from the equation (10)
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


if size(b,1)<88
    b=[b ; zeros(88-size(b,1),1)];    
    disp('Attention il manque des coeffs pour ce muscle (RRN10)');
end

c=b(1);
a=b(2:end);



y = c+a(1).*q1+a(2).*q2+a(3).*q3+a(4).*q1.^2+a(5).*q2.^2+a(6).*q3.^2+a(7).*q1.^3+a(8).*q2.^3+a(9).*q3.^1+a(10).*q1.*q2+a(11).*q1.*q3+a(12).*q2.*q3  +a(13).*q1.*q2.*q3+a(14).*q1.^2.*q2+a(15).*q1.^2.*q3+a(16).*q1.*q2.^2+a(17).*q2.^2.*q3+a(18).*q1.*q3.^2+a(19).*q2.*q3.^2+...
    +a(20).*q1.^3.*q2+a(21).*q1.^3.*q3+a(22).*q1.*q2.^3+a(23).*q2.^3.*q3+a(24).*q1.*q3.^3+a(25).*q2.*q3.^3+a(26).*q1.^2.*q2.^2.*q3.^2+...
    +a(27).*q1.^2.*q2.^2+a(28).*q1.^2.*q3.^2+a(29).*q2.^2.*q3.^2+a(30).*q1.^4.*q2+a(31).*q1.^4.*q3+a(32).*q1.*q2.^4+a(33).*q2.^4.*q3+a(34).*q1.*q3.^4+a(35).*q2.*q3.^4+...
 +a(36).*q1.^3.*q2.^2+a(37).*q1.^3.*q3.^2+a(38).*q1.^2.*q2.^3+a(39).*q2.^3.*q3.^2+a(40).*q1.^2.*q3.^3+a(41).*q2.^2.*q3.^3+...
 +a(42).*q1.^5+a(43).*q2.^5+a(44).*q3.^5+a(45).*q1.^3.*q2.^3+a(46).*q1.^3.*q2.*q3.^2+a(47).*q1.^2.*q2.^3.*q3+a(48).*q1.*q2.^3.*q3.^2+a(49).*q1.^2.*q2.*q3.^3+...
+a(50).*q1.*q2.^2.*q3.^3+a(51).*q1.^2.*q2.^2.*q3+a(52).*q1.^2.*q2.*q3.^2+a(53).*q1.*q2.^2.*q3.^2+a(54).*q1.^3.*q2.^3.*q3+a(55).*q1.^3.*q2.*q3.^3+a(56).*q1.*q2.^3.*q3.^3+a(57).*q1.^5.*q2+...
+a(58).*q1.^5.*q3+a(59).*q1.*q2.^5+a(60).*q2.^5.*q3+a(61).*q1.*q3.^5+a(62).*q2.*q3.^5+a(63).*q1.^6.*q2+a(64).*q1.*q2.^5+a(65).*q1.^7.*q2+a(66).*q1.*q2.^7+a(67).*q1.^5.*q2+...
+a(68).*q1.*q2.^8+a(69).*q1.^6.*q3+a(70).*q2.^6.*q3+a(71).*q1.^7.*q3+a(72).*q2.^7.*q3+a(73).*q1.^8.*q3+a(74).*q2.^8.*q3+a(75).*q1.*q3.^6+a(76).*q2.*q3.^6+a(77).*q1.^4.*q2.^2.*q3.^2+...
+a(78).*q1.^4.*q2.^3.*q3.^2+a(79).*q1.^4.*q2.^2.*q3.^3+a(80).*q1.^2.*q2.^4.*q3.^2+a(81).*q1.^2.*q2.^4.*q3.^3+a(82).*q1.^3.*q2.^4.*q3.^2+a(83).*q1.^2.*q2.^2.*q3.^4+a(84).*q1.^2.*q2.^3.*q3.^4+a(85).*q1.^3.*q2.^2.*q3.^4+...
+a(86).*q1.^3.*q2.^3.*q3.^3+a(87).*q1.^4.*q2.^4.*q3.^4;




y=y';


end