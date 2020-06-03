function MomentsArmRegression=MomentsArmRegression_creation()

% All coeffs non explained come from 
% Ramsay, J. W., Hunter, B. V., & Gonzalez, R. V. (2009). 
% Muscle moment arm and normalized moment contributions as reference
% data for musculoskeletal elbow and wrist joint models. 
% Journal of Biomechanics, 42(4), 463–473. https://doi.org/10.1016/j.jbiomech.2008.11.035


k=0;

k=k+1;
%% TricepsBrachii1
MomentsArmRegression(k).name='TricepsBrachii1';
MomentsArmRegression(k).regression(1).equation=1;
MomentsArmRegression(k).regression(1).primaryjoint='Ulna';
MomentsArmRegression(k).regression(1).coeffs=[-24.5454 - 8.8691 9.3509 -1.7518 0]';

k=k+1;
%% TricepsBrachii2
MomentsArmRegression(k).name='TricepsBrachii2';
MomentsArmRegression(k).regression(1).equation=1;
MomentsArmRegression(k).regression(1).primaryjoint='Ulna';
MomentsArmRegression(k).regression(1).coeffs=[-24.5454 - 8.8691 9.3509 -1.7518 0]';

k=k+1;
%% BicepsBrachii1
MomentsArmRegression(k).name='BicepsBrachii1';
MomentsArmRegression(k).regression(1).equation=2;
MomentsArmRegression(k).regression(1).primaryjoint='Radius_J1';
MomentsArmRegression(k).regression(1).secondaryjoint='Radius';
MomentsArmRegression(k).regression(1).coeffs=[ 8.4533 36.6147 2.4777 -19.432 2.0571 13.6502 0 0 -5.6172 0 -2.0854 0 0 0 0 0 ]';
MomentsArmRegression(k).regression(2).equation=2;
MomentsArmRegression(k).regression(2).primaryjoint='Radius';
MomentsArmRegression(k).regression(2).secondaryjoint='Radius_J1';
MomentsArmRegression(k).regression(2).coeffs=[ 1.7271 -4.1504 5.3103 -8.197 0.4405 1.0401 2.6866 -5.5137 0.6448 0 -1.0155 0 2.9534 0 -0.5583 0]';


k=k+1;
%% BicepsBrachii2
MomentsArmRegression(k).name='BicepsBrachii2';
MomentsArmRegression(k).regression(1).equation=2;
MomentsArmRegression(k).regression(1).primaryjoint='Radius_J1';
MomentsArmRegression(k).regression(1).secondaryjoint='Radius';
MomentsArmRegression(k).regression(1).coeffs=[ 8.4533 36.6147 2.4777 -19.432 2.0571 13.6502 0 0 -5.6172 0 -2.0854 0 0 0 0 0 ]';
MomentsArmRegression(k).regression(2).equation=2;
MomentsArmRegression(k).regression(2).primaryjoint='Radius';
MomentsArmRegression(k).regression(2).secondaryjoint='Radius_J1';
MomentsArmRegression(k).regression(2).coeffs=[ 1.7271 -4.1504 5.3103 -8.197 0.4405 1.0401 2.6866 -5.5137 0.6448 0 -1.0155 0 2.9534 0 -0.5583 0]';


k=k+1;
%% Brachialis
MomentsArmRegression(k).name='Brachialis';
MomentsArmRegression(k).regression(1).equation=1;
MomentsArmRegression(k).regression(1).primaryjoint='Radius_J1';
MomentsArmRegression(k).regression(1).coeffs=[ 16.1991 -16.1463 24.5512 -6.3335 0 ]';

k=k+1;
%% Brachioradialis
MomentsArmRegression(k).name='Brachioradialis';
MomentsArmRegression(k).regression(1).equation=2;
MomentsArmRegression(k).regression(1).primaryjoint='Radius_J1';
MomentsArmRegression(k).regression(1).secondaryjoint='Radius';
MomentsArmRegression(k).regression(1).coeffs=[15.2564 -11.8355 2.8129 -5.7781 44.8143 0 2.9032 0 0 -13.4956 0 -0.3940 0 0 0 0]';
MomentsArmRegression(k).regression(2).equation=2;
MomentsArmRegression(k).regression(2).primaryjoint='Radius';
MomentsArmRegression(k).regression(2).secondaryjoint='Radius_J1';
MomentsArmRegression(k).regression(2).coeffs=[ 3.8738 -3.1232 -2.3556 6.0596 7.9944 0.0973 -2.9923 -2.0882 -3.9195 -2.2210 -0.1293 0.4969 0.3683 1.3385 0.9909 -0.3279 ]';

k=k+1;
%% PronatorQuadrus
MomentsArmRegression(k).name='PronatorQuadrus';
MomentsArmRegression(k).regression(1).equation=3;
MomentsArmRegression(k).regression(1).primaryjoint='Ulna';
MomentsArmRegression(k).regression(1).secondaryjoint='Radius';
MomentsArmRegression(k).regression(1).coeffs=[11.0405 -1.0079 0.3933 -10.4824 -12.1639 -0.4369 36.9174 3.5232 -10.4223 21.2604 -37.2444 10.2666 -11.0060 14.5974 -3.9919 1.7526 -2.0089 0.5460 ]';
MomentsArmRegression(k).regression(2).equation=2;
MomentsArmRegression(k).regression(2).primaryjoint='Radius';
MomentsArmRegression(k).regression(2).secondaryjoint='Ulna';
MomentsArmRegression(k).regression(2).coeffs=[ 5.0238 7.6939 -0.2566 0.9826 -3.3182 0 -0.3034  ]';

k=k+1;
%% SupinatorBrevis
MomentsArmRegression(k).name='SupinatorBrevis';
MomentsArmRegression(k).regression(1).equation=1;
MomentsArmRegression(k).regression(1).primaryjoint='Radius';
MomentsArmRegression(k).regression(1).coeffs=[ -13.8661 3.4337 ]';


k=k+1;
%% ExtensorCarpiRadialisBrevis
MomentsArmRegression(k).name='ExtensorCarpiRadialisBrevis';
MomentsArmRegression(k).regression(1).equation=2;
MomentsArmRegression(k).regression(1).primaryjoint='Radius_J1';
MomentsArmRegression(k).regression(1).secondaryjoint='Radius';
MomentsArmRegression(k).regression(1).coeffs=[ -11.256 17.8548 1.6398 -0.5073 -2.8827 0 -0.0942 ]';
MomentsArmRegression(k).regression(2).equation=2;
MomentsArmRegression(k).regression(2).primaryjoint='Radius';
MomentsArmRegression(k).regression(2).secondaryjoint='Radius_J1';
MomentsArmRegression(k).regression(2).coeffs=[  0.2024 -0.9210 2.8116 -1.3039 ]';
MomentsArmRegression(k).regression(3).equation=1;
MomentsArmRegression(k).regression(3).primaryjoint='Wrist_J1';
MomentsArmRegression(k).regression(3).coeffs=[ -13.4337 2.1411];
MomentsArmRegression(k).regression(4).equation=1;
MomentsArmRegression(k).regression(4).primaryjoint='Hand';
MomentsArmRegression(k).regression(4).coeffs=[ -8.9026 6.3445];

k=k+1;
%% ExtensorCarpiRadialisLongus
MomentsArmRegression(k).name='ExtensorCarpiRadialisLongus';
MomentsArmRegression(k).regression(1).equation=2;
MomentsArmRegression(k).regression(1).primaryjoint='Radius_J1';
MomentsArmRegression(k).regression(1).secondaryjoint='Radius';
MomentsArmRegression(k).regression(1).coeffs=[ -7.7034 16.3913 7.4361 -1.7566 0 -1.3336 0 0.0742 ]';
MomentsArmRegression(k).regression(2).equation=2;
MomentsArmRegression(k).regression(2).primaryjoint='Radius';
MomentsArmRegression(k).regression(2).secondaryjoint='Radius_J1';
MomentsArmRegression(k).regression(2).coeffs=[  -0.4621 -1.0054 6.5392 -2.3266 0 -0.5677 0 -0.0837]';
MomentsArmRegression(k).regression(3).equation=1;
MomentsArmRegression(k).regression(3).primaryjoint='Wrist_J1';
MomentsArmRegression(k).regression(3).coeffs=[ -11.7166 2.2850];
MomentsArmRegression(k).regression(4).equation=1;
MomentsArmRegression(k).regression(4).primaryjoint='Hand';
MomentsArmRegression(k).regression(4).coeffs=[ -19.6240 5.5435];




