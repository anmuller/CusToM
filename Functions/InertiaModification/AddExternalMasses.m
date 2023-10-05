function [List_BiomechanicalModels] = AddExternalMasses (table_path, model_path)
% Add point masses to an existing 'Biomechanical model', to account for or simulate the presence of objects (heavy cloth, bag) 
% attached to body segments
%   - Each segment of the 'Biomechanical model' can be assigned an additional point mass
%   - Several 'Biomechanical models' can be created from the same source 'Biomechanical Model'
%     to add various patterns of additional masses (e.g. light then heavy backpacks)
%   The source 'Biomechanical model' and the new 'Biomechanical models' are stored in a single structure
% TO DO: implementation for more complex ‘Biomechanical models’ (e.g. with forearm pronosupination)
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors: Aurélie Tomezzoli and Aurélien Schuster
%________________________________________________________
%
% INPUT
%   BiomechanicalModel.m 
%   List of masse(s) to be added to the 'Biomechanical model' (Excel file). Information needed (see template):
%   - Name_model = name of the model(s) to be creates
%   - Segment
%   - Coordinates (x, y, z) of the added mass center or 
%     '%' of the length of the segment
%           -starting from the segment root for limbs
%           -starting from the segment lower extremity for the trunc
%           -set positive values if the additional mass is located on the segment
%   - Mass
%
% OUTPUT
%   BiomechanicalModels stored in a structure, with the new BSIP (Body Segment Inertial Parameters) 
%   - List_BiomechanicalModels                


%% LOAD the initial Biomechanical Parameters
%  and LOAD THE Excel SIMULATED EXTERNAL MASSES DATA FILE

load(model_path);

OsteoSegName    = {BiomechanicalModel.OsteoArticularModel.name};
NextJoint       = {BiomechanicalModel.OsteoArticularModel.b} ;
SegEndPosition  = {BiomechanicalModel.OsteoArticularModel.anat_position} ;
C_coords        = {BiomechanicalModel.OsteoArticularModel.c} ;
[T] = GetExternalMasses(table_path, OsteoSegName, NextJoint, SegEndPosition, C_coords) ;    % T = table of objects (masses) to be added

%% Extract the list of 'Biomechanical models' to be created, then creatte a structure to store them
BiomechanicalModels_names = [unique(T.New_Model_Name) ; 'BiomechanicalModel_ARCHIVE'] ;
List_BiomechanicalModels = struct() ;
List_BiomechanicalModels = struct('Names', [BiomechanicalModels_names], ...
                                  'BiomechanicalModel', BiomechanicalModel, ...
                                  'Results', struct()) ;


%% Prepare THE NEW MODELS
% for each ligne of the Table (T) of masses to add, 
%   find the line number of the segment in the osteoarticular model AND the line number of the final model
for T_ind_segment = 1:size (T, 1)    
    OsteoModel_ind_segment = find (strcmp (T.Segment_Name{T_ind_segment},   [{BiomechanicalModel.OsteoArticularModel.name}])) ;
    List_Model_ind         = find (strcmp (T.New_Model_Name{T_ind_segment}, [{List_BiomechanicalModels.Names}] )) ;
    T.Segment_Name{T_ind_segment}
   if ~isempty (OsteoModel_ind_segment) ;


    % Compute the NEW BSIP (mass, center of mass, Inertia)
    m       = [];
    m       = BiomechanicalModel.OsteoArticularModel(OsteoModel_ind_segment).m ;
    added_m = []; 
    added_m = T.added_m(T_ind_segment) ; 

    [NEW_m, NEW_c, NEW_I] = ComputeInertial (m, added_m, ...
                                    BiomechanicalModel.OsteoArticularModel(OsteoModel_ind_segment).c, ...
                                    T.added_c{T_ind_segment}, ...
                                    BiomechanicalModel.OsteoArticularModel(OsteoModel_ind_segment).I) ;


     % Compute new MARKERS and MUSCLES coordinates (related to NEW_c instead of *.c)
      if ~isempty(BiomechanicalModel.Muscles)
        list_model_muscles = cellfun(@char,sym2cell(unique(cell2sym({BiomechanicalModel.Muscles(:).path}'))),'UniformOutput',false);
        muscle_model_ind = find(ismember(BiomechanicalModel.OsteoArticularModel(OsteoModel_ind_segment).anat_position(:,1), list_model_muscles));
      else
        muscle_model_ind = [];
      end
    mk_model_ind = find (ismember (BiomechanicalModel.OsteoArticularModel(OsteoModel_ind_segment).anat_position(:,1), [{BiomechanicalModel.Markers.anat_position}])) ;
    list_ind = [mk_model_ind;muscle_model_ind];

      if ~isempty ([BiomechanicalModel.OsteoArticularModel(OsteoModel_ind_segment).anat_position{list_ind, 2}] )
        NEW_anat_position = [BiomechanicalModel.OsteoArticularModel(OsteoModel_ind_segment).anat_position{list_ind, 2}]...
        + BiomechanicalModel.OsteoArticularModel(OsteoModel_ind_segment).c - NEW_c ;
        NEW_anat_position_cells = mat2cell (NEW_anat_position, 3, repelem(1, size (list_ind,1) ))' ;
        List_BiomechanicalModels(List_Model_ind).BiomechanicalModel.OsteoArticularModel(OsteoModel_ind_segment).anat_position(list_ind,2) = NEW_anat_position_cells  ;
      end  
     %% Store Biomechanical models
   List_BiomechanicalModels(List_Model_ind).BiomechanicalModel.OsteoArticularModel(OsteoModel_ind_segment).m             = NEW_m ;
   List_BiomechanicalModels(List_Model_ind).BiomechanicalModel.OsteoArticularModel(OsteoModel_ind_segment).c             = NEW_c ;
   List_BiomechanicalModels(List_Model_ind).BiomechanicalModel.OsteoArticularModel(OsteoModel_ind_segment).I             = NEW_I ;
     
   end
end


