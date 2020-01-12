function [Markers]=Marker_set1(varargin)
% Definition of the markers set used in ENSAM
%
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
s=[s;{'TMPD' 'RFHD' {'Off';'Off';'On'}; 'TMPG' 'LFHD' {'Off';'Off';'On'}; 'OCCD' 'RBHD' {'Off';'On';'On'}; 'OCCG' 'LBHD' {'Off';'Off';'On'}; ...
    'C7' 'C7' {'On';'On';'Off'}; 'MAN' 'CLAV' {'On';'On';'Off'}; ...
    'ACD' 'RSHO' {'Off';'Off';'On'}; 'ACG' 'LSHO' {'Off';'Off';'On'}; ...
    'EASD' 'RFWT' {'On';'Off';'On'}; 'EASG' 'LFWT' {'On';'Off';'On'}; 'EPSD' 'RBWT' {'On';'Off';'On'}; 'EPSG' 'LBWT' {'On';'Off';'On'}; ...
    'T8' 'T8' {'Off';'On';'Off'}; 'T12' 'T12' {'Off';'On';'Off'}; ...
    'CLAVD' 'CLAVD' {'On';'On';'On'}; 'CLAVG' 'CLAVG' {'On';'On';'On'}; ...
    }];

Side1={'D';'G'};
Side2={'R';'L'};
% Arm
for i=1:2
    s=[s;{['EL' Side1{i}] [Side2{i} 'RAD'] {'On';'On';'Off'}; ['EM' Side1{i}] [Side2{i} 'HUM'] {'Off';'Off';'Off'}; ...
        ['PSR' Side1{i}] [Side2{i} 'WRA'] {'Off';'Off';'Off'}; ['PSU' Side1{i}] [Side2{i} 'WRB'] {'Off';'On';'Off'}; ...
        ['MC2' Side1{i}] [Side2{i} 'CAR2'] {'Off';'Off';'Off'}; ['MC5' Side1{i}] [Side2{i} 'OHAND'] {'Off';'Off';'Off'}; ...
        }];
end

% Leg
for i=1:2
    s=[s;{['CL' Side1{i}] [Side2{i} 'KNE'] {'Off';'Off';'On'}; ['CM' Side1{i}] [Side2{i} 'KNI'] {'Off';'On';'On'}; ...
        ['ML' Side1{i}] [Side2{i} 'ANE'] {'Off';'On';'Off'}; ['MM' Side1{i}] [Side2{i} 'ANI'] {'Off';'Off';'Off'}; ...
        ['CAL' Side1{i}] [Side2{i} 'HEE'] {'Off';'On';'Off'}; ...
        ['MT1' Side1{i}] [Side2{i} 'TARI'] {'Off';'On';'On'}; ['MT5' Side1{i}] [Side2{i} 'TAR'] {'Off';'Off';'Off'}; ...
        }];
end

Markers=struct('name',{s{:,1}}','anat_position',{s{:,2}}','calib_dir',{s{:,3}}'); %#ok<CCAT1>

end