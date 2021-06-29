function [OsteoArticularModel]= UpperTrunkShoulder(OsteoArticularModel,k,Mass,AttachmentPoint)
% Addition of an upper trunk model
%   This upper trunk model contains 5 solids (thorax, clavicles, and
%   scapulae), exhibits 3 dof for lower trunk / upper trunk joint, 3
%   dof for each upper trunk / clavicle joint. It shall be used with the
%   shoulder model of upper limbs
%
%	Based on:
%	- Damsgaard, M., Rasmussen, J., Christensen, S. T., Surma, E., & De Zee, M., 2006.
% 	Analysis of musculoskeletal systems in the AnyBody Modeling System. Simulation Modelling Practice and Theory, 14(8), 1100-1111.
%   - Puchaud et al. 2019
%
%   INPUT
%   - OsteoArticularModel: osteo-articular model of an already existing
%   model (see the Documentation for the structure)
%   - k: homothety coefficient for the geometrical parameters (defined as
%   the subject size in cm divided by 180)
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

% Thorax solid
[OsteoArticularModel] = Thorax_Shoulder(OsteoArticularModel,k,Mass,AttachmentPoint);

% Right-sided shoulder solids
[OsteoArticularModel] = Clavicle_Shoulder(OsteoArticularModel,k,Mass,'R','Thorax_scjJointRightNode');
[OsteoArticularModel] = Scapula_Shoulder(OsteoArticularModel,k,Mass,'R','R_Thorax_EllipsoidNode');

% Left-sided shoulder solids
[OsteoArticularModel] = Clavicle_Shoulder(OsteoArticularModel,k,Mass,'L','Thorax_scjJointLeftNode');
[OsteoArticularModel] = Scapula_Shoulder(OsteoArticularModel,k,Mass,'L','L_Thorax_EllipsoidNode');
