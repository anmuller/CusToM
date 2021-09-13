function R=FromEulerAngles2Rotation(psi,theta,phi)

R(1,1)= cos(psi)*cos(phi)-sin(psi)*cos(theta)*sin(phi);
R(1,2) = - cos(psi)*sin(phi)- sin(psi)*cos(theta)*cos(phi);
R(1,3) = sin(psi)*sin(theta);
R(2,1) = sin(psi) * cos(phi) + cos(psi)*cos(theta)*sin(phi);
R(2,2) = - sin(psi)*sin(phi) + cos(psi)*cos(theta)*cos(phi);
R(2,3) = - cos(psi)*sin(theta);
R(3,1)= sin(theta)*sin(phi);
R(3,2) = sin(theta)*cos(phi);
R(3,3) = cos(theta);

end