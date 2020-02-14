function [Muscles]=ArmMusclesShoulder(Muscles,Signe)
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
    Signe = 'R';
else
    Signe = 'L';
end

s=cell(0);

% Elbow
s=[s;{
%     [Signe 'Brachioradialis'],261.3,[],[],[],[],{[Signe 'Humerus_Brachioradialis_o'];[Signe 'Forearm_Brachioradialis_i']},{};...
%     [Signe 'BicepsL'],624.3,0.1157,4,0.2723,0,{[Signe 'Thorax_BicepsL_o'];[Signe 'Thorax_BicepsL_via1'];[Signe 'Humerus_BicepsL_via2'];[Signe 'Humerus_BicepsL_via3'];[Signe 'Humerus_BicepsL_via4'];[Signe 'Humerus_BicepsL_via5'];[Signe 'Humerus_BicepsL_via6'];[Signe 'Humerus_Biceps_via7'];[Signe 'Forearm_Biceps_i']},{};... arm26.osim       
%     [Signe 'BicepsS'],435.56,0.1321,4,0.1923,0,{[Signe 'Thorax_BicepsS_o'];[Signe 'Thorax_BicepsS_via1'];[Signe 'Humerus_BicepsS_via2'];[Signe 'Humerus_BicepsS_via3'];[Signe 'Humerus_Biceps_via7'];[Signe 'Forearm_Biceps_i']},{};... arm26.osim    
%     [Signe 'Brachialis'],987.3,0.0858,4,0.0535,0,{[Signe 'Humerus_Brachialis_o'];[Signe 'Forearm_Brachialis']},{};...
%     [Signe 'ECRL'],304.9,[],[],[],[],{[Signe 'Humerus_ECRL_o'];[Signe 'Forearm_ECRL_i']},{};...
%     [Signe 'PronatorTeres'],566.2,[],[],[],[],{[Signe 'Humerus_PronatorTeres_o'];[Signe 'Forearm_PronatorTeres_i']},{};...
%     [Signe 'TricepsLg'],798.5,0.134,4,0.143,0.209,{[Signe 'Thorax_Triceps_o'];[Signe 'Humerus_TricepsLg_via1'];[Signe 'Humerus_Triceps_via2'];[Signe 'Humerus_Triceps_via3'];[Signe 'Humerus_Triceps_via4'];[Signe 'Forearm_Triceps_via5'];[Signe 'Forearm_Triceps_i']},{};...       arm26.osim    
%     [Signe 'TricepsLat'],624.3,0.114,4,0.098,0.157,{[Signe 'Humerus_TricepsLat_o'];[Signe 'Humerus_TricepsLat_via1'];[Signe 'Humerus_Triceps_via2'];[Signe 'Humerus_Triceps_via3'];[Signe 'Humerus_Triceps_via4'];[Signe 'Forearm_Triceps_via5'];[Signe 'Forearm_Triceps_i']},{};... arm26.osim   
%     [Signe 'TricepsMed'],624.3,0.114,4,0.098,0.157,{[Signe 'Humerus_TricepsMed_o'];[Signe 'Humerus_TricepsMed_via1'];[Signe 'Humerus_Triceps_via2'];[Signe 'Humerus_Triceps_via3'];[Signe 'Humerus_Triceps_via4'];[Signe 'Forearm_Triceps_via5'];[Signe 'Forearm_Triceps_i']},{};... arm26.osim     
    [Signe '_DELT1'],1218.9,0.0976,[],0.093,0.38397... EDIT
    [Signe '_DELT2'],1103.5,0.1078,[],0.1095,0.2618... EDIT
    [Signe '_DELT3'],201.6,0.1367,[],0.038,0.31416... EDIT
    [Signe '_SUPSP'],499.2,0.0682,[],0.0395,0.12217... EDIT
    [Signe '_INFSP'],1075.8,0.0755,[],0.0308,0.33161... EDIT
    [Signe '_SUBSC'],1306.9,0.0873,[],0.033,0.34907... EDIT
    [Signe '_TMIN'],269.5,0.0741,[],0.0713,0.41888... EDIT
    [Signe '_TMAJ'],144,0.1624,[],0.02,0.27925... EDIT
    [Signe '_PECM1'],444.3,0.1442,[],0.0028,0.29671... EDIT
    [Signe '_PECM2'],658.3,0.1385,[],0.089,0.45379... EDIT
    [Signe '_PECM3'],498.1,0.1385,[],0.132,0.43633... EDIT
    [Signe '_LAT1'],290.5,0.254,[],0.12,0.43633... EDIT
    [Signe '_LAT2'],317.5,0.2324,[],0.1765,0.33161... EDIT
    [Signe '_LAT3'],189,0.2789,[],0.1403,0.36652... EDIT
    [Signe '_CORB'],208.2,0.0932,[],0.097,0.47124... EDIT
    [Signe '_TRIlong'],771.8,0.134,[],0.143,0.20944... EDIT
    [Signe '_TRIlat'],717.5,0.1138,[],0.098,0.15708... EDIT
    [Signe '_TRImed'],717.5,0.1138,[],0.0908,0.15708... EDIT
    [Signe '_ANC'],283.2,0.027,[],0.018,0... EDIT
    [Signe '_SUP'],379.6,0.033,[],0.028,0... EDIT
    [Signe '_BIClong'],525.1,0.1157,[],0.2723,0... EDIT
    [Signe '_BICshort'],316.8,0.1321,[],0.1923,0... EDIT
    [Signe '_BRA'],1177.37,0.0858,[],0.0535,0... EDIT
    [Signe '_BRD'],276,0.1726,[],0.133,0... EDIT
    [Signe '_ECRL'],337.3,0.081,[],0.244,0... EDIT
    [Signe '_ECRB'],252.5,0.0585,[],0.2223,0.15708... EDIT
    [Signe '_ECU'],192.9,0.0622,[],0.2285,0.069813... EDIT
    [Signe '_FCR'],407.9,0.0628,[],0.244,0.05236... EDIT
    [Signe '_FCU'],479.8,0.0509,[],0.265,0.20944... EDIT
    [Signe '_PL'],101,0.0638,[],0.2694,0.069813... EDIT
    [Signe '_PT'],557.2,0.0492,[],0.098,0.17453... EDIT
    [Signe '_PQ'],284.7,0.0282,[],0.005,0.17453... EDIT
    [Signe '_FDSL'],75.3,0.0515,[],0.3386,0.087266... EDIT
    [Signe '_FDSR'],171.2,0.0736,[],0.328,0.069813... EDIT
    [Signe '_EDCL'],39.4,0.065,[],0.335,0.034907... EDIT
    [Signe '_EDCR'],109.2,0.0626,[],0.365,0.05236... EDIT
    [Signe '_EDCM'],94.4,0.0724,[],0.365,0.05236... EDIT
    [Signe '_stern_mast'],68.95,0.108,[],0.056123,... EDIT
    [Signe '_cleid_mast'],34.475,0.108,[],0.035198,... EDIT
    [Signe '_cleid_occ'],34.475,0.108,[],0.069467,... EDIT
    [Signe '_trap_cl'],77.6,0.084,[],0.11922,... EDIT
    [Signe '_trap_acr'],376.95,0.092,[],0.076582,... EDIT
    [Signe '_levator_scap'],76.3,0.113,[],0.021875,... EDIT
    [Signe '_rhomboid_min'],51,0.0986,[],0.015,0... EDIT
    [Signe '_rhomboid_maj'],383,0.1193,[],0.0423,0... EDIT
    [Signe '_serr_ant_1'],61,0.1635,[],0.025,0... EDIT
    [Signe '_serr_ant_2'],110,0.1667,[],0.009,0... EDIT
    [Signe '_serr_ant_3'],105,0.1622,[],0.007,0... EDIT
    [Signe '_serr_ant_4'],110,0.1289,[],0.011,0... EDIT
    [Signe '_serr_ant_5'],64,0.1259,[],0.011,0... EDIT
    [Signe '_serr_ant_6'],97,0.122,[],0.011,0... EDIT
    [Signe '_serr_ant_7'],47,0.1133,[],0.009,0... EDIT
    [Signe '_serr_ant_8'],76,0.0845,[],0.011,0... EDIT
    [Signe '_serr_ant_9'],79,0.08,[],0.007,0... EDIT
    [Signe '_serr_ant10'],63,0.066,[],0.005,0... EDIT
    [Signe '_serr_ant11'],23,0.0885,[],0.003,0... EDIT 
}];

% Structure generation
Muscles=[Muscles;struct('name',{s{:,1}}','f0',{s{:,2}}','l0',{s{:,3}}',...
    'Kt',{s{:,4}}','ls',{s{:,5}}','alpha0',{s{:,6}}','path',{s{:,7}}','wrap',{s{:,8}}')]; %#ok<CCAT1>
end