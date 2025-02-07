function [h] = PlotFrame(P,R,scale)
% Generation of a frame
%
%   INPUT
%   - P: position vector 
%   - R: rotation matrix
%   - scale: scale the plotted arrows
%________________________________________________________
%
% Licence
% Toolbox distributed under 3-Clause BSD License
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
R = R';
hold on
h(1) = quiver3(P(1),P(2),P(3),R(1,1),R(1,2),R(1,3),scale);
h(2) = quiver3(P(1),P(2),P(3),R(2,1),R(2,2),R(2,3),scale);
h(3) = quiver3(P(1),P(2),P(3),R(3,1),R(3,2),R(3,3),scale);
h(4)=text(P(1)+R(1,1)*scale,P(2)+R(1,2)*scale,P(3)+R(1,3)*scale,'x');
h(5)=text(P(1)+R(2,1)*scale,P(2)+R(2,2)*scale,P(3)+R(2,3)*scale,'y');
h(6)=text(P(1)+R(3,1)*scale,P(2)+R(3,2)*scale,P(3)+R(3,3)*scale,'z');

end