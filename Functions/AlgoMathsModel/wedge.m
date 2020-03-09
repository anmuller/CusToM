function w_wedged=wedge(w)
% Cross product operator
%
%   INPUT
%   - w: vector (3x1)
%   OUTPUT
%   - w_wedged: cross product operator (matrix (3x3))
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

w_wedged=[0 -w(3) w(2);w(3) 0 -w(1);-w(2) w(1) 0];
end