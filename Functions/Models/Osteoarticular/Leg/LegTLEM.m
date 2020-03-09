function [OsteoArticularModel]= LegTLEM(OsteoArticularModel,k,Signe,Mass,AttachmentPoint)
% Addition of a leg model
%   This leg model contains 3 solids (thigh, shank and foot),
%   exhibits 3 dof for the hip, 1 dof for the knee, 1 dof at the patella 
%   and 2 dof for the ankle
%
%   Based on:
%	V. Carbone et al., “TLEM 2.0 - A comprehensive musculoskeletal geometry dataset for subject-specific modeling of lower extremity,” J. Biomech., vol. 48, no. 5, pp. 734–741, 2015.
%
%   INPUT
%   - OsteoArticularModel: osteo-articular model of an already existing
%   model (see the Documentation for the structure)
%   - k: homothety coefficient for the geometrical parameters (defined as
%   the subject size in cm divided by 180)
%   - Signe: side of the thigh model ('R' for right side or 'L' for left side)
%   - Mass: mass of the solids
%   - AttachmentPoint: name of the attachment point of the model on the
%   already existing model (character string)
%   OUTPUT
%   - OsteoArticularModel: new osteo-articular model (see the Documentation
%   for the structure) 
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

[OsteoArticularModel]= Thigh_TLEM(OsteoArticularModel,k,Signe,Mass,AttachmentPoint);
[OsteoArticularModel]= Patella_TLEM(OsteoArticularModel,k,Signe,Mass,[Signe 'Thigh_PatellaFemurJointNode']);
[OsteoArticularModel]= Shank_TLEM(OsteoArticularModel,k,Signe,Mass,[Signe 'Thigh_KneeJointNode']);
[OsteoArticularModel]= Talus_TLEM(OsteoArticularModel,k,Signe,Mass,[Signe 'Shank_TalocruralJointNode']);
[OsteoArticularModel]= Foot_TLEM(OsteoArticularModel,k,Signe,Mass,[Signe 'Talus_SubtalarJointNode']);

end