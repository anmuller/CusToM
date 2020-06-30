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
MomentsArmRegression(k).regression(1).axe='Ulna';
MomentsArmRegression(k).regression(1).coeffs=[-2.02999e-2  -2.15606e-2  3.56484e-2  -1.78502e-2  2.6245e-3]';

k=k+1;
%% TricepsBrachii2
MomentsArmRegression(k).name='Tricepslat';
MomentsArmRegression(k).regression(1).equation='RRN1';
MomentsArmRegression(k).regression(1).joints={'Ulna','Radius'};
MomentsArmRegression(k).regression(1).axe='Ulna';
MomentsArmRegression(k).regression(1).coeffs=[-2.02999e-2  -2.15606e-2  3.56484e-2  -1.78502e-2  2.6245e-3]';

k=k+1;
%% Brachialis
MomentsArmRegression(k).name='Brachialis';
MomentsArmRegression(k).regression(1).equation='RRN1';
MomentsArmRegression(k).regression(1).joints={'Radius_J1','Radius'};
MomentsArmRegression(k).regression(1).axe='Radius_J1';
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
MomentsArmRegression(k).regression(1).axe='Radius';
MomentsArmRegression(k).regression(1).coeffs=[7.30854e-3  2.28126e-3  -2.81928e-3  -1.02119e-3  1.74483e-5]';

k=k+1;

%% SupinatorBrevis
MomentsArmRegression(k).name='SupinatorBrevis';
MomentsArmRegression(k).regression(1).equation='RRN1';
MomentsArmRegression(k).regression(1).joints={'Radius','Ulna'};
MomentsArmRegression(k).regression(1).axe='Radius';
MomentsArmRegression(k).regression(1).coeffs=[-7.67985E-03  4.08098E-04 1.45346E-03  -1.70151E-04  -5.01312E-04]';


k=k+1;
%% ExtensorCarpiRadialisBrevis
MomentsArmRegression(k).name='ExtensorCarpiRadialisBrevis';
MomentsArmRegression(k).regression(1).equation='RRN4';
MomentsArmRegression(k).regression(1).joints={'Radius_J1','Radius'};
MomentsArmRegression(k).regression(1).axe='Radius_J1';
MomentsArmRegression(k).regression(1).coeffs=[5.64642E-03  - 1.74387E-03  -3.71495E-03  1.01268E-03  -5.29727E-05  1.84085E-04  l .87014E-05   -3.87485E-04  5.11181E-05  2.50652E-04  4.03295E-05   2.61368E-05]';
MomentsArmRegression(k).regression(2).equation='RRN4';
MomentsArmRegression(k).regression(2).joints={'Radius_J1','Radius'};
MomentsArmRegression(k).regression(2).axe='Radius';
MomentsArmRegression(k).regression(2).coeffs=[-1.55243E-03  -5.91013E-05  -2.19213E-04  5.07507E-05  -1.90131E-03   7.41471E-04  3.34035E-04  1.84492E-04  6.68436E-04  1.32696E-04  -1.58205E-04  -1.55084E-04 ]';
MomentsArmRegression(k).regression(3).equation='RRN4';
MomentsArmRegression(k).regression(3).joints={'Hand','Wrist_J1'};
MomentsArmRegression(k).regression(3).axe='Hand';
MomentsArmRegression(k).regression(3).coeffs=[-1.34815E-02   3.02208E-02   5.78169E-03  -1.64320E-02  2.68623E-03  3.41629E-03  -2.45737E-03   8.20428E-04  -3.08372E-02  -8.27743E-03  3.13227E-02   6.21186E-03]';
MomentsArmRegression(k).regression(4).equation='RRN4';
MomentsArmRegression(k).regression(4).joints={'Hand','Wrist_J1'};
MomentsArmRegression(k).regression(4).axe='Wrist_J1';
MomentsArmRegression(k).regression(4).coeffs=[-2.67570E-02  2.69223E-03   3.35291E-03  -1.18284E-02  9.57323E-03   3.02360E-03  -2.78438E-03  2.09357E-03  -1.37559E-02  -6.54620E-03   2.41453E-02     1.01279E-02 ]';

k=k+1;
%% ExtensorCarpiRadialisLongus
MomentsArmRegression(k).name='ExtensorCarpiRadialisLongus';
MomentsArmRegression(k).regression(1).equation='RRN4';
MomentsArmRegression(k).regression(1).joints={'Radius_J1','Radius'};
MomentsArmRegression(k).regression(1).axe='Radius_J1';
MomentsArmRegression(k).regression(1).coeffs=[6.784195E-03  4.25933E-03   1.08103E-02   -3.02892E-03  5.08279E-03  -3.08828E-04   -9.16923E-04   -4.83760E-03   2 .49206E-03  -1.02552E-03   -4.91622E-04  -4.50855E-04  ]';
MomentsArmRegression(k).regression(2).equation='RRN4';
MomentsArmRegression(k).regression(2).joints={'Radius_J1','Radius'};
MomentsArmRegression(k).regression(2).axe='Radius';
MomentsArmRegression(k).regression(2).coeffs=[-2.36211E-03  2.93937E-03  -6.69053E-05  -1.39155E-04  -1.06309E-03  1.00099E-03  -5.83203E-04  -2.37355E-04  -2.73083E-03  -1.15824E-03   6.79267E-04   1.00675E-03 ]';
MomentsArmRegression(k).regression(3).equation='RRN4';
MomentsArmRegression(k).regression(3).joints={'Hand','Wrist_J1'};
MomentsArmRegression(k).regression(3).axe='Hand';
MomentsArmRegression(k).regression(3).coeffs=[-2.14012E-02  3.26927E-02  -1.13902E-02  -1.82031E-03  1.35811E-02  1.72010E-03  -2.39317E-03  -1.89705E-02  -1.02368E-02   -1.48189E-03  1.29229E-02  8.20184E-03  ]';
MomentsArmRegression(k).regression(4).equation='RRN4';
MomentsArmRegression(k).regression(4).joints={'Hand','Wrist_J1'};
MomentsArmRegression(k).regression(4).axe='Wrist_J1';
MomentsArmRegression(k).regression(4).coeffs=[-1.98904E-02 1.410779E-02   -5.64345E-03  -4.25499E-03  1.09667E-02   -4.96348E-03  - 7.54046E-05  1.60476E-03   -5.13726E-03  - 7.44317E-03   4.86065E-03   8.54788E-03 ]';


k=k+1;
%% ExtensorCarpiUlnaris
MomentsArmRegression(k).name='ExtensorCarpiUlnaris';
MomentsArmRegression(k).regression(1).equation='RRN1';
MomentsArmRegression(k).regression(1).joints={'Radius_J1'};
MomentsArmRegression(k).regression(1).axe='Radius_J1';
MomentsArmRegression(k).regression(1).coeffs=[-6.48E-03 -2.13E-03  4.01E-03   -7.28E-04    1.56E-05 ]';
MomentsArmRegression(k).regression(2).equation='RRN4';
MomentsArmRegression(k).regression(2).joints={'Radius_J1','Radius'};
MomentsArmRegression(k).regression(2).axe='Radius';
MomentsArmRegression(k).regression(2).coeffs=[ -6.83927E-04  4.81841E-10  -1.44939E-09  6.78194E-10  -2.61266E-03  3.40180E-04   4.37423E-04  1.38498E-09  -4.84425E-09  1.21106E-09   2.26670E-09  2.79839E-09 ];
MomentsArmRegression(k).regression(3).equation='RRN4';
MomentsArmRegression(k).regression(3).joints={'Hand','Wrist_J1'};
MomentsArmRegression(k).regression(3).axe='Hand';
MomentsArmRegression(k).regression(3).coeffs=[2.54110E-02  -1.11073E-02  -2.08457E-02  1.15763E-02  -1.49666E-02  -1.18817E-02  1.27967E-02  -2.35572E-02   2.55822E-02  1.27644E-03  6.66190E-02   -8.41382E-03      ]';
MomentsArmRegression(k).regression(4).equation='RRN4';
MomentsArmRegression(k).regression(4).joints={'Hand','Wrist_J1'};
MomentsArmRegression(k).regression(4).axe='Wrist_J1';
MomentsArmRegression(k).regression(4).coeffs=[-1.09221E-02   -1.73542E-02   -4.94780E-03  2.78397E-02  -7.07319E-03    1.96901E-02  9.79676E-03  -3.75544E-02   -9.52318E-03   2.45856E-02  -5.24763E-02  6.69292E-02    ]';




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




% 
% k=k+1;
% %% FlexorDigitorumSuperior
% MomentsArmRegression(k).name='FlexorDigitorumSuperior';
% MomentsArmRegression(k).regression(1).equation='';
% MomentsArmRegression(k).regression(1).joints={'Wrist_J1'};
% MomentsArmRegression(k).regression(2).equation='';
% MomentsArmRegression(k).regression(2).joints={'Hand'};
% MomentsArmRegression(k).regression(1).coeffs=[]';
% MomentsArmRegression(k).regression(2).coeffs=[]';
% 
% % Data for elbowflexion
% MomentsArmRegression(k).regression(3).joints={'Radius_J1'};
% MomentsArmRegression(k).regression(3).equation='';
% MomentsArmRegression(k).regression(3).coeffs=[]';
% 
% % Data for elbowpronation
% 
% 
% MomentsArmRegression(k).regression(4).joints={'Radius'};
% MomentsArmRegression(k).regression(4).equation='';
% MomentsArmRegression(k).regression(4).coeffs=[]';





end