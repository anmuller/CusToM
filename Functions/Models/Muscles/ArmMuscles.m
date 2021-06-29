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
    [Signe 'Brachioradialis'],261.3,[],[],[],[],{[Signe 'Humerus_Brachioradialis_o'];[Signe 'Forearm_Brachioradialis_i']},{};...
    [Signe 'BicepsL'],624.3,0.1157,4,0.2723,0,{[Signe 'Thorax_BicepsL_o'];[Signe 'Thorax_BicepsL_via1'];[Signe 'Humerus_BicepsL_via2'];[Signe 'Humerus_BicepsL_via3'];[Signe 'Humerus_BicepsL_via4'];[Signe 'Humerus_BicepsL_via5'];[Signe 'Humerus_BicepsL_via6'];[Signe 'Humerus_Biceps_via7'];[Signe 'Forearm_Biceps_i']},{};... arm26.osim       
    [Signe 'BicepsS'],435.56,0.1321,4,0.1923,0,{[Signe 'Thorax_BicepsS_o'];[Signe 'Thorax_BicepsS_via1'];[Signe 'Humerus_BicepsS_via2'];[Signe 'Humerus_BicepsS_via3'];[Signe 'Humerus_Biceps_via7'];[Signe 'Forearm_Biceps_i']},{};... arm26.osim    
    [Signe 'Brachialis'],987.3,0.0858,4,0.0535,0,{[Signe 'Humerus_Brachialis_o'];[Signe 'Forearm_Brachialis']},{};...
    [Signe 'ECRL'],304.9,[],[],[],[],{[Signe 'Humerus_ECRL_o'];[Signe 'Forearm_ECRL_i']},{};...
    [Signe 'PronatorTeres'],566.2,[],[],[],[],{[Signe 'Humerus_PronatorTeres_o'];[Signe 'Forearm_PronatorTeres_i']},{};...
    [Signe 'TricepsLg'],798.5,0.134,4,0.143,0.209,{[Signe 'Thorax_Triceps_o'];[Signe 'Humerus_TricepsLg_via1'];[Signe 'Humerus_Triceps_via2'];[Signe 'Humerus_Triceps_via3'];[Signe 'Humerus_Triceps_via4'];[Signe 'Forearm_Triceps_via5'];[Signe 'Forearm_Triceps_i']},{};...       arm26.osim    
    [Signe 'TricepsLat'],624.3,0.114,4,0.098,0.157,{[Signe 'Humerus_TricepsLat_o'];[Signe 'Humerus_TricepsLat_via1'];[Signe 'Humerus_Triceps_via2'];[Signe 'Humerus_Triceps_via3'];[Signe 'Humerus_Triceps_via4'];[Signe 'Forearm_Triceps_via5'];[Signe 'Forearm_Triceps_i']},{};... arm26.osim   
    [Signe 'TricepsMed'],624.3,0.114,4,0.098,0.157,{[Signe 'Humerus_TricepsMed_o'];[Signe 'Humerus_TricepsMed_via1'];[Signe 'Humerus_Triceps_via2'];[Signe 'Humerus_Triceps_via3'];[Signe 'Humerus_Triceps_via4'];[Signe 'Forearm_Triceps_via5'];[Signe 'Forearm_Triceps_i']},{};... arm26.osim     
    }];

% Structure generation
Muscles=[Muscles;struct('name',{s{:,1}}','f0',{s{:,2}}','l0',{s{:,3}}',...
    'Kt',{s{:,4}}','ls',{s{:,5}}','alpha0',{s{:,6}}','path',{s{:,7}}','wrap',{s{:,8}}')]; %#ok<CCAT1>

end