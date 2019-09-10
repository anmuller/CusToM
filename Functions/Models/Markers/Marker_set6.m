function [Markers]=Marker_set6(varargin)
% Definition of the markers set used in the IRSST
%
%   INPUT
%   - nb_markers_hand: number of markers used on each hand
%   OUTPUT
%   - Markers: set of markers (see the Documentation for the structure) 

s=cell(0);

% Trunk
s=[s;{'STRN' 'STRN' {'Off';'On';'Off'};'Manubrium' 'CLAV' {'On';'On';'Off'};'T12_C' 'T12' {'Off';'On';'Off'}; 'L5' 'Pelvis_L5JointNode' {'Off';'Off';'Off'};...
    'C7_C' 'C7' {'On';'On';'Off'};'EAV_D' 'REAV' {'On';'Off';'On'};'EAV_G' 'LEAV' {'On';'Off';'On'};...
    'EAR_D' 'REAR' {'On';'Off';'On'};'EAR_G' 'LEAR' {'On';'Off';'On'};...
    'EIASD' 'RFWT' {'On';'Off';'On'};'EIASG' 'LFWT' {'On';'Off';'On'};'EPISD' 'RBWT' {'On';'Off';'On'};'EPISG' 'LBWT' {'On';'Off';'On'};...
    'NEZ' 'NEZ' {'Off';'Off';'Off'};'NUQUE' 'NUQUE' {'On';'On';'Off'};'VERTEX' 'VERTEX' {'Off';'On';'On'}}];

Side={'R';'L'};
Side2={'D';'G'};
% Leg
for i=1:2
    Signe=Side{i};
    Signe2=Side2{i};
    s=[s;{['GEX_' Signe2] [Signe 'KNE'] {'Off';'Off';'Off'};['MA_E' Signe2] [Signe 'ANE'] {'Off';'On';'Off'};['MA_I' Signe2] [Signe 'ANI'] {'Off';'Off';'Off'};...
        ['GIN_' Signe2] [Signe 'KNI'] {'Off';'On';'On'};['TAL' Signe2 'A'] [Signe 'HEE'] {'Off';'On';'Off'};['PIEX' Signe2] [Signe 'TAR'] {'Off';'On';'On'};...
        ['BP__' Signe2] [Signe 'TOE'] {'Off';'On';'Off'};...
        ['PIIN' Signe2] [Signe 'TARI'] {'Off';'On';'On'};...
        }]; %#ok<AGROW>
end


% Arm
for i=1:2
    Signe=Side{i};
    Signe2=Side2{i};
    s=[s;{['EPI_' Signe2] [Signe 'HUM'] {'Off';'Off';'Off'};['EPE_' Signe2] [Signe 'RAD'] {'On';'On';'Off'};...
        ['PEX_' Signe2] [Signe 'WRA'] {'Off';'Off';'Off'};['PIN_' Signe2] [Signe 'WRB'] {'Off';'On';'Off'}}]; %#ok<AGROW>
end

Markers=struct('name',{s{:,1}}','anat_position',{s{:,2}}','calib_dir',{s{:,3}}'); %#ok<CCAT1>

end