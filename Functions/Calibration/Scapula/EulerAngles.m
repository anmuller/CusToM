function [PSI,THETA,PHI]=EulerAngles(R)
%Calcul des angles d'Euler d'une rotation pour la séquence d'angle (Z,X,Z)
%Source : https://fr.wikipedia.org/wiki/Angles_d%27Euler
%INPUT: Matrice de rotation
%OUTPUT: ANGLES D'EULER

X=R(:,1);
Y=R(:,2);
Z=R(:,3);

THETA = acos(Z(3));
if abs(THETA)<10^-6
    PHI=0;
    PSI=asin(-Y(1));
else
    PHI = asin(X(3)/sin(THETA));
    PSI = asin(Z(1)/sin(THETA));
end
end