function [NEW_I] = HuygensExtm(added_I, added_m, added_c, NEW_c)

% IMPUTS
%   Inertia matrix, mass and coordinates of an object ("added object")
%   coordinates of the targeted center of mass ("NEW_c")
% OUTPUTS
%   Inertia matrix of the object, at the targeted center of mass

% initialisation
NEW_I  = NaN(3, 3) ;

% Compute the transfer matrix
Diff_c = NEW_c - added_c ;
x = NaN ; x = Diff_c(1)  ;
y = NaN ; y = Diff_c(2)  ;
z = NaN ; z = Diff_c(3)  ;

Huygens_TMatrix = [ y*y + z*z,      -x*y,      -x*z; 
                        -x*y, x*x + z*z,      -y*z;
                        -x*z,      -y*z, x*x + y*y] ;

% Compute the new inertia matrix
NEW_I = added_I + added_m * Huygens_TMatrix ;

