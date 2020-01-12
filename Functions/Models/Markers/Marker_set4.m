function [Markers]=Marker_set4(varargin)
% Definition of the markers set used with the Kinect
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

s=[s;{'HIP_CENTER' 'CoMPelvis' {'Off';'On';'Off'};'SPINE' 'Thorax_T12L1JointNode' {'Off';'Off';'Off'};'SHOULDER_CENTER' 'Thorax_T1C5' {'Off';'Off';'Off'};...
    'HEAD' 'Skull_NeckNode' {'Off';'On';'Off'};'SHOULDER_LEFT' 'Thorax_ShoulderLeftNode' {'Off';'Off';'Off'};'ELBOW_LEFT' 'LHumerus_ElbowJointNode' {'Off';'Off';'Off'};'WRIST_LEFT' 'LHand_WristJointNode' {'Off';'Off';'Off'};...
    'HAND_LEFT' 'LHand_EndNode' {'Off';'Off';'Off'};'SHOULDER_RIGHT' 'Thorax_ShoulderRightNode' {'Off';'Off';'Off'};'ELBOW_RIGHT' 'RHumerus_ElbowJointNode' {'Off';'Off';'Off'};...
    'WRIST_RIGHT' 'RHand_WristJointNode' {'Off';'Off';'Off'};'HAND_RIGHT' 'RHand_EndNode' {'Off';'Off';'Off'};'HIP_LEFT' 'LThigh_HipJointNode' {'Off';'Off';'Off'};'KNEE_LEFT' 'LShank_KneeJointNode' {'Off';'Off';'Off'};...
    'ANKLE_LEFT' 'LFoot_AnkleJointNode' {'Off';'Off';'Off'};'FOOT_LEFT' 'LFoot_ToetipNode' {'Off';'On';'Off'};'HIP_RIGHT' 'RThigh_HipJointNode' {'Off';'Off';'Off'};...
    'KNEE_RIGHT' 'RShank_KneeJointNode' {'Off';'Off';'Off'};'ANKLE_RIGHT' 'RFoot_AnkleJointNode' {'Off';'Off';'Off'};'FOOT_RIGHT' 'RFoot_ToetipNode' {'Off';'On';'Off'}}];

Markers=struct('name',{s{:,1}}','anat_position',{s{:,2}}','calib_dir',{s{:,3}}'); %#ok<CCAT1>

end

