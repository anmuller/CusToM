function [Io] = Huygens(OG,Ig,m)
% Computation of inertia matrix at point O
%
%   INPUT
%   - OG: location of the center of gravity (G) from point O
%   - Ig: inertia matrix at point G
%   - m: solid mass
%   OUTPUT
%   - Io: inertia matrix at point O
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

Io=Ig+m*[OG(2)^2 + OG(3)^2 -OG(1)*OG(2) -OG(1)*OG(3);-OG(1)*OG(2) OG(1)^2+OG(3)^2 -OG(2)*OG(3);-OG(1)*OG(3) -OG(2)*OG(3) OG(1)^2+OG(2)^2];

end

