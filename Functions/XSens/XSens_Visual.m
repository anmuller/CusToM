function [] = XSens_Visual(OsteoArticularModel, tree)
% Visual generation for XSens data
%
%   INPUT
%   - OsteoArticularModel: osteo-articular model of an already existing
%   model (see the Documentation for the structure)
%   - tree: data extracted from a MVNX file
%   OUTPUT
%   Results are automatically saved on a folder 'Visual'
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

%% Joints position in t-pose

pose = 'tpose';
[~,num_pose] = intersect({tree.subject.frames.frame.type},pose);

% position
PelvisPos = tree.subject.frames.frame(num_pose).position((1-1)*3+1:(1-1)*3+3);
L5Pos = tree.subject.frames.frame(num_pose).position((2-1)*3+1:(2-1)*3+3);
L3Pos = tree.subject.frames.frame(num_pose).position((3-1)*3+1:(3-1)*3+3);
T12Pos = tree.subject.frames.frame(num_pose).position((4-1)*3+1:(4-1)*3+3);
T8Pos = tree.subject.frames.frame(num_pose).position((5-1)*3+1:(5-1)*3+3);
NeckPos = tree.subject.frames.frame(num_pose).position((6-1)*3+1:(6-1)*3+3);
HeadPos = tree.subject.frames.frame(num_pose).position((7-1)*3+1:(7-1)*3+3);
RightShoulderPos = tree.subject.frames.frame(num_pose).position((8-1)*3+1:(8-1)*3+3);
RightUpperArmPos = tree.subject.frames.frame(num_pose).position((9-1)*3+1:(9-1)*3+3);
RightForeArmPos = tree.subject.frames.frame(num_pose).position((10-1)*3+1:(10-1)*3+3);
RightHandPos = tree.subject.frames.frame(num_pose).position((11-1)*3+1:(11-1)*3+3);
LeftShoulderPos = tree.subject.frames.frame(num_pose).position((12-1)*3+1:(12-1)*3+3);
LeftUpperArmPos = tree.subject.frames.frame(num_pose).position((13-1)*3+1:(13-1)*3+3);
LeftForeArmPos = tree.subject.frames.frame(num_pose).position((14-1)*3+1:(14-1)*3+3);
LeftHandPos = tree.subject.frames.frame(num_pose).position((15-1)*3+1:(15-1)*3+3);
RightUpperLegPos = tree.subject.frames.frame(num_pose).position((16-1)*3+1:(16-1)*3+3);
RightLowerLegPos = tree.subject.frames.frame(num_pose).position((17-1)*3+1:(17-1)*3+3);
RightFootPos = tree.subject.frames.frame(num_pose).position((18-1)*3+1:(18-1)*3+3);
RightToePos = tree.subject.frames.frame(num_pose).position((19-1)*3+1:(19-1)*3+3);
LeftUpperLegPos = tree.subject.frames.frame(num_pose).position((20-1)*3+1:(20-1)*3+3);
LeftLowerLegPos = tree.subject.frames.frame(num_pose).position((21-1)*3+1:(21-1)*3+3);
LeftFootPos = tree.subject.frames.frame(num_pose).position((22-1)*3+1:(22-1)*3+3);
LeftToePos = tree.subject.frames.frame(num_pose).position((23-1)*3+1:(23-1)*3+3);

