function y=equationBVH2(a,q)
% Computing  y as a function of a and q, as defined in :
% Ramsay, J. W., Hunter, B. V., & Gonzalez, R. V. (2009). 
% Muscle moment arm and normalized moment contributions
% as reference data for musculoskeletal elbow and wrist joint models.
% Journal of Biomechanics, 42(4), 463–473. https://doi.org/10.1016/j.jbiomech.2008.11.035
%
%   INPUT
%   - a : coefficients
%   - q : vector of coordinates at the current instant
%
%   OUTPUT
%   - y : vector resulting from the equation (2)
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


if size(a,2)<16
    a=[a ; zeros(16-size(a,2),1)];
end

y=a(1) + a(2).*q1 + a(3).*q2 + a(4).*q1.*q2 + a(5).*q1.^2 + ...
     a(6).*q2.^2 + a(7).*q1.^2.*q2 +  a(8).*q1.*q2.^2 +  a(9).*q1.^2.*q2.^2+...
     a(10).*q1.^3 + a(11).*q2.^3 + a(12).*q1.^3.*q2 + a(13).*q1.*q2.^3 +...
     a(14).*q1.^3.*q2.^2 + a(15).*q1.^2.*q2.^3 + a(16).*q1.^3.*q2.^3;
y=y';
end

