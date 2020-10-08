function [Muscles]=ArmMuscles(Muscles,Signe)
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
% Toolbox distributed under GPL 3.0 Licence
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
%     
       [Signe 'Anconeus'],350,0.027,[],[],[],{[Signe 'Humerus_Anconeus_o'];[Signe 'Humerus_Anconeus_VP1'];[Signe 'Ulna_Anconeus_VP2'];[Signe 'Ulna_Anconeus_i']},{};...
   [Signe 'FlexorCarpiUlnaris'],128.9,0.029,[],[],[],{[Signe 'Humerus_FlexorCarpiUlnaris_o'];[Signe 'Humerus_FlexorCarpiUlnaris_VP1'];[Signe 'Radius_FlexorCarpiUlnaris_VP2'];[Signe 'Radius_FlexorCarpiUlnaris_VP3'];[Signe 'Hand_FlexorCarpiUlnaris_VP4'];[Signe 'Hand_FlexorCarpiUlnaris_i']},{};...
    [Signe 'ExtensorCarpiUlnaris'],93.2,0.062,[],[],[],{[Signe 'Humerus_ExtensorCarpiUlnaris_o'];[Signe 'Humerus_ExtensorCarpiUlnaris_VP1'];[Signe 'Radius_ExtensorCarpiUlnaris_VP2'];[Signe 'Radius_ExtensorCarpiUlnaris_VP3'];[Signe 'Hand_ExtensorCarpiUlnaris_VP4'];[Signe 'Hand_ExtensorCarpiUlnaris_i']},{};...
   [Signe 'ExtensorCarpiRadialisLongus'],304.9,0.081,[],0.244,[],{[Signe 'Humerus_ExtensorCarpiRadialisLongus_o'];[Signe 'Humerus_ExtensorCarpiRadialisLongus_VP1'];[Signe 'Radius_ExtensorCarpiRadialisLongus_VP2'];[Signe 'Radius_ExtensorCarpiRadialisLongus_VP3'];[Signe 'Hand_ExtensorCarpiRadialisLongus_VP4'];[Signe 'Hand_ExtensorCarpiRadialisLongus_i']},{};...
    [Signe 'ExtensorCarpiRadialisBrevis'],100.5,0.059,[],0.2223,[],{[Signe 'Humerus_ExtensorCarpiRadialisBrevis_o'];[Signe 'Humerus_ExtensorCarpiRadialisBrevis_VP1'];[Signe 'Radius_ExtensorCarpiRadialisBrevis_VP2'];[Signe 'Radius_ExtensorCarpiRadialisBrevis_VP3'];[Signe 'Hand_ExtensorCarpiRadialisBrevis_VP4'];[Signe 'Hand_ExtensorCarpiRadialisBrevis_i']},{};...
  [Signe 'FlexorCarpiRadialis'],74,0.063,[],[],[],{[Signe 'Humerus_FlexorCarpiRadialis_o'];[Signe 'Humerus_FlexorCarpiRadialis_VP1'];[Signe 'Radius_FlexorCarpiRadialis_VP2'];[Signe 'Radius_FlexorCarpiRadialis_VP3'];[Signe 'Hand_FlexorCarpiRadialis_VP4'];[Signe 'Hand_FlexorCarpiRadialis_i']},{};...
    [Signe 'PronatorQuadratus'],75.5,0.028,[],[],[],{[Signe 'Radius_PronatorQuadratus_o'];[Signe 'Radius_PronatorQuadratus_VP1'];[Signe 'Ulna_PronatorQuadratus_VP2'];[Signe 'Ulna_PronatorQuadratus_i']},{};...
    [Signe 'SupinatorBrevis'],476,0.033,[],[],[],{[Signe 'Radius_SupinatorBrevis_o'];[Signe 'Radius_SupinatorBrevis_VP1'];[Signe 'Ulna_SupinatorBrevis_VP2'];[Signe 'Ulna_SupinatorBrevis_i']},{};...
  [Signe 'Brachialis'],987.3,0.105,4,0.086,0,{[Signe 'Humerus_Brachialis_o'];[Signe 'Humerus_Brachialis_VP1'];[Signe 'Ulna_Brachialis_VP2'];[Signe 'Ulna_Brachialis_i']},{};...
    [Signe 'Brachioradialis'],261.3,0.173,[],[],[],{[Signe 'Humerus_Brachioradialis_o'];[Signe 'Humerus_Brachioradialis_VP1'];[Signe 'Radius_Brachioradialis_VP2'];[Signe 'Radius_Brachioradialis_i']},{};...
    [Signe 'PronatorTeres'],566.2,0.049,[],[],[],{[Signe 'Humerus_PronatorTeres_o'];[Signe 'Humerus_PronatorTeres_VP1'];[Signe 'Radius_PronatorTeres_VP2'];[Signe 'Radius_PronatorTeres_i']},{};...
    [Signe 'TricepsLat'],624.3,0.114,4,0.098,0.157,{[Signe 'Humerus_TricepsLat_o'];[Signe 'Humerus_TricepsLat_VP1'];[Signe 'Ulna_TricepsLat_VP2'];[Signe 'Ulna_TricepsLat_i']},{};... 
    [Signe 'TricepsMed'],624.3,0.114,4,0.098,0.157,{[Signe 'Humerus_TricepsMed_o'];[Signe 'Humerus_TricepsMed_VP1'];[Signe 'Ulna_TricepsMed_VP2'];[Signe 'Ulna_TricepsMed_i']},{};... arm26.osim
    [Signe 'PalmarisLongus'],26.7,0.064,4,0.098,0.157,{[Signe 'Humerus_PalmarisLongus_o'];[Signe 'Humerus_PalmarisLongus_VP1'];[Signe 'Radius_PalmarisLongus_VP2'];[Signe 'Radius_PalmarisLongus_VP3'];[Signe 'Hand_PalmarisLongus_VP4'];[Signe 'Hand_PalmarisLongus_i']},{};...

    
    
    
    }];

% Structure generation
Muscles=[Muscles;struct('name',{s{:,1}}','f0',{s{:,2}}','l0',{s{:,3}}',...
    'Kt',{s{:,4}}','ls',{s{:,5}}','alpha0',{s{:,6}}','path',{s{:,7}}','wrap',{s{:,8}}')]; %#ok<CCAT1>

end