% orientation
PelvisRot = quat2rotm(tree.subject.frames.frame(num_pose).orientation((1-1)*4+1:(1-1)*4+4));
L5Rot = quat2rotm(tree.subject.frames.frame(num_pose).orientation((2-1)*4+1:(2-1)*4+4));
L3Rot = quat2rotm(tree.subject.frames.frame(num_pose).orientation((3-1)*4+1:(3-1)*4+4));
T12Rot = quat2rotm(tree.subject.frames.frame(num_pose).orientation((4-1)*4+1:(4-1)*4+4));
T8Rot = quat2rotm(tree.subject.frames.frame(num_pose).orientation((5-1)*4+1:(5-1)*4+4));
NeckRot = quat2rotm(tree.subject.frames.frame(num_pose).orientation((6-1)*4+1:(6-1)*4+4));
HeadRot = quat2rotm(tree.subject.frames.frame(num_pose).orientation((7-1)*4+1:(7-1)*4+4));
RightShoulderRot = quat2rotm(tree.subject.frames.frame(num_pose).orientation((8-1)*4+1:(8-1)*4+4));
RightUpperArmRot = quat2rotm(tree.subject.frames.frame(num_pose).orientation((9-1)*4+1:(9-1)*4+4));
RightForeArmRot = quat2rotm(tree.subject.frames.frame(num_pose).orientation((10-1)*4+1:(10-1)*4+4));
RightHandRot = quat2rotm(tree.subject.frames.frame(num_pose).orientation((11-1)*4+1:(11-1)*4+4));
LeftShoulderRot = quat2rotm(tree.subject.frames.frame(num_pose).orientation((12-1)*4+1:(12-1)*4+4));
LeftUpperArmRot = quat2rotm(tree.subject.frames.frame(num_pose).orientation((13-1)*4+1:(13-1)*4+4));
LeftForeArmRot = quat2rotm(tree.subject.frames.frame(num_pose).orientation((14-1)*4+1:(14-1)*4+4));
LeftHandRot = quat2rotm(tree.subject.frames.frame(num_pose).orientation((15-1)*4+1:(15-1)*4+4));
RightUpperLegRot = quat2rotm(tree.subject.frames.frame(num_pose).orientation((16-1)*4+1:(16-1)*4+4));
RightLowerLegRot = quat2rotm(tree.subject.frames.frame(num_pose).orientation((17-1)*4+1:(17-1)*4+4));
RightFootRot = quat2rotm(tree.subject.frames.frame(num_pose).orientation((18-1)*4+1:(18-1)*4+4));
RightToeRot = quat2rotm(tree.subject.frames.frame(num_pose).orientation((19-1)*4+1:(19-1)*4+4));
LeftUpperLegRot = quat2rotm(tree.subject.frames.frame(num_pose).orientation((20-1)*4+1:(20-1)*4+4));
LeftLowerLegRot = quat2rotm(tree.subject.frames.frame(num_pose).orientation((21-1)*4+1:(21-1)*4+4));
LeftFootRot = quat2rotm(tree.subject.frames.frame(num_pose).orientation((22-1)*4+1:(22-1)*4+4));
LeftToeRot = quat2rotm(tree.subject.frames.frame(num_pose).orientation((23-1)*4+1:(23-1)*4+4));

% Length (to scale)
bonespath=which('ModelGeneration.m');
bonespath = fileparts(bonespath);
bonepath=fullfile(bonespath,'Visual\XSens');

load([bonepath '/XSensSTLLength.mat']); %#ok<LOAD>

% if ~exist('Visual','dir')
    mkdir('Visual')
% end

