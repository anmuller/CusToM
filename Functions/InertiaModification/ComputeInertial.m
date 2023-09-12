function [NEW_m, NEW_c, NEW_I] = ComputeInertial(m, added_m, c, added_c, I)
% INPUT
%   masses (m1 and m2) of 2 points
%   coordinates of 2 points (c, added_c)
% OUTPUT
%   total mass 
%   new mass center
%   new inertia matrix


% initialisation of output variables
NEW_m  = 0 ;
NEW_c  = NaN(1, 3) ;
NEW_I  = NaN(3, 3) ;
NEW_I1 = NaN(3, 3) ;
NEW_I2 = NaN(3, 3) ;

%   total mass 
NEW_m = m + added_m;

% new mass center
NEW_c = (m *c  + added_m *added_c) / NEW_m ; 

% new inertia matrix
%   Locate the additional mass inertia matrix at the new mass center of the segment
%   Locate the segment's former inertia matrix at the new mass center of the segment
%   Sum those inertia matrix
added_I = 0 ; % Inertia of a ponctual mass
[NEW_I1] = HuygensExtm(added_I, added_m, added_c, NEW_c) ;
[NEW_I2] = HuygensExtm(      I,       m,       c, NEW_c) ;
 NEW_I   = NEW_I1 + NEW_I2 ;

