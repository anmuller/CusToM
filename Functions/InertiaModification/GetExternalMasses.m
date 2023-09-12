function [T_clean] = GetExternalMasses(table_path, OsteoSegName, NextJoint, SegEndPosition) 

%% Extract data related to the objects added to body segments, to compute the segments nex inertia matrix
%
% INPUT
%   - table_path : path to reach the Excel file containing the objects
%   properties
%   - model_path : path to reach the 'BiomechanicalModel'
%   - OsteoSegName : {BiomechanicalModel.OsteoArticularModel.name}
%   - NextJoint : {BiomechanicalModel.OsteoArticularModel.b}
%   - SegEndPosition : for segments which do not end with a joint
% OUTPUT 
%   -T_clean : Table containing the objects data associated to the segments, after reformatting 


%% Loading of the excel file and the 'Biomechanical model'
T = readtable(table_path); 

%% Checks
% 1) Do the segments names match any segment name of the source 'Biomechanical model' ?
% 2) Are there any joints ?
% 3) Are the added masses different from zero ?

% Initialization
T_clean = cell(0);
i_clean = 0;
i_doublon = 1;
c=0;

% Checking loop
for i=1:size(T,1)
    nom = char(T.Segment_Name(i));                     % Rename the segment name to check
    if strcmp(T.Y_unit(i),'Percentage')==1             % Function which transform % to coord. (in meters) 
        coordinate = Percent2coord(nom, T(i,:), OsteoSegName, NextJoint, SegEndPosition);
        T.added_c_y(i) = coordinate;
    end 
    for j=1:size(OsteoSegName,2)
        tf = strcmp(T.Segment_Name(i),char(OsteoSegName(j)));
        c=c+tf;
    end                                                % If c=1 so this segment is in the model (1)
    if c ~= 1 || strcmp(nom(end-2:end-1),'_J')==1      % Otherwise if the name finish by '_Jn°x', this certainly is a joint (2)
        w = [nom, ' ligne ', char(string(i)), ' is not in the model, there is a spelling error or it is a joint. So it will not be added to the table.'];
        warning(w)
    else                                               % If the name is correct and the segment is not a joint, we add in a clean table the corresponding row
        added_c = cell(0);                             % Center of mass coordinates for each objects
        added_c{i,1} = [T.added_c_x(i); T.added_c_y(i); T.added_c_z(i)];
        i_clean = i_clean + 1;
        T_clean{i_clean,1}=T.New_Model_Name(i);        % Name of the new 'Biomechanical model'
        T_clean{i_clean,2}=T.Segment_Name(i);          % Name of the segment 
        T_clean{i_clean,3}=T.Object_Name(i);           % Name of the object to add to the segment
        T_clean{i_clean,4}=added_c(i);                 % Coordinates of the object center of mass in the segment reference frame  
        T_clean{i_clean,5}=T.added_m(i);               % Mass of the object added
    end
    c=0;
    if T.added_m(i) == 0                               %Even if the mass is equal to zero (3), the object will be written into T_clean.
        w = [nom, ' ligne ', char(string(i)), ' is a segment without mass. It will be displayed in the table.'];
        warning(w)
    end
end

T_clean = cell2table(T_clean);
T_clean.Properties.VariableNames(1:3) = T.Properties.VariableNames(1:3);
T_clean.Properties.VariableNames(5)   = T.Properties.VariableNames(7);
T_clean.Properties.VariableNames(4)   = {'added_c'};     %Naming of the table

% Are there empty cells ?
[idx,idy] = find(cellfun('isempty',table2cell(T_clean)));
if ~isempty([idx,idy])
    w = ['The cell row n°', char(string(idx)), ' column n°', char(string(idy)), ' is empty.'];
    warning(w)
end






