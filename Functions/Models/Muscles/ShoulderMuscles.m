function [Muscles]=ShoulderMuscles(Muscles,Signe)
% Definition of an arm muscle model
%   This model contains 9 muscles, actuating the elbow joint
%
%	Based on:
%	- Holzbaur, K. R., Murray, W. M., & Delp, S. L., 2005.
%	A model of the upper extremity for simulating musculoskeletal surgery and analyzing neuromuscular control. Annals of biomedical engineering, 33(6), 829-840
%
%   INPUT
%   - Muscles: set of muscles (see the Documentation for the structure)
%   - Signe: side of the arm model ('R' for right side or 'L' for left side)
%   OUTPUT
%   - Muscles: new set of muscles (see the Documentation for the structure)
%________________________________________________________
%
% Licence
% Toolbox distributed under 3-Clause BSD License
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
if strcmp(Signe,'Right')
    Side = 'R';
else
    Side = 'L';
end

s=cell(0);


s=[s;{
    [Side 'serr_ant_1'],61,0.1635,[],0.025,0,{[Side 'Scapula_serr_ant_1-P1'];[Side 'Thorax_serr_ant_1-P2']},{};...
    [Side 'serr_ant_2'],110,0.1667,[],0.009,0,{[Side 'Scapula_serr_ant_2-P1'];[Side 'Thorax_serr_ant_2-P2']},{};...
    [Side 'serr_ant_3'],105,0.1622,[],0.007,0,{[Side 'Scapula_serr_ant_3-P1'];[Side 'Thorax_serr_ant_3-P2']},{};...
    [Side 'serr_ant_4'],110,0.1289,[],0.011,0,{[Side 'Scapula_serr_ant_4-P1'];[Side 'Thorax_serr_ant_4-P2']},{};...
    [Side 'serr_ant_5'],64,0.1259,[],0.011,0,{[Side 'Scapula_serr_ant_5-P1'];[Side 'Thorax_serr_ant_5-P2']},{};...
    [Side 'serr_ant_6'],97,0.122,[],0.011,0,{[Side 'Scapula_serr_ant_6-P1'];[Side 'Thorax_serr_ant_6-P2']},{};...
    [Side 'serr_ant_7'],47,0.1133,[],0.009,0,{[Side 'Scapula_serr_ant_7-P1'];[Side 'Thorax_serr_ant_7-P2']},{};...
    [Side 'serr_ant_8'],76,0.0845,[],0.011,0,{[Side 'Scapula_serr_ant_8-P1'];[Side 'Thorax_serr_ant_8-P2']},{};...
    [Side 'serr_ant_9'],79,0.08,[],0.007,0,{[Side 'Scapula_serr_ant_9-P1'];[Side 'Thorax_serr_ant_9-P2']},{};...
    [Side 'serr_ant_10'],63,0.066,[],0.005,0,{[Side 'Scapula_serr_ant_10-P1'];[Side 'Thorax_serr_ant_10-P2']},{};...
    [Side 'serr_ant_11'],23,0.0885,[],0.003,0,{[Side 'Scapula_serr_ant_11-P1'];[Side 'Thorax_serr_ant_11-P2']},{};...
    [Side 'serr_ant_12'],112,0.0945,[],0.001,0,{[Side 'Scapula_serr_ant_12-P1'];[Side 'Thorax_serr_ant_12-P2']},{};...
    [Side 'rhomboid_min'],51,0.0986,[],0.015,0,{[Side 'Thorax_rhomboid_min-P1'];[Side 'Scapula_rhomboid_min-P2']},{};...
    [Side 'rhomboid_maj'],383,0.1193,[],0.0423,0,{[Side 'Thorax_rhomboid_min-P1'];[Side 'Scapula_rhomboid_min-P2']},{};...        
    [Side 'Deltoid_ant'],1218.9,0.0976,[],0.093,0.38397,{[Side 'humerus_r_DELT1_r-P1'];[Side 'humerus_r_DELT1_r-P1'];[Side 'Scapula_DELT1-P3'];[Side 'clavicle_r_DELT1_r-P4']},{};... 
    [Side 'Deltoid_mid'],1103.5,0.1078,[],0.1095,0.2618,{[Side 'humerus_r_DELT2_r-P1'];[Side 'Scapula_DELT2-P3'];[Side 'Scapula_DELT2-P4']},{};... 
    [Side 'Deltoid_pos'],201.6,0.1367,[],0.038,0.31416,{[Side 'Scapula_DELT3-P1'];[Side 'Scapula_DELT3-P2'];[Side 'humerus_r_DELT3_r-P3']},{};...
    [Side 'PECM1'],444.3,0.1442,[],0.0028,0.29671,{[Side 'humerus_r_PECM1_r-P1'];[Side 'humerus_r_PECM1_r-P2'];[Side 'Thorax_PECM1-P3'];[Side 'clavicle_r_PECM1_r-P4']},{};...
    [Side 'PECM2'],658.3,0.1385,[],0.089,0.45379,{[Side 'humerus_r_PECM2_r-P1'];[Side 'humerus_r_PECM2_r-P2'];[Side 'Thorax_PECM2-P3'];[Side 'Thorax_PECM2-P4'];[Side 'Thorax_PECM2-P5']},{};... 
    [Side 'PECM3'],498.1,0.1385,[],0.132,0.43633,{[Side 'humerus_r_PECM3_r-P1'];[Side 'humerus_r_PECM3_r-P2'];[Side 'Thorax_PECM3-P3'];[Side 'Thorax_PECM3-P4'];[Side 'Thorax_PECM3-P5']},{};... 
 
%     [Side 'SUPSP'],499.2,0.0682,[],0.0395,0.12217... EDIT
%     [Side 'INFSP'],1075.8,0.0755,[],0.0308,0.33161... EDIT
%     [Side 'SUBSC'],1306.9,0.0873,[],0.033,0.34907... EDIT
%     [Side 'TMIN'],269.5,0.0741,[],0.0713,0.41888... EDIT
%     [Side 'TMAJ'],144,0.1624,[],0.02,0.27925... EDIT   
%     [Side 'LAT1'],290.5,0.254,[],0.12,0.43633... EDIT
%     [Side 'LAT2'],317.5,0.2324,[],0.1765,0.33161... EDIT
%     [Side 'LAT3'],189,0.2789,[],0.1403,0.36652... EDIT
%     [Side 'CORB'],208.2,0.0932,[],0.097,0.47124... EDIT
%     [Side 'TRIlong'],771.8,0.134,[],0.143,0.20944... EDIT
%     [Side 'TRIlat'],717.5,0.1138,[],0.098,0.15708... EDIT
%     [Side 'TRImed'],717.5,0.1138,[],0.0908,0.15708... EDIT
%     [Side 'ANC'],283.2,0.027,[],0.018,0 ... EDIT
%     [Side 'SUP'],379.6,0.033,[],0.028,0 ... EDIT
%     [Side 'BIClong'],525.1,0.1157,[],0.2723,0 ... EDIT
%     [Side 'BICshort'],316.8,0.1321,[],0.1923,0 ... EDIT
%     [Side 'BRA'],1177.37,0.0858,[],0.0535,0 ... EDIT
%     [Side 'BRD'],276,0.1726,[],0.133,0 ... EDIT
%     [Side 'ECRL'],337.3,0.081,[],0.244,0 ... EDIT
%     [Side 'ECRB'],252.5,0.0585,[],0.2223,0.15708... EDIT
%     [Side 'ECU'],192.9,0.0622,[],0.2285,0.069813... EDIT
%     [Side 'FCR'],407.9,0.0628,[],0.244,0.05236... EDIT
%     [Side 'FCU'],479.8,0.0509,[],0.265,0.20944... EDIT
%     [Side 'PL'],101,0.0638,[],0.2694,0.069813... EDIT
%     [Side 'PT'],557.2,0.0492,[],0.098,0.17453... EDIT
%     [Side 'PQ'],284.7,0.0282,[],0.005,0.17453... EDIT
%     [Side 'FDSL'],75.3,0.0515,[],0.3386,0.087266... EDIT
%     [Side 'FDSR'],171.2,0.0736,[],0.328,0.069813... EDIT
%     [Side 'EDCL'],39.4,0.065,[],0.335,0.034907... EDIT
%     [Side 'EDCR'],109.2,0.0626,[],0.365,0.05236... EDIT
%     [Side 'EDCM'],94.4,0.0724,[],0.365,0.05236... EDIT
%     [Side 'stern_mast'],68.95,0.108,[],0.056123,... EDIT
%     [Side 'cleid_mast'],34.475,0.108,[],0.035198,... EDIT
%     [Side 'cleid_occ'],34.475,0.108,[],0.069467,... EDIT
%     [Side 'trap_cl'],77.6,0.084,[],0.11922,... EDIT
%     [Side 'trap_acr'],376.95,0.092,[],0.076582,... EDIT
%     [Side 'levator_scap'],76.3,0.113,[],0.021875,... EDIT
}];

% Structure generation
Muscles=[Muscles;struct('name',{s{:,1}}','f0',{s{:,2}}','l0',{s{:,3}}',...
    'Kt',{s{:,4}}','ls',{s{:,5}}','alpha0',{s{:,6}}','path',{s{:,7}}','wrap',{s{:,8}}')]; %#ok<CCAT1>
end