k=k+1;
%% ExtensorCarpiUlnaris
MomentsArmRegression(k).name='ExtensorCarpiUlnaris';
MomentsArmRegression(k).regression(1).equation=1;
MomentsArmRegression(k).regression(1).primaryjoint='Wrist_J1';
MomentsArmRegression(k).regression(1).coeffs=[-8.5156 3.1064];
MomentsArmRegression(k).regression(2).equation=1;
MomentsArmRegression(k).regression(2).primaryjoint='Hand';
MomentsArmRegression(k).regression(2).coeffs=[24.0633 3.8461];

% Data for elbowflexion
% Taken from Gonzalez, R. V., Buchanan, T. S., & Delp, S. L. (1997). How muscle architecture and moment arms affect wrist flexion-extension moments. Journal of Biomechanics, 30(7), 705–712. https://doi.org/10.1016/S0021-9290(97)00015-8
% From measures in OpenSim

x=[4 12 21 37 53.8 70 77.5 84 91 95.8 101 105 109 114 118 122 126 129]*pi/180;
y=[0.0025 0.00275 0.0030 0.00325 0.00325:-0.00025:0 ];

p=polyfit(x,y,2);
MomentsArmRegression(k).regression(3).primaryjoint='Radius_J1';
MomentsArmRegression(k).regression(3).equation=1;
MomentsArmRegression(k).regression(3).coeffs=flip(p)';

% Data for elbowpronation
% Taken from Gonzalez, R. V., Buchanan, T. S., & Delp, S. L. (1997). How muscle architecture and moment arms affect wrist flexion-extension moments. Journal of Biomechanics, 30(7), 705–712. https://doi.org/10.1016/S0021-9290(97)00015-8
% From measures in OpenSim

x=[-55 -42.7 -33.6 -24.5 -15.5 -6.4 2.7 11 22.5 32 46 62.7 84.5]*pi/180;
y=0.006:-0.001:-0.006;

p=polyfit(x,y,3);
MomentsArmRegression(k).regression(4).primaryjoint='Radius';
MomentsArmRegression(k).regression(4).equation=1;
MomentsArmRegression(k).regression(4).coeffs=flip(p)';




k=k+1;
%% ExtensorDigitorum
MomentsArmRegression(k).name='ExtensorDigitorum';
MomentsArmRegression(k).regression(1).equation=1;
MomentsArmRegression(k).regression(1).primaryjoint='Wrist_J1';
MomentsArmRegression(k).regression(1).coeffs=[-14.1276 1.7325]';
MomentsArmRegression(k).regression(2).equation=1;
MomentsArmRegression(k).regression(2).primaryjoint='Hand';
MomentsArmRegression(k).regression(2).coeffs=[2.0459 4.5732]';

% Data for elbowflexion
% Taken from Gonzalez, R. V., Buchanan, T. S., & Delp, S. L. (1997). How muscle architecture and moment arms affect wrist flexion-extension moments. Journal of Biomechanics, 30(7), 705–712. https://doi.org/10.1016/S0021-9290(97)00015-8
% From measures in OpenSim

% x=[15, 40, 52.5 , 62, 71, 79 ,86, 93, 100, 106 , 112, 121, 127]*pi/180;
% y=-0.01:0.001:0.002;
% 
% p=polyfit(x,y,2);
% MomentsArmRegression(k).regression(3).primaryjoint='Radius_J1';
% MomentsArmRegression(k).regression(3).equation=1;
% MomentsArmRegression(k).regression(3).coeffs=flip(p)';
% 
% 
% 
% % Data for elbowpronation
% % Taken from Gonzalez, R. V., Buchanan, T. S., & Delp, S. L. (1997). How muscle architecture and moment arms affect wrist flexion-extension moments. Journal of Biomechanics, 30(7), 705–712. https://doi.org/10.1016/S0021-9290(97)00015-8
% % From measures in OpenSim
% 
% x=[-88 -75.5 -57 -13.6 4.5 15.5 26.4 35.5 44.5 53.6 62.7 71.8 81 90]*pi/180;
% y=[0.001 0.00125 0.0015 0.0015:-0.00025:-0.0010];
% 
% p=polyfit(x,y,3);
% MomentsArmRegression(k).regression(4).primaryjoint='Radius';
% MomentsArmRegression(k).regression(4).equation=1;
% MomentsArmRegression(k).regression(4).coeffs=flip(p)';
% 




k=k+1;
%% FlexorCarpiRadialis
MomentsArmRegression(k).name='FlexorCarpiRadialis';
MomentsArmRegression(k).regression(1).equation=1;
MomentsArmRegression(k).regression(1).primaryjoint='Wrist_J1';
MomentsArmRegression(k).regression(1).coeffs=[13.2040 1.5995]';
MomentsArmRegression(k).regression(2).equation=1;
MomentsArmRegression(k).regression(2).primaryjoint='Hand';
MomentsArmRegression(k).regression(2).coeffs=[-10.1898 5.5019]';

% Data for elbowflexion
% Taken from Gonzalez, R. V., Buchanan, T. S., & Delp, S. L. (1997). How muscle architecture and moment arms affect wrist flexion-extension moments. Journal of Biomechanics, 30(7), 705–712. https://doi.org/10.1016/S0021-9290(97)00015-8
% From measures in OpenSim

x=[0 4 7.5 11 15 18.5 23 27 31 35.4 39 43 48.5 53.8 59 65 72 81 101 122 131]*pi/180;
y=[-0.0003:0.0001:0.0015 0.0014 0.0013];

p=polyfit(x,y,3);
MomentsArmRegression(k).regression(3).primaryjoint='Radius_J1';
MomentsArmRegression(k).regression(3).equation=1;
MomentsArmRegression(k).regression(3).coeffs=flip(p)';


% Data for elbowflexion
% Taken from Gonzalez, R. V., Buchanan, T. S., & Delp, S. L. (1997). How muscle architecture and moment arms affect wrist flexion-extension moments. Journal of Biomechanics, 30(7), 705–712. https://doi.org/10.1016/S0021-9290(97)00015-8
% From measures in OpenSim

x=[-88 -82.7 -77.3 -71.8 -66.4 -60 -55.5 -50.5 -43 -37 -31.8 -25 -19 -11.8 -2.7  10  51.8 62.7 71.8 80 86]*pi/180;
y=[-0.0025:0.0005:0.005 0.005:-0.0005:0.003];

p=polyfit(x,y,3);
MomentsArmRegression(k).regression(4).primaryjoint='Radius';
MomentsArmRegression(k).regression(4).equation=1;
MomentsArmRegression(k).regression(4).coeffs=flip(p)';





k=k+1;
%% FlexorCarpiUlnaris
MomentsArmRegression(k).name='FlexorCarpiUlnaris';
MomentsArmRegression(k).regression(1).equation=1;
MomentsArmRegression(k).regression(1).primaryjoint='Wrist_J1';
MomentsArmRegression(k).regression(1).coeffs=[11.2147 4.6725 1.3307]';
MomentsArmRegression(k).regression(2).equation=1;
MomentsArmRegression(k).regression(2).primaryjoint='Hand';
MomentsArmRegression(k).regression(2).coeffs=[19.6193 13.2905]';

% Data for elbowflexion
% Taken from Gonzalez, R. V., Buchanan, T. S., & Delp, S. L. (1997). How muscle architecture and moment arms affect wrist flexion-extension moments. Journal of Biomechanics, 30(7), 705–712. https://doi.org/10.1016/S0021-9290(97)00015-8
% From measures in OpenSim

x=[1 10 18 26 32.5 39 45 51 57 62.5 68 75 82 87.5 95 103 112.5 125]*pi/180;
y=-0.002:0.00025:0.00225;

p=polyfit(x,y,3);
MomentsArmRegression(k).regression(3).primaryjoint='Radius_J1';
MomentsArmRegression(k).regression(3).equation=1;
MomentsArmRegression(k).regression(3).coeffs=flip(p)';

% Data for elbowpronation
% Taken from Gonzalez, R. V., Buchanan, T. S., & Delp, S. L. (1997). How muscle architecture and moment arms affect wrist flexion-extension moments. Journal of Biomechanics, 30(7), 705–712. https://doi.org/10.1016/S0021-9290(97)00015-8
% From measures in OpenSim

x=[-85 -79 -71 -63 -54 -42 -15 12  24 33 41 48 56 62 68 75 81 87  ]*pi/180;
y=[0.00075 0.001 0.00125 0.0015 0.00175 0.002 0.00225 0.002 0.00175 0.00150 0.00125 0.001 0.00075 0.00050 0.00025 0 -0.00025 -0.0005];

p=polyfit(x,y,3);
MomentsArmRegression(k).regression(4).primaryjoint='Radius';
MomentsArmRegression(k).regression(4).equation=1;
MomentsArmRegression(k).regression(4).coeffs=flip(p)';





k=k+1;
%% FlexorDigitorumSuperior
MomentsArmRegression(k).name='FlexorDigitorumSuperior';
MomentsArmRegression(k).regression(1).equation=1;
MomentsArmRegression(k).regression(1).primaryjoint='Wrist_J1';
MomentsArmRegression(k).regression(2).equation=1;
MomentsArmRegression(k).regression(2).primaryjoint='Hand';
MomentsArmRegression(k).regression(1).coeffs=[10.3467 1.0641 1.0495]';
MomentsArmRegression(k).regression(2).coeffs=[1.6252 6.3604]';

% Data for elbowflexion
% Taken from Gonzalez, R. V., Buchanan, T. S., & Delp, S. L. (1997). How muscle architecture and moment arms affect wrist flexion-extension moments. Journal of Biomechanics, 30(7), 705–712. https://doi.org/10.1016/S0021-9290(97)00015-8
% From measures in OpenSim

x=[1.3 4 7.8 10.5 14 17.2 21 25 29 32.8 38 44.6 52 84 93 99 105 110 114 119 123 126 130]*pi/180;
y=[-0.007:-0.001:-0.019 -0.019:0.001:-0.010];

p=polyfit(x,y,2);
MomentsArmRegression(k).regression(3).primaryjoint='Radius_J1';
MomentsArmRegression(k).regression(3).equation=1;
MomentsArmRegression(k).regression(3).coeffs=flip(p)';

% Data for elbowpronation
% Taken from Gonzalez, R. V., Buchanan, T. S., & Delp, S. L. (1997). How muscle architecture and moment arms affect wrist flexion-extension moments. Journal of Biomechanics, 30(7), 705–712. https://doi.org/10.1016/S0021-9290(97)00015-8
% From measures in OpenSim

x=[-86 -81 -75 -71 -66 -62.7 -57.3 -53.6 -48.2 -44.5 -40 -35.5 -31 -25 -21 -15.5 -8.2 -2.7 4.5 15.5 35 61 68 77 83 88]*pi/180;
y=[-0.00175:0.00025:0.00325 0.003:-0.00025:0.002];

p=polyfit(x,y,3);
MomentsArmRegression(k).regression(4).primaryjoint='Radius';
MomentsArmRegression(k).regression(4).equation=1;
MomentsArmRegression(k).regression(4).coeffs=flip(p)';





end