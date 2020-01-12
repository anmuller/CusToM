function Cpi = Force_max_TOR(pz,vp,Mass, zcrit, vcrit)
% Maximal force available at a contact point for the prediction of the ground reaction forces
%   if the vertical position and the normal of the velocity of the point is
%   lower than thresholds, the maximal force available is equal to 40% of
%   the subject weight
%
%   INPUT
%   - pz: vectical position of the point
%   - vp: norm of the velocity of the point
%   - Mass: subject mass
%   - zcrit: vectical position threshold
%   - vcrit: norm of the velocity threshold
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

prop=0.4;

if pz<zcrit && abs(vp)<vcrit 
    Cpi=prop* Mass*9.81; 
else
    Cpi=0;
end

end