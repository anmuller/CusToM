function [OsteoArticularModel]= LegWithoutAnklePronation(OsteoArticularModel,k,Signe,Mass,AttachmentPoint)
% Addition of a leg model
%   This leg model contains 3 solids (thigh, shank and foot),
%   exhibits 3 dof for the hip, 1 dof for the knee and 1 dof for the
%   ankle
%
%	Based on:
%	- Damsgaard, M., Rasmussen, J., Christensen, S. T., Surma, E., & De Zee, M., 2006.
% 	Analysis of musculoskeletal systems in the AnyBody Modeling System. Simulation Modelling Practice and Theory, 14(8), 1100-1111.
%
%   INPUT
%   - OsteoArticularModel: osteo-articular model of an already existing
%   model (see the Documentation for the structure)
%   - k: homothety coefficient for the geometrical parameters (defined as
%   the subject size in cm divided by 180)
%   - Signe: side of the leg model ('R' for right side or 'L' for left side)
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
[OsteoArticularModel]= Thigh(OsteoArticularModel,k,Signe,Mass,AttachmentPoint);
[OsteoArticularModel]= Shank(OsteoArticularModel,k,Signe,Mass,[Signe 'Thigh_KneeJointNode']);
[OsteoArticularModel]= FootWithoutPronation(OsteoArticularModel,k,Signe,Mass,[Signe 'Shank_AnkleJointNode']);

end