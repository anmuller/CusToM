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
% Toolbox distributed under 3-Clause BSD License
%________________________________________________________

Io=Ig+m*[OG(2)^2 + OG(3)^2 -OG(1)*OG(2) -OG(1)*OG(3);-OG(1)*OG(2) OG(1)^2+OG(3)^2 -OG(2)*OG(3);-OG(1)*OG(3) -OG(2)*OG(3) OG(1)^2+OG(2)^2];

end