%% Pelvis
load([bonepath '/Pelvis.mat']); %#ok<LOAD>
coef = norm(PelvisPos-L5Pos)/Length.Pelvis;
p=p*coef; %#ok<NODEF>
Point = L5Pos - PelvisPos;
q2 = atan(-Point(1)/Point(3));
q1 = atan(-Point(2)/-Point(3)*cos(q2) + Point(1)*sin(q2));
R = (Rodrigues([1 0 0],q1) * Rodrigues([0 1 0], q2));
for i=1:size(p,1)
    p(i,:) = (PelvisRot' * (R' * p(i,:)'))';
end
p = p - OsteoArticularModel(1).c';
save('Visual/Pelvis','p','t'); %#ok<USENS>

%% Right upper leg
load([bonepath '/RightUpperLeg.mat']); %#ok<LOAD>
coef = norm(RightUpperLegPos-RightLowerLegPos)/Length.RightUpperLeg;
p=p*coef;
Point = RightLowerLegPos - RightUpperLegPos;
q2 = atan(-Point(1)/Point(3));
q1 = atan(-Point(2)/-Point(3)*cos(q2) + Point(1)*sin(q2));
R = (Rodrigues([1 0 0],q1) * Rodrigues([0 1 0], q2));
for i=1:size(p,1)
    p(i,:) = (RightUpperLegRot' * (R' * p(i,:)'))';
end
p = p - OsteoArticularModel(46).c';
save('Visual/RightUpperLeg','p','t');

%% Right lower leg
load([bonepath '/RightLowerLeg.mat']); %#ok<LOAD>
coef = norm(RightLowerLegPos-RightFootPos)/Length.RightLowerLeg;
p=p*coef;
Point = RightFootPos - RightLowerLegPos;
q2 = atan(-Point(1)/Point(3));
q1 = atan(-Point(2)/-Point(3)*cos(q2) + Point(1)*sin(q2));
R = (Rodrigues([1 0 0],q1) * Rodrigues([0 1 0], q2));
for i=1:size(p,1)
    p(i,:) = (RightLowerLegRot' * (R' * p(i,:)'))';
end
p = p - OsteoArticularModel(49).c';
save('Visual/RightLowerLeg','p','t');

%% Right foot
load([bonepath '/RightFoot.mat']); %#ok<LOAD>
coef = norm(RightFootPos-RightToePos)/Length.RightFoot;
p=p*coef;
Point = RightToePos - RightFootPos;
q2 = atan(-Point(1)/Point(3));
q1 = atan(-Point(2)/-Point(3)*cos(q2) + Point(1)*sin(q2));
R = (Rodrigues([1 0 0],q1) * Rodrigues([0 1 0], q2));
for i=1:size(p,1)
    p(i,:) = (RightFootRot' * (R' * p(i,:)'))';
end
p = p - OsteoArticularModel(52).c';
save('Visual/RightFoot','p','t');

%% Right toe
load([bonepath '/RightToe.mat']); %#ok<LOAD>
p=p*coef;
for i=1:size(p,1)
    p(i,:) = (RightToeRot' * p(i,:)')';
end
p = p - OsteoArticularModel(55).c';
save('Visual/RightToe','p','t');

%% Left upper leg
load([bonepath '/LeftUpperLeg.mat']); %#ok<LOAD>
coef = norm(LeftUpperLegPos-LeftLowerLegPos)/Length.LeftUpperLeg;
p=p*coef;
Point = LeftLowerLegPos - LeftUpperLegPos;
q2 = atan(-Point(1)/Point(3));
q1 = atan(-Point(2)/-Point(3)*cos(q2) + Point(1)*sin(q2));
R = (Rodrigues([1 0 0],q1) * Rodrigues([0 1 0], q2));
for i=1:size(p,1)
    p(i,:) = (LeftUpperLegRot' * (R' * p(i,:)'))';
end
p = p - OsteoArticularModel(58).c';
save('Visual/LeftUpperLeg','p','t');

%% Left lower leg
load([bonepath '/LeftLowerLeg.mat']); %#ok<LOAD>
coef = norm(LeftLowerLegPos-LeftFootPos)/Length.LeftLowerLeg;
p=p*coef;
Point = LeftFootPos - LeftLowerLegPos;
q2 = atan(-Point(1)/Point(3));
q1 = atan(-Point(2)/-Point(3)*cos(q2) + Point(1)*sin(q2));
R = (Rodrigues([1 0 0],q1) * Rodrigues([0 1 0], q2));
for i=1:size(p,1)
    p(i,:) = (LeftLowerLegRot' * (R' * p(i,:)'))';
end
p = p - OsteoArticularModel(61).c';
save('Visual/LeftLowerLeg','p','t');

%% Left foot
load([bonepath '/LeftFoot.mat']); %#ok<LOAD>
coef = norm(LeftFootPos-LeftToePos)/Length.LeftFoot;
p=p*coef;
Point = LeftToePos - LeftFootPos;
q2 = atan(-Point(1)/Point(3));
q1 = atan(-Point(2)/-Point(3)*cos(q2) + Point(1)*sin(q2));
R = (Rodrigues([1 0 0],q1) * Rodrigues([0 1 0], q2));
for i=1:size(p,1)
    p(i,:) = (LeftFootRot' * (R' * p(i,:)'))';
end
p = p - OsteoArticularModel(64).c';
save('Visual/LeftFoot','p','t');

%% Left toe
load([bonepath '/LeftToe.mat']); %#ok<LOAD>
p=p*coef;
for i=1:size(p,1)
    p(i,:) = (LeftToeRot' * p(i,:)')';
end
p = p - OsteoArticularModel(67).c';
save('Visual/LeftToe','p','t');

%% L5
load([bonepath '/L5.mat']); %#ok<LOAD>
coef = norm(L5Pos-L3Pos)/Length.L5;
p=p*coef;
Point = L3Pos - L5Pos;
q2 = atan(-Point(1)/Point(3));
q1 = atan(-Point(2)/-Point(3)*cos(q2) + Point(1)*sin(q2));
R = (Rodrigues([1 0 0],q1) * Rodrigues([0 1 0], q2));
for i=1:size(p,1)
    p(i,:) = (L5Rot' * (R' * p(i,:)'))';
end
p = p - OsteoArticularModel(4).c';
save('Visual/L5','p','t');

%% L3
load([bonepath '/L3.mat']); %#ok<LOAD>
coef = norm(L3Pos-T12Pos)/Length.L3;
p=p*coef;
Point = T12Pos - L3Pos;
q2 = atan(-Point(1)/Point(3));
q1 = atan(-Point(2)/-Point(3)*cos(q2) + Point(1)*sin(q2));
R = (Rodrigues([1 0 0],q1) * Rodrigues([0 1 0], q2));
for i=1:size(p,1)
    p(i,:) = (L3Rot' * (R' * p(i,:)'))';
end
p = p - OsteoArticularModel(7).c';
save('Visual/L3','p','t');

%% T12
load([bonepath '/T12.mat']); %#ok<LOAD>
coef = norm(T12Pos-T8Pos)/Length.T12;
p=p*coef;
Point = T8Pos - T12Pos;
q2 = atan(-Point(1)/Point(3));
q1 = atan(-Point(2)/-Point(3)*cos(q2) + Point(1)*sin(q2));
R = (Rodrigues([1 0 0],q1) * Rodrigues([0 1 0], q2));
for i=1:size(p,1)
    p(i,:) = (T12Rot' * (R' * p(i,:)'))';
end
p = p - OsteoArticularModel(10).c';
save('Visual/T12','p','t');

%% T8
load([bonepath '/T8.mat']);  %#ok<LOAD>
coef = norm(T8Pos-NeckPos)/Length.T8;
p=p*coef;
Point = NeckPos - T8Pos;
q2 = atan(-Point(1)/Point(3));
q1 = atan(-Point(2)/-Point(3)*cos(q2) + Point(1)*sin(q2));
R = (Rodrigues([1 0 0],q1) * Rodrigues([0 1 0], q2));
for i=1:size(p,1)
    p(i,:) = (T8Rot' * (R' * p(i,:)'))';
end
p = p - OsteoArticularModel(13).c';
save('Visual/T8','p','t');

%% Neck
load([bonepath '/Neck.mat']); %#ok<LOAD>
coef = norm(NeckPos-HeadPos)/Length.Neck;
p=p*coef;
Point = HeadPos - NeckPos;
q2 = atan(-Point(1)/Point(3));
q1 = atan(-Point(2)/-Point(3)*cos(q2) + Point(1)*sin(q2));
R = (Rodrigues([1 0 0],q1) * Rodrigues([0 1 0], q2));
for i=1:size(p,1)
    p(i,:) = (NeckRot' * (R' * p(i,:)'))';
end
p = p - OsteoArticularModel(16).c';
save('Visual/Neck','p','t');

%% Head
load([bonepath '/Head.mat']); %#ok<LOAD>
p=p*coef;
for i=1:size(p,1)
    p(i,:) = (HeadRot' * p(i,:)')';
end
p = p - OsteoArticularModel(19).c';
save('Visual/Head','p','t');

%% Right shoulder
load([bonepath '/RightShoulder.mat']); %#ok<LOAD>
coef = norm(RightShoulderPos-RightUpperArmPos)/Length.RightShoulder;
p=p*coef;
q2 = 0;
q1 = -pi/2;
R = (Rodrigues([1 0 0],q1) * Rodrigues([0 1 0], q2));
for i=1:size(p,1)
    p(i,:) = (RightShoulderRot' * (R' * p(i,:)'))';
end
p = p - OsteoArticularModel(22).c';
save('Visual/RightShoulder','p','t');

%% Right upper arm
load([bonepath '/RightUpperArm.mat']);  %#ok<LOAD>
coef = norm(RightUpperArmPos-RightForeArmPos)/Length.RightUpperArm;
p=p*coef;
q2 = 0;
q1 = -pi/2;
R = Rodrigues([0 0 1], -pi/2) * (Rodrigues([1 0 0],q1) * Rodrigues([0 1 0], q2));
for i=1:size(p,1)
    p(i,:) = (RightUpperArmRot' * (R' * p(i,:)'))';
end
p = p - OsteoArticularModel(25).c';
save('Visual/RightUpperArm','p','t');

%% Right forearm
load([bonepath '/RightForeArm.mat']); %#ok<LOAD>
coef = norm(RightForeArmPos-RightHandPos)/Length.RightForeArm;
p=p*coef;
q2 = 0;
q1 = -pi/2;
R = (Rodrigues([1 0 0],q1) * Rodrigues([0 1 0], q2));
for i=1:size(p,1)
    p(i,:) = (RightForeArmRot' * (R' * p(i,:)'))';
end
p = p - OsteoArticularModel(28).c';
save('Visual/RightForeArm','p','t');

%% Right hand
load([bonepath '/RightHand.mat']); %#ok<LOAD>
p=p*coef;
q2 = 0;
q1 = -pi/2;
R = Rodrigues([0 0 1], pi) * (Rodrigues([1 0 0],q1) * Rodrigues([0 1 0], q2));
for i=1:size(p,1)
    p(i,:) = (RightHandRot' * (R' * p(i,:)'))';
end
p = p - OsteoArticularModel(31).c';
save('Visual/RightHand','p','t');

%% Left shoulder
load([bonepath '/LeftShoulder.mat']); %#ok<LOAD>
coef = norm(LeftShoulderPos-LeftUpperArmPos)/Length.LeftShoulder;
p=p*coef;
q2 = 0;
q1 = pi/2;
R = (Rodrigues([1 0 0],q1) * Rodrigues([0 1 0], q2));
for i=1:size(p,1)
    p(i,:) = (LeftShoulderRot' * (R' * p(i,:)'))';
end
p = p - OsteoArticularModel(34).c';
save('Visual/LeftShoulder','p','t');

%% Left upper arm
load([bonepath '/LeftUpperArm.mat']); %#ok<LOAD>
coef = norm(LeftUpperArmPos-LeftForeArmPos)/Length.LeftUpperArm;
p=p*coef;
q2 = 0;
q1 = -pi/2;
R = (Rodrigues([1 0 0],q1) * Rodrigues([0 1 0], q2));
for i=1:size(p,1)
    p(i,:) = (LeftUpperArmRot' * (R' * p(i,:)'))';
end
p = p - OsteoArticularModel(37).c';
save('Visual/LeftUpperArm','p','t');

%% Left forearm
load([bonepath '/LeftForeArm.mat']); %#ok<LOAD>
coef = norm(LeftForeArmPos-LeftHandPos)/Length.LeftForeArm;
p=p*coef;
q2 = 0;
q1 = -pi/2;
R = Rodrigues([0 0 1], pi) * (Rodrigues([1 0 0],q1) * Rodrigues([0 1 0], q2));
for i=1:size(p,1)
    p(i,:) = (LeftForeArmRot' * (R' * p(i,:)'))';
end
p = p - OsteoArticularModel(40).c';
save('Visual/LeftForeArm','p','t');

%% Left hand
load([bonepath '/LeftHand.mat']); %#ok<LOAD>
p=p*coef;
q2 = 0;
q1 = pi/2;
R = Rodrigues([0 0 1], pi/2) * (Rodrigues([1 0 0],q1) * Rodrigues([0 1 0], q2));
for i=1:size(p,1)
    p(i,:) = (LeftHandRot' * (R' * p(i,:)'))';
end
p = p - OsteoArticularModel(43).c';
save('Visual/LeftHand','p','t');


end