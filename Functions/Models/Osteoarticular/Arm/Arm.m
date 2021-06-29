function [OsteoArticularModel]= Arm(OsteoArticularModel,k,Signe,Mass,AttachmentPoint)
% Addition of an arm model
%   This arm model contains 3 solids (upper arm, forearm and hand),
%   exhibits 3 dof for the shoulder, 2 dof for the elbow and 2 dof for the
%   wrist
%
%	Based on:
%	- Holzbaur, K. R., Murray, W. M., & Delp, S. L., 2005.
%	A model of the upper extremity for simulating musculoskeletal surgery and analyzing neuromuscular control. Annals of biomedical engineering, 33(6), 829-840
%
%   INPUT
%   - OsteoArticularModel: osteo-articular model of an already existing
%   model (see the Documentation for the structure)
%   - k: homothety coefficient for the geometrical parameters (defined as
%   the subject size in cm divided by 180)
%   - Signe: side of the arm model ('R' for right side or 'L' for left side)
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
[OsteoArticularModel]= Upperarm(OsteoArticularModel,k,Signe,Mass,AttachmentPoint);
[OsteoArticularModel]= Forearm(OsteoArticularModel,k,Signe,Mass,[Signe 'Humerus_ElbowJointNode']);
[OsteoArticularModel]= Hand(OsteoArticularModel,k,Signe,Mass,[Signe 'Forearm_WristJointNode']);

end