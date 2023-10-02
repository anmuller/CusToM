function [coordinate] = Percent2coord(SegName_Table, table_coord, OsteoSegName, NextJoint, SegEndPosition, C_coords)
%%  This function is called when the position of the center of mass of the added mass is expressed as a percentage of the segment length, 
%   This function transforms that percentage into coordinates along the longitudinal axis (Y) of the segment frame
%
% INPUT
%   -seg_name       = name of the segment 
%   -table_coord    = table containing the percentage for x,y,z
%   -OsteoSegName   = BiomechanicalModel.OsteoArticularModel.name
%   -NextJoint      = BiomechanicalModel.OsteoArticularModel.b
%   -SegEndPosition = BiomechanicalModel.OsteoArticularModel.anat_position
%
% OUTPUT 
%   -coordinate : coordinates of the object with respect to the origin of 
%    the segment following the Y-axis

%% Initialization
table_row_seg = 0;
BiomechModel_row_joint = 0;
temp_coordinate = 0;
length = 0;
coordinate = 0;


%% list of segments and related joints (the following sequences have to be kept parallel)
listSegm2Process   = [{'PelvisSacrum'},     {'LowerTrunk'},...    
                       {'RHumerus'},         {'RForearm'},...
                       {'LHumerus'},         {'LForearm'},...    
                       {'RThigh'},           {'LThigh'},...
                       {'RShank'},           {'LShank'}, ...
                       {'Thorax'}] ;

listDistalJoints =   [{'LowerTrunk_J1'},    {'UpperTrunk_J1'},...   
                      {'RElbow_J1'},        {'RWrist_J1'},...
                      {'LElbow_J1'},        {'LWrist_J1'},...	 
                      {'RShank'},           {'LShank'}, ...     % (not the knee)
                      {'RAnkle_J1'},        {'LAnkle_J1'},...
                      {'ThoraxSkull_J1'}] ;

%% list of segment which do not end with a joint, and theire related distal tips
listExtr2Process =   [{'Skull'},            {'RHand'},         {'LHand'},           {'RFoot'},            {'LFoot'} ] ; 
listSegEnd =         [{'Skull_TopOfHead' }, {'RHand_EndNode'}, {'LHand_EndNode'},   {'RFoot_ToetipNode'}, {'LFoot_ToetipNode'}];   


%% Percentage -> Coordinate (in meters)
% Identify the segment name, the joint name, or the segment tip in the source 'Biomechanical model'.
    table_row_seg          = find (strcmp (SegName_Table, table_coord.Segment_Name)); % SegName_Table = 'LHand'
    temp_coordinate        = table_coord.added_c_y(table_row_seg);   

    if sum (strcmp (SegName_Table, listSegm2Process)) > 0
        numSegm2Process         = find (strcmp (SegName_Table, listSegm2Process)) ;
        BiomechModel_row_joint  = strcmp (listDistalJoints{numSegm2Process}, OsteoSegName) ;
        % Compute the coordinates of the added mass center of mass, in the segment frame         
        length                  = norm (cell2mat(NextJoint(BiomechModel_row_joint))'); 
        coordinate              = (temp_coordinate/100 * length) .*cell2mat(NextJoint(BiomechModel_row_joint))';
        if ~(strcmp (SegName_Table, 'PelvisSacrum') | strcmp (SegName_Table, 'LowerTrunk') | strcmp (SegName_Table, 'Thorax')) ;
            coordinate(:,2:3)     = -coordinate(:,2:3) ;
        end
        
    elseif sum (strcmp (SegName_Table, listExtr2Process)) > 0   % segment non terminé par un centre articulaire
        numExtr2Process        = find (strcmp (SegName_Table, listExtr2Process)) ; 
        BiomechModel_row_ext   = strcmp (listExtr2Process{numExtr2Process}, OsteoSegName) ;
        SegEndPosition_Row     = strcmp (listSegEnd{numExtr2Process}, SegEndPosition{BiomechModel_row_ext}(:,1) ) ;
        % Compute the coordinates of the added mass center of mass, in the segment frame 
        Pos_Dist_in_c          = cell2mat (SegEndPosition{BiomechModel_row_ext}(SegEndPosition_Row,2))' ;
        C_cord_unique          = C_coords{BiomechModel_row_ext}' ;
        length                 = norm (Pos_Dist_in_c  + C_cord_unique) ; 
        coordinate             = (temp_coordinate/100 * length) .*(Pos_Dist_in_c  + C_cord_unique)  ;
        coordinate(:,2)        = -coordinate(:,2:3) ;
    end