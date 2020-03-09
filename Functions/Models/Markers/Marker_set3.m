function [Markers]=Marker_set3(nb_markers_hand)
% Definition of the markers set used in the M2S with VR glasses
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
s=cell(0);

% Trunk
s=[s;{'STRN' 'STRN' {'Off';'On';'Off'};'CLAV' 'CLAV' {'On';'Off';'Off'};'T10' 'T10' {'Off';'On';'Off'};...
    'C7' 'C7' {'On';'On';'Off'};'RSHO' 'RSHO' {'On';'Off';'On'};'LSHO' 'LSHO' {'On';'Off';'On'};'RFWT' 'RFWT' {'On';'Off';'On'};...
    'LFWT' 'LFWT' {'On';'Off';'On'};'RBWT' 'RBWT' {'On';'Off';'On'};'LBWT' 'LBWT' {'On';'Off';'On'};...
%     'RFHD' 'RFHD' {'Off';'Off';'On'};'LFHD' 'LFHD' {'Off';'Off';'On'};'RBHD' 'RBHD' {'Off';'On';'On'};'LBHD' 'LBHD' {'Off';'On';'On'};...
    'GLASS1' 'GLASS1' {'On';'Off';'On'};'GLASS2' 'GLASS2' {'On';'Off';'On'};'GLASS3' 'GLASS3' {'On';'Off';'On'};'GLASS4' 'GLASS4' {'On';'Off';'On'}}...
    ];



    Signe='R';
    s=[s;{[Signe 'HUM'] [Signe 'HUM'] {'Off';'Off';'Off'};[Signe 'RAD'] [Signe 'RAD'] {'On';'On';'Off'};...
        [Signe 'WRA'] [Signe 'WRA'] {'Off';'Off';'Off'};[Signe 'WRB'] [Signe 'WRB'] {'Off';'On';'Off'};... %#ok<AGROW>])
        [Signe 'CAR'] [Signe 'CAR1'] {'Off';'Off';'Off'};[Signe '500G1'] [Signe '500G1'] {'Off';'Off';'Off'};[Signe '500G2'] [Signe '500G2'] {'Off';'Off';'Off'};[Signe '500G3'] [Signe '500G3'] {'Off';'Off';'Off'};[Signe '500G4'] [Signe '500G4'] {'Off';'Off';'Off'};[Signe '1000G1'] [Signe '1000G1'] {'Off';'Off';'Off'};[Signe '1000G2'] [Signe '1000G2'] {'Off';'Off';'Off'};[Signe '1000G3'] [Signe '1000G3'] {'Off';'Off';'Off'};[Signe '1000G4'] [Signe '1000G4'] {'Off';'Off';'Off'}}];  

Markers=struct('name',{s{:,1}}','anat_position',{s{:,2}}','calib_dir',{s{:,3}}'); %#ok<CCAT1>

end

     



function [s]=Hand_markers_1(s,Signe)   %#ok<DEFNU>
% 1 marqueur sur la main
    s=[s;{[Signe 'CAR'] [Signe 'CAR1'] {'Off';'Off';'Off'}}];   
end
function [s]=Hand_markers_2(s,Signe)   %#ok<DEFNU>  
% 2 marqueurs sur la main
    s=[s;{[Signe '500G2'] [Signe '500G2'] {'Off';'Off';'Off'}}];    
end    
function [s]=Hand_markers_3(s,Signe)   %#ok<DEFNU>  
% 3 marqueurs sur la main
s=[s;{[Signe '1000G1'] [Signe '1000G1'] {'Off';'Off';'Off'}}];    
end