function MomentsArmRegression=MomentsArmRegression_creationRRN()

% All coeffs non explained come from 
%Rankin, J. W., & Neptune, R. R. (2012). 
%Musculotendon lengths and moment arms for a
%three-dimensional upper-extremity model. 
%Journal of Biomechanics, 45(9), 1739–1744.
%https://doi.org/10.1016/j.jbiomech.2012.03.010

k=0;

k=k+1;
%% TricepsBrachii1
MomentsArmRegression(k).name='Tricepsmed';
MomentsArmRegression(k).regression(1).equation='RRN1';
MomentsArmRegression(k).regression(1).joints={'Ulna','Radius'};
MomentsArmRegression(k).regression(1).coeffs=[-2.02999e-2  -2.15606e-2  3.56484e-2  -1.78502e-2  2.6245e-3]';

k=k+1;
%% TricepsBrachii2
MomentsArmRegression(k).name='Tricepslat';
MomentsArmRegression(k).regression(1).equation='RRN1';
MomentsArmRegression(k).regression(1).joints={'Ulna','Radius'};
MomentsArmRegression(k).regression(1).coeffs=[-2.02999e-2  -2.15606e-2  3.56484e-2  -1.78502e-2  2.6245e-3]';

k=k+1;
%% Brachialis
MomentsArmRegression(k).name='Brachialis';
MomentsArmRegression(k).regression(1).equation='RRN1';
MomentsArmRegression(k).regression(1).joints={'Radius_J1','Radius'};
MomentsArmRegression(k).regression(1).coeffs=[9.84873e-3  1.01630e-2  -2.39557e-2  2.90329e-2  -9.24344e-3]';

k=k+1;
%% Brachioradialis
MomentsArmRegression(k).name='Brachioradialis';
MomentsArmRegression(k).regression(1).equation='RRN4';
MomentsArmRegression(k).regression(1).joints={'Radius_J1','Radius'};
MomentsArmRegression(k).regression(1).axe='Radius_J1';
MomentsArmRegression(k).regression(1).coeffs=[1.18003e-2  2.09993e-2  3.7126e-2  -1.47644e-2  -5.8285e-4  -3.57599e-3  -7.25432e-4  1.40991e-2  -1.25532e-2  -1.47822e-3  3.61034e-3 -2.57318e-4]';
MomentsArmRegression(k).regression(2).equation='RRN4';
MomentsArmRegression(k).regression(2).joints={'Radius_J1','Radius'};
MomentsArmRegression(k).regression(2).axe='Radius';
MomentsArmRegression(k).regression(2).coeffs=[-7.81478e-4  6.99447e-4  3.60463e-3  -1.06015e-3  -3.9357e-4  1.44296e-3  -8.94732e-4  -4.05248e-3  -1.00184e-2  -2.83974e-3  3.51570e-3  2.85087e-3]';

k=k+1;
%% PronatorQuadrus
MomentsArmRegression(k).name='PronatorQuadrus';
MomentsArmRegression(k).regression(1).equation='RRN1';
MomentsArmRegression(k).regression(1).joints={'Radius','Ulna'};
MomentsArmRegression(k).regression(1).coeffs=[7.30854e-3  2.28126e-3  -2.81928e-3  -1.02119e-3  1.74483e-5]';

k=k+1;

%% SupinatorBrevis
MomentsArmRegression(k).name='SupinatorBrevis';
MomentsArmRegression(k).regression(1).equation='';
MomentsArmRegression(k).regression(1).joints={'Radius'};
MomentsArmRegression(k).regression(1).coeffs=[]';


k=k+1;
%% ExtensorCarpiRadialisBrevis
MomentsArmRegression(k).name='ExtensorCarpiRadialisBrevis';
MomentsArmRegression(k).regression(1).equation='';
MomentsArmRegression(k).regression(1).joints={'Radius_J1','Radius'};
MomentsArmRegression(k).regression(1).coeffs=[]';
MomentsArmRegression(k).regression(2).equation='';
MomentsArmRegression(k).regression(2).joints={'Radius','Radius_J1'};
MomentsArmRegression(k).regression(2).coeffs=[]';
MomentsArmRegression(k).regression(3).equation='';
MomentsArmRegression(k).regression(3).joints={'Wrist_J1'};
MomentsArmRegression(k).regression(3).coeffs=[]';
MomentsArmRegression(k).regression(4).equation='';
MomentsArmRegression(k).regression(4).joints={'Hand'};
MomentsArmRegression(k).regression(4).coeffs=[]';

k=k+1;
%% ExtensorCarpiRadialisLongus
MomentsArmRegression(k).name='ExtensorCarpiRadialisLongus';
MomentsArmRegression(k).regression(1).equation='';
MomentsArmRegression(k).regression(1).joints={'Radius_J1','Radius'};
MomentsArmRegression(k).regression(1).coeffs=[]';
MomentsArmRegression(k).regression(2).equation='';
MomentsArmRegression(k).regression(2).joints={'Radius','Radius_J1'};
MomentsArmRegression(k).regression(2).coeffs=[]';
MomentsArmRegression(k).regression(3).equation='';
MomentsArmRegression(k).regression(3).joints={'Wrist_J1'};
MomentsArmRegression(k).regression(3).coeffs=[]';
MomentsArmRegression(k).regression(4).equation='';
MomentsArmRegression(k).regression(4).joints={'Hand'};
MomentsArmRegression(k).regression(4).coeffs=[]';



k=k+1;
%% ExtensorCarpiUlnaris
MomentsArmRegression(k).name='ExtensorCarpiUlnaris';
MomentsArmRegression(k).regression(1).equation='';
MomentsArmRegression(k).regression(1).joints={'Wrist_J1'};
MomentsArmRegression(k).regression(1).coeffs=[]';
MomentsArmRegression(k).regression(2).equation='';
MomentsArmRegression(k).regression(2).joints={'Hand'};
MomentsArmRegression(k).regression(2).coeffs=[]';

% Data for elbowflexion

MomentsArmRegression(k).regression(3).joints={'Radius_J1'};
MomentsArmRegression(k).regression(3).equation='';
MomentsArmRegression(k).regression(3).coeffs=[]';

% Data for elbowpronation
MomentsArmRegression(k).regression(4).joints={'Radius'};
MomentsArmRegression(k).regression(4).equation='';
MomentsArmRegression(k).regression(4).coeffs=[]';




k=k+1;
%% ExtensorDigitorum
MomentsArmRegression(k).name='ExtensorDigitorum';
MomentsArmRegression(k).regression(1).equation='';
MomentsArmRegression(k).regression(1).joints={'Wrist_J1'};
MomentsArmRegression(k).regression(1).coeffs=[]';
MomentsArmRegression(k).regression(2).equation='';
MomentsArmRegression(k).regression(2).joints={'Hand'};
MomentsArmRegression(k).regression(2).coeffs=[]';

% Data for elbowflexion

MomentsArmRegression(k).regression(3).joints={'Radius_J1'};
MomentsArmRegression(k).regression(3).equation='';
MomentsArmRegression(k).regression(3).coeffs=[]';



% Data for elbowpronation
MomentsArmRegression(k).regression(4).joints={'Radius'};
MomentsArmRegression(k).regression(4).equation='';
MomentsArmRegression(k).regression(4).coeffs=[]';




k=k+1;
%% FlexorCarpiRadialis
MomentsArmRegression(k).name='FlexorCarpiRadialis';
MomentsArmRegression(k).regression(1).equation='';
MomentsArmRegression(k).regression(1).joints={'Wrist_J1'};
MomentsArmRegression(k).regression(1).coeffs=[]';
MomentsArmRegression(k).regression(2).equation='';
MomentsArmRegression(k).regression(2).joints={'Hand'};
MomentsArmRegression(k).regression(2).coeffs=[]';

% Data for elbowflexion
MomentsArmRegression(k).regression(3).joints={'Radius_J1'};
MomentsArmRegression(k).regression(3).equation='';
MomentsArmRegression(k).regression(3).coeffs=[]';


% Data for elbowpronation
MomentsArmRegression(k).regression(4).joints={'Radius'};
MomentsArmRegression(k).regression(4).equation='';
MomentsArmRegression(k).regression(4).coeffs=[]';




k=k+1;
%% FlexorCarpiUlnaris
MomentsArmRegression(k).name='FlexorCarpiUlnaris';
MomentsArmRegression(k).regression(1).equation='';
MomentsArmRegression(k).regression(1).joints={'Wrist_J1'};
MomentsArmRegression(k).regression(1).coeffs=[]';
MomentsArmRegression(k).regression(2).equation='';
MomentsArmRegression(k).regression(2).joints={'Hand'};
MomentsArmRegression(k).regression(2).coeffs=[]';

% Data for elbowflexion
MomentsArmRegression(k).regression(3).joints={'Radius_J1'};
MomentsArmRegression(k).regression(3).equation='';
MomentsArmRegression(k).regression(3).coeffs=[]';

% Data for elbowpronation
MomentsArmRegression(k).regression(4).joints={'Radius'};
MomentsArmRegression(k).regression(4).equation='';
MomentsArmRegression(k).regression(4).coeffs=[]';





k=k+1;
%% FlexorDigitorumSuperior
MomentsArmRegression(k).name='FlexorDigitorumSuperior';
MomentsArmRegression(k).regression(1).equation='';
MomentsArmRegression(k).regression(1).joints={'Wrist_J1'};
MomentsArmRegression(k).regression(2).equation='';
MomentsArmRegression(k).regression(2).joints={'Hand'};
MomentsArmRegression(k).regression(1).coeffs=[]';
MomentsArmRegression(k).regression(2).coeffs=[]';

% Data for elbowflexion
MomentsArmRegression(k).regression(3).joints={'Radius_J1'};
MomentsArmRegression(k).regression(3).equation='';
MomentsArmRegression(k).regression(3).coeffs=[]';

% Data for elbowpronation


MomentsArmRegression(k).regression(4).joints={'Radius'};
MomentsArmRegression(k).regression(4).equation='';
MomentsArmRegression(k).regression(4).coeffs=[]';





end