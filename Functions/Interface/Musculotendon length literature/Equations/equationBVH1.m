function y=equationBVH1(a,q)
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
%   - y : vector resulting from the equation (1)
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


y=polyval(flip(a),q1);

y=y';

end

