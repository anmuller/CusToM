function [] = CreateVisuals(table_path,List_BiomechanicalModels)

%% Creation of visuals

% Bring external masses coordinates

OsteoSegName    = {List_BiomechanicalModels(end).BiomechanicalModel.OsteoArticularModel.name};
NextJoint       = {List_BiomechanicalModels(end).BiomechanicalModel.OsteoArticularModel.b} ;
SegEndPosition  = {List_BiomechanicalModels(end).BiomechanicalModel.OsteoArticularModel.anat_position} ;
C_coords        = {List_BiomechanicalModels(end).BiomechanicalModel.OsteoArticularModel.c} ;
[T] = GetExternalMasses(table_path, OsteoSegName, NextJoint, SegEndPosition, C_coords) ;    % T = table of objects (masses) to be added
coord_objets = cell(size(T,1),1);
for i = 1:size(T,1)
    coord_objets(i) = T.added_c(i);
end

%% Bring names of proximal and distal points

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

listExtr2Process =   [{'Skull'},            {'RHand'},         {'LHand'},           {'RFoot'},            {'LFoot'} ] ; 

listSegEnd =         [{'Skull_TopOfHead' }, {'RHand_EndNode'}, {'LHand_EndNode'},   {'RFoot_ToetipNode'}, {'LFoot_ToetipNode'}];   

% Bring segment's distal point coordinates
% Bring segment's geometric center coordinates
% Bring segment's new barycenter coordinates

T = readtable(table_path); % we bring raw table !

coord_distale = cell(size(T,1),1);
coord_centre  = cell(size(T,1),1);
coord_barycentre = cell(size(T,1),1);

for i = 1:size(T,1)
    
    index_modele  = find(strcmp({List_BiomechanicalModels.Names}, T.New_Model_Name(i)));
    nom_segment   = T.Segment_Name(i);

    if ismember(cell2mat(nom_segment),listSegm2Process)

        ind_liste = strcmp(listSegm2Process,nom_segment);
        nom_distale = listDistalJoints(ind_liste);
        ligne_segment = find(strcmp({List_BiomechanicalModels(index_modele).BiomechanicalModel.OsteoArticularModel.name}, nom_segment));
        ligne_distale = find(strcmp({List_BiomechanicalModels(index_modele).BiomechanicalModel.OsteoArticularModel.name}, nom_distale));
        coord_distale(i) = {List_BiomechanicalModels(index_modele).BiomechanicalModel.OsteoArticularModel(ligne_distale).b}; % to have coordinates of distal joint
        coord_centre(i) = {List_BiomechanicalModels(end).BiomechanicalModel.OsteoArticularModel(ligne_segment).c}; % to have coordinates of segment's geometric center of non modified models
        coord_barycentre(i) = {List_BiomechanicalModels(index_modele).BiomechanicalModel.OsteoArticularModel(ligne_segment).c}; % to have coordinates on the new segment's barycenter

    elseif ismember(nom_segment,listExtr2Process)

        ligne_segment = find(strcmp({List_BiomechanicalModels(index_modele).BiomechanicalModel.OsteoArticularModel.name}, nom_segment));
        coord_centre(i) = {List_BiomechanicalModels(end).BiomechanicalModel.OsteoArticularModel(ligne_segment).c}; % to have coordinates of segment's geometric center of non modified models
        coord_barycentre(i) = {List_BiomechanicalModels(index_modele).BiomechanicalModel.OsteoArticularModel(ligne_segment).c}; % to have coordinates on the new segment's barycenter
        champs_anat_position = List_BiomechanicalModels(end).BiomechanicalModel.OsteoArticularModel(ligne_segment).anat_position();
        ligne_segment_liste = strcmp (nom_segment,listExtr2Process);
        nom_extremite = listSegEnd(ligne_segment_liste);
        ligne_extremite = strcmp(nom_extremite,champs_anat_position(:,1));
        coord_distale(i) = List_BiomechanicalModels(end).BiomechanicalModel.OsteoArticularModel(ligne_segment).anat_position(ligne_extremite,2);
    
    end
end


% We plot a 3D plot containing the modified segment with the added mass for each models (each raw of the table)

for ind = 1:size(T,1)

    figure; hold on;
    % Plot a line between [0 0 0] and coord_distale
    quiver3(0, 0, 0, coord_distale{ind}(1), coord_distale{ind}(2), coord_distale{ind}(3), 'b');
    text(coord_distale{ind}(1)/3, coord_distale{ind}(2)/3, coord_distale{ind}(3)/3, cell2mat(T.Segment_Name(ind)));
    % Plot a sphere at coord_distale
    scatter3(coord_distale{ind}(1), coord_distale{ind}(2), coord_distale{ind}(3), 'b', 'filled');
    % Plot a sphere at coord_centre
    scatter3(coord_centre{ind}(1), coord_centre{ind}(2), coord_centre{ind}(3), 'g', 'filled');
    text(coord_centre{ind}(1), coord_centre{ind}(2), coord_centre{ind}(3), 'centre geométrique');
    % Plot a sphere at coord_barycenter and disp the text "barycenter"
    scatter3(coord_barycentre{ind}(1), coord_barycentre{ind}(2), coord_barycentre{ind}(3), 'b', 'filled');
    text(coord_barycentre{ind}(1), coord_barycentre{ind}(2), coord_barycentre{ind}(3), 'barycentre');
    % Plot a sphere at coord_objets and disp the text "objet"
    scatter3(coord_objets{ind}(1), coord_objets{ind}(2), coord_objets{ind}(3), 'm', 'filled');
    text(coord_objets{ind}(1), coord_objets{ind}(2), coord_objets{ind}(3), cell2mat(T.Object_Name(ind)));

    axis equal;
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    grid on;
    title(join(['Segment', T.Segment_Name{ind}, "avec l'objet", T.Object_Name{ind}, 'du modèle', T.New_Model_Name{ind}]));

end


end