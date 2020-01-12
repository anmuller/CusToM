function [Markers]=Marker_set2(nb_markers_hand)
% Definition of the markers set used in the M2S
%
%   INPUT
%   - nb_markers_hand: number of markers used on each hand
%   OUTPUT
%   - Markers: set of markers (see the Documentation for the structure) 
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
s=cell(0);

% Trunk
s=[s;{'STRN' 'STRN' {'Off';'On';'Off'};'CLAV' 'CLAV' {'On';'Off';'Off'};'T10' 'T10' {'Off';'On';'Off'};...
    'C7' 'C7' {'On';'On';'Off'};'RSHO' 'RSHO' {'On';'Off';'On'};'LSHO' 'LSHO' {'On';'Off';'On'};'RFWT' 'RFWT' {'On';'Off';'On'};...
    'LFWT' 'LFWT' {'On';'Off';'On'};'RBWT' 'RBWT' {'On';'Off';'On'};'LBWT' 'LBWT' {'On';'Off';'On'};...
    'RFHD' 'RFHD' {'Off';'Off';'On'};'LFHD' 'LFHD' {'Off';'Off';'On'};'RBHD' 'RBHD' {'Off';'On';'On'};'LBHD' 'LBHD' {'Off';'On';'On'}}];

Side={'R';'L'};
% Leg
for i=1:2
    Signe=Side{i};
    s=[s;{[Signe 'KNE'] [Signe 'KNE'] {'Off';'Off';'Off'};[Signe 'ANE'] [Signe 'ANE'] {'Off';'On';'Off'};[Signe 'ANI'] [Signe 'ANI'] {'Off';'Off';'Off'};...
        [Signe 'KNI'] [Signe 'KNI'] {'Off';'On';'On'};[Signe 'HEE'] [Signe 'HEE'] {'Off';'On';'Off'};[Signe 'TAR'] [Signe 'TAR'] {'Off';'On';'On'};...
        [Signe 'TOE'] [Signe 'TOE'] {'Off';'Off';'Off'};...
        [Signe 'TARI'] [Signe 'TARI'] {'Off';'On';'On'}}];
%         }]; %#ok<AGROW>
end


% Arm
for i=1:2
    Signe=Side{i};
    s=[s;{[Signe 'HUM'] [Signe 'HUM'] {'Off';'Off';'Off'};[Signe 'RAD'] [Signe 'RAD'] {'On';'On';'Off'};...
        [Signe 'WRA'] [Signe 'WRA'] {'Off';'Off';'Off'};[Signe 'WRB'] [Signe 'WRB'] {'Off';'On';'Off'}}]; %#ok<AGROW>
    eval(['s=Hand_markers_' num2str(nb_markers_hand) '(s,Signe);'])
end

Markers=struct('name',{s{:,1}}','anat_position',{s{:,2}}','calib_dir',{s{:,3}}'); %#ok<CCAT1>

end
function [s]=Hand_markers_1(s,Signe)   %#ok<DEFNU>
% 1 marker on the hand
    s=[s;{[Signe 'CAR'] [Signe 'CAR1'] {'Off';'Off';'Off'}}];   
end
function [s]=Hand_markers_2(s,Signe)   %#ok<DEFNU>  
% 2 markers on the hand
    s=[s;{[Signe 'CAR'] [Signe 'CAR2'] {'Off';'Off';'Off'};[Signe 'OHAND'] [Signe 'OHAND'] {'Off';'Off';'Off'}}];    
end    
function [s]=Hand_markers_3(s,Signe)   %#ok<DEFNU>  
% 3 markers on the hand
    s=[s;{[Signe 'CAR'] [Signe 'CAR3'] {'Off';'Off';'Off'};[Signe 'IDX3'] [Signe 'IDX3'] {'Off';'Off';'Off'};[Signe 'PNK3'] [Signe 'PNK3'] {'Off';'Off';'Off'}}];    
end