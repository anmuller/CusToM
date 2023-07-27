function [new_name,p_trial]=ConvertClustertoScaplocBilinear(filename_trial, filename_arr, filename_av, token_mean,droiteougauche)
%% Open files
subject = char(filename_trial(1:6));
% Open file of trial
h_trial = btkReadAcquisition([char(filename_trial)]);
markers_trial=btkGetMarkers(h_trial);
ListMarkersName_trial = fieldnames(markers_trial);
% Open file for rear pose
h_arr = btkReadAcquisition([char(filename_arr)]);
markers_arr=btkGetMarkers(h_arr);
% Open file for advanced pose
h_av = btkReadAcquisition([char(filename_av)]);
markers_av=btkGetMarkers(h_av);

%% Get positions of clusters and scaploc in filename arr and filename av
% Trial cluster
names_trial = fieldnames(markers_trial);
%     prefix_trial = names_trial{contains(names_trial,'SCAPGB')};
prefix_trial = '';%prefix_trial(1:6);
try
    SCAPDB_trial=markers_trial.([prefix_trial 'SCAPGB']);
catch
    SCAPDB_trial=markers_trial.([prefix_trial 'SCAPDB']);
end
nb_frame = size(SCAPDB_trial,1);
SCAPDB_trial = reshape(SCAPDB_trial, [nb_frame 1 3]);
SCAPDB_trial = permute(SCAPDB_trial, [3,2,1]);
try
    SCAPDH_trial = markers_trial.([prefix_trial 'SCAPGH']);
catch
    SCAPDH_trial = markers_trial.([prefix_trial 'SCAPDH']);
    
end
SCAPDH_trial = reshape(SCAPDH_trial, [nb_frame 1 3]);
SCAPDH_trial = permute(SCAPDH_trial, [3,2,1]);
try
    SCAPDL_trial = markers_trial.([prefix_trial 'SCAPGL']);
catch
    SCAPDL_trial = markers_trial.([prefix_trial 'SCAPDL']);
end
SCAPDL_trial = reshape(SCAPDL_trial, [nb_frame 1 3]);
SCAPDL_trial = permute(SCAPDL_trial, [3,2,1]);

%Thorax trial
C7_trial=markers_trial.([prefix_trial 'C7']);
C7_trial = reshape(C7_trial, [nb_frame 1 3]);
C7_trial = permute(C7_trial, [3,2,1]);
MAN_trial = markers_trial.([prefix_trial 'MAN']);
MAN_trial = reshape(MAN_trial, [nb_frame 1 3]);
MAN_trial = permute(MAN_trial, [3,2,1]);
T8_trial = markers_trial.([prefix_trial 'T8']);
T8_trial = reshape(T8_trial, [nb_frame 1 3]);
T8_trial = permute(T8_trial, [3,2,1]);

% Rear cluster
names_arr = fieldnames(markers_arr);
prefix_arr = names_arr{contains(names_arr,'SCAPGB')};
prefix_arr =prefix_arr(1:end-6);
%     prefix_arr = '';%prefix_arr(1:6);
SCAPDB_arr=markers_arr.([prefix_arr 'SCAPGB']);
SCAPDH_arr=markers_arr.([prefix_arr 'SCAPGH']);
SCAPDL_arr=markers_arr.([prefix_arr 'SCAPGL']);
%THORAX ARRIERE
C7_arr=markers_arr.([prefix_arr 'C7']);
MAN_arr=markers_arr.([prefix_arr 'MAN']);
T8_arr=markers_arr.([prefix_arr 'T8']);


% Rear scaploc
try
    prefix_scaploc = names_arr{contains(names_arr,'Scaploc_B')};
    prefix_scaploc = prefix_scaploc(1:end-9);
catch
    prefix_scaploc='';
end
try
    SCAPLOCB_arr=markers_arr.([prefix_scaploc 'Scaploc_B']);
    SCAPLOCMM_arr=markers_arr.([prefix_scaploc 'Scaploc_MM']);
    SCAPLOCLM_arr=markers_arr.([prefix_scaploc 'Scaploc_LM']);
catch
    SCAPLOCB_arr=markers_arr.([prefix_scaploc 'SCAPLOCB']);
    SCAPLOCMM_arr=markers_arr.([prefix_scaploc 'SCAPLOCMM']);
    SCAPLOCLM_arr=markers_arr.([prefix_scaploc 'SCAPLOCLM']);
end
% Advanced cluster
names_av = fieldnames(markers_av);
prefix_av = names_av{contains(names_av,'SCAPGB')};
prefix_av = prefix_av(1:end-6);
SCAPDB_av=markers_av.([prefix_av 'SCAPGB']);
SCAPDH_av=markers_av.([prefix_av 'SCAPGH']);
SCAPDL_av=markers_av.([prefix_av 'SCAPGL']);

%THORAX AVANT
C7_av=markers_av.([prefix_av 'C7']);
MAN_av=markers_av.([prefix_av 'MAN']);
T8_av=markers_av.([prefix_av 'T8']);
% Advanced scaploc

try
    SCAPLOCB_av=markers_av.([prefix_scaploc 'Scaploc_B']);
    SCAPLOCMM_av=markers_av.([prefix_scaploc 'Scaploc_MM']);
    SCAPLOCLM_av=markers_av.([prefix_scaploc 'Scaploc_LM']);
catch
    SCAPLOCB_av=markers_av.([prefix_scaploc 'SCAPLOCB']);
    SCAPLOCMM_av=markers_av.([prefix_scaploc 'SCAPLOCMM']);
    SCAPLOCLM_av=markers_av.([prefix_scaploc 'SCAPLOCLM']);
end

%% Mean the positions of the markers to reduce noise on static poses
if token_mean==1
    % Rear cluster
    SCAPDB_arr=mean(SCAPDB_arr);
    SCAPDH_arr=mean(SCAPDH_arr);
    SCAPDL_arr=mean(SCAPDL_arr);
    %Rear thorax
    C7_arr=mean(C7_arr);
    MAN_arr=mean(MAN_arr);
    T8_arr=mean(T8_arr);
    % Rear scaploc
    SCAPLOCB_arr=mean(SCAPLOCB_arr);
    SCAPLOCMM_arr=mean(SCAPLOCMM_arr);
    SCAPLOCLM_arr=mean(SCAPLOCLM_arr);
    % Advanced cluster
    SCAPDB_av=mean(SCAPDB_av);
    SCAPDH_av=mean(SCAPDH_av);
    SCAPDL_av=mean(SCAPDL_av);
    %Advanced thorax
    C7_av=mean(C7_av);
    MAN_av=mean(MAN_av);
    T8_av=mean(T8_av);
    % Advanced scaploc
    SCAPLOCB_av=mean(SCAPLOCB_av);
    SCAPLOCMM_av=mean(SCAPLOCMM_av);
    SCAPLOCLM_av=mean(SCAPLOCLM_av);
else
    % Rear cluster
    SCAPDB_arr=SCAPDB_arr(1,:);
    SCAPDH_arr=SCAPDH_arr(1,:);
    SCAPDL_arr=SCAPDL_arr(1,:);
    % Rear scaploc
    SCAPLOCB_arr=SCAPLOCB_arr(1,:);
    SCAPLOCMM_arr=SCAPLOCMM_arr(1,:);
    SCAPLOCLM_arr=SCAPLOCLM_arr(1,:);
    %Rear thorax
    C7_arr=C7_arr(1,:);
    MAN_arr=MAN_arr(1,:);
    T8_arr=T8_arr(1,:);
    % Advanced scaploc
    SCAPDB_av=SCAPDB_av(1,:);
    SCAPDH_av=SCAPDH_av(1,:);
    SCAPDL_av=SCAPDL_av(1,:);
    % Advanced scaploc
    SCAPLOCB_av=SCAPLOCB_av(1,:);
    SCAPLOCMM_av=SCAPLOCMM_av(1,:);
    SCAPLOCLM_av=SCAPLOCLM_av(1,:);
    %Advanced thorax
    C7_av=C7_av(1,:);
    MAN_av=MAN_av(1,:);
    T8_av=T8_av(1,:);
end

%% Find coefficients for quaternion interpolation
% Rear cluster homogeneous matrix
O_spine_arr = SCAPDB_arr;
X_spine_arr = (SCAPDL_arr - SCAPDB_arr)/norm(SCAPDL_arr - SCAPDB_arr);
yt_spine_arr = SCAPDH_arr - SCAPDB_arr;
Z_spine_arr = (cross(X_spine_arr,yt_spine_arr))/norm(cross(X_spine_arr,yt_spine_arr));
Y_spine_arr = cross(Z_spine_arr,X_spine_arr);
T_spine_world_arr = [X_spine_arr' Y_spine_arr' Z_spine_arr' O_spine_arr'; 0 0 0 1];
% Rear Thorax homogeneous matrix
O_thorax_arr = C7_arr;
X_thorax_arr = (MAN_arr - C7_arr)/norm(MAN_arr - C7_arr);
yt_thorax_arr = T8_arr - C7_arr;
Z_thorax_arr = (cross(X_thorax_arr,yt_thorax_arr))/norm(cross(X_thorax_arr,yt_thorax_arr));
Y_thorax_arr = cross(Z_thorax_arr,X_thorax_arr)/norm(cross(Z_thorax_arr,X_thorax_arr));
T_thorax_world_arr = [X_thorax_arr' Y_thorax_arr' Z_thorax_arr' O_thorax_arr'; 0 0 0 1];

% Rear scaploc homogeneous matrix
O_SCAPLOC_arr = SCAPLOCB_arr;
X_SCAPLOC_arr = (SCAPLOCLM_arr - SCAPLOCB_arr)/norm(SCAPLOCLM_arr - SCAPLOCB_arr);
yt_SCAPLOC_arr = (SCAPLOCMM_arr - SCAPLOCB_arr)/norm(SCAPLOCMM_arr - SCAPLOCB_arr);
Z_SCAPLOC_arr = cross(X_SCAPLOC_arr,yt_SCAPLOC_arr)/norm(cross(X_SCAPLOC_arr,yt_SCAPLOC_arr));
Y_SCAPLOC_arr = cross(Z_SCAPLOC_arr,X_SCAPLOC_arr);
T_SCAPLOC_world_arr = [X_SCAPLOC_arr' Y_SCAPLOC_arr' Z_SCAPLOC_arr' O_SCAPLOC_arr'; 0 0 0 1];
% Scaploc markers in scaploc frame
SCAPLOCMM_SCAPLOC=T_SCAPLOC_world_arr\[SCAPLOCMM_arr';1];
SCAPLOCLM_SCAPLOC=T_SCAPLOC_world_arr\[SCAPLOCLM_arr';1];
SCAPLOCB_SCAPLOC=T_SCAPLOC_world_arr\[SCAPLOCB_arr';1];
SCAPLOCMM_SCAPLOC=SCAPLOCMM_SCAPLOC(1:3)';
SCAPLOCLM_SCAPLOC=SCAPLOCLM_SCAPLOC(1:3)';
SCAPLOCB_SCAPLOC=SCAPLOCB_SCAPLOC(1:3)';
% Rear homogenous matrix between scaploc and cluster
T_SCAPLOC_spine_arr = T_spine_world_arr\T_SCAPLOC_world_arr;
% Distance between scaploc and cluster on rear pose
O_SCAPLOC_spine_arr = T_SCAPLOC_spine_arr(:,4);
O_SCAPLOC_spine_arr = O_SCAPLOC_spine_arr(1:3);

% Rotation matrix between scaploc and cluster on rear pose
R_SCAPLOC_spine_arr = T_SCAPLOC_spine_arr(1:3,1:3);
% Quaternion between scaploc and cluster on rear pose
Q_SCAPLOC_spine_arr = quaternion(rotm2quat(R_SCAPLOC_spine_arr));

% Advanced cluster homogeneous matrix
O_spine_av = SCAPDB_av;
X_spine_av = (SCAPDL_av - SCAPDB_av)/norm(SCAPDL_av - SCAPDB_av);
yt_spine_av = SCAPDH_av - SCAPDB_av;
Z_spine_av = (cross(X_spine_av,yt_spine_av))/norm(cross(X_spine_av,yt_spine_av));
Y_spine_av = cross(Z_spine_av,X_spine_av);
T_spine_world_av = [X_spine_av' Y_spine_av' Z_spine_av' O_spine_av'; 0 0 0 1];
% Advanced thorax homogeneous matrix
O_thorax_av = C7_av;
X_thorax_av = (MAN_av - C7_av)/norm(MAN_av - C7_av);
yt_thorax_av = T8_av - C7_av;
Z_thorax_av = (cross(X_thorax_av,yt_thorax_av))/norm(cross(X_thorax_av,yt_thorax_av));
Y_thorax_av = cross(Z_thorax_av,X_thorax_av)/norm(cross(Z_thorax_av,X_thorax_av));
T_thorax_world_av = [X_thorax_av' Y_thorax_av' Z_thorax_av' O_thorax_av'; 0 0 0 1];

% Advanced scaploc homogeneous matrix
O_SCAPLOC_av = SCAPLOCB_av;
X_SCAPLOC_av = (SCAPLOCLM_av - SCAPLOCB_av)/norm(SCAPLOCLM_av - SCAPLOCB_av);
yt_SCAPLOC_av = (SCAPLOCMM_av - SCAPLOCB_av)/norm(SCAPLOCMM_av - SCAPLOCB_av);
Z_SCAPLOC_av = cross(X_SCAPLOC_av,yt_SCAPLOC_av)/norm(cross(X_SCAPLOC_av,yt_SCAPLOC_av));
Y_SCAPLOC_av = cross(Z_SCAPLOC_av,X_SCAPLOC_av);
T_SCAPLOC_world_av = [X_SCAPLOC_av' Y_SCAPLOC_av' Z_SCAPLOC_av' O_SCAPLOC_av'; 0 0 0 1];
% Advanced homogenous matrix between scaploc and cluster
T_SCAPLOC_spine_av = T_spine_world_av\T_SCAPLOC_world_av;
% Distance between scaploc and cluster on advance pose
O_SCAPLOC_spine_av = T_SCAPLOC_spine_av(:,4);
O_SCAPLOC_spine_av = O_SCAPLOC_spine_av(1:3);
% Rotation matrix between scaploc and cluster on advanced pose
R_SCAPLOC_spine_av = T_SCAPLOC_spine_av(1:3,1:3);
% Quaternion between scaploc and cluster on advanced pose
Q_SCAPLOC_spine_av = quaternion(rotm2quat(R_SCAPLOC_spine_av));

% Trial cluster homogeneous matrix
O_spine_trial = SCAPDB_trial;
X_spine_trial = (SCAPDL_trial - SCAPDB_trial)./vecnorm(SCAPDL_trial - SCAPDB_trial);
yt_spine_trial = SCAPDH_trial - SCAPDB_trial;
Z_spine_trial = (cross(X_spine_trial,yt_spine_trial))./vecnorm(cross(X_spine_trial,yt_spine_trial));
Y_spine_trial = cross(Z_spine_trial,X_spine_trial);
last_row = zeros(1,4,nb_frame);last_row(:,4,:)=1;
H_spine_world_trial = [X_spine_trial Y_spine_trial Z_spine_trial O_spine_trial];
H_spine_world_trial(4,:,:)=last_row;

% Trial thorax homogeneous matrix
O_thorax_trial = C7_trial;
X_thorax_trial = (MAN_trial - C7_trial)./vecnorm(MAN_trial - C7_trial);
yt_thorax_trial = T8_trial - C7_trial;
Z_thorax_trial = (cross(X_thorax_trial,yt_thorax_trial))./vecnorm(cross(X_thorax_trial,yt_thorax_trial));
Y_thorax_trial = cross(Z_thorax_trial,X_thorax_trial)./vecnorm(cross(Z_thorax_trial,X_thorax_trial));
last_row = zeros(1,4,nb_frame);last_row(:,4,:)=1;
T_thorax_world_trial = [X_thorax_trial Y_thorax_trial Z_thorax_trial O_thorax_trial];
T_thorax_world_trial(4,:,:)=last_row;

%% Apply quaternion interpolation to cluster from filename_trial
O_spine_thorax_arr      = T_thorax_world_arr\[O_spine_arr';1];
O_spine_thorax_arr      = O_spine_thorax_arr(1:3);
O_spine_thorax_av       = T_thorax_world_av\[O_spine_av';1];
O_spine_thorax_av       = O_spine_thorax_av(1:3);
for i=1:nb_frame
    O_spine_thorax_trial(:,:,i) = T_thorax_world_trial(:,:,i)\[O_spine_trial(:,:,i);1];
end
O_spine_thorax_trial=O_spine_thorax_trial(1:3,:,:);
% Interpolation coefficient based on cluster position
p_trial=vecnorm(O_spine_thorax_arr-O_spine_thorax_trial)./norm(O_spine_thorax_av-O_spine_thorax_arr);
% Slerp interpolation to compute quaternion between virtual scaploc and
% cluster during trial
Q_SCAPLOC_spine_trial = QuatSlerpAtHome(Q_SCAPLOC_spine_arr,Q_SCAPLOC_spine_av,p_trial);
% Rotation matrix between virtual scaploc and cluster
R_SCAPLOC_spine_trial = quat2rotm(Q_SCAPLOC_spine_trial(:));
% Distance between virtual scaploc and cluster
O_SCAPLOC_spine_trial = (O_SCAPLOC_spine_av-O_SCAPLOC_spine_arr).*p_trial + O_SCAPLOC_spine_arr;
% Homogeneous matrix between virtaul scaploc and cluster
H_SCAPLOC_spine_trial = [R_SCAPLOC_spine_trial O_SCAPLOC_spine_trial];
H_SCAPLOC_spine_trial(4,:,:)=last_row;
% Homogeneous matrix between virtual scaploc and world
H_SCAPLOC_world_trial = pagemtimes(H_spine_world_trial,H_SCAPLOC_spine_trial);
% Homogeneous matrix between virtual scaploc and thorax
% Computation of virtual scaploc marker positions
SCAPLOCB_trial=pagemtimes(H_SCAPLOC_world_trial,[SCAPLOCB_SCAPLOC';1]);
SCAPLOCLM_trial=pagemtimes(H_SCAPLOC_world_trial,[SCAPLOCLM_SCAPLOC';1]);
SCAPLOCMM_trial=pagemtimes(H_SCAPLOC_world_trial,[SCAPLOCMM_SCAPLOC';1]);
SCAPLOCB_trial=reshape(permute(SCAPLOCB_trial(1:3,:,:),[3,1,2]),[nb_frame 3]);
SCAPLOCLM_trial=reshape(permute(SCAPLOCLM_trial(1:3,:,:),[3,1,2]),[nb_frame 3]);
SCAPLOCMM_trial=reshape(permute(SCAPLOCMM_trial(1:3,:,:),[3,1,2]),[nb_frame 3]);

%% Write scaploc in filename_c3d and save it
% Number of markers in trial
pn_trial=btkGetPointNumber(h_trial);
% Adding virtual SCAPLOC markers to list of markers
pn_new=pn_trial+3;
if strcmp(droiteougauche,'D')
labels=[ListMarkersName_trial; {'SCAPLOCB';'SCAPLOCMM';'SCAPLOCLM'}];
else
    labels=[ListMarkersName_trial; {'SCAPLOCB1';'SCAPLOCMM1';'SCAPLOCLM1'}];
end
% Number of frames in trial
nb_frame_trial=btkGetLastFrame(h_trial)-btkGetFirstFrame(h_trial)+1;
% Trial acquisition frequency
f_trial=btkGetPointFrequency(h_trial);

% Creation of a new c3d file
h_new = btkNewAcquisition(pn_new,nb_frame_trial);
% Setting acquisition frequency
btkSetFrequency(h_new, f_trial);

% Copying markers from trial
for i=1:pn_trial
    btkSetPointLabel(h_new, i, labels{i});
    btkSetPoint(h_new, i, markers_trial.(ListMarkersName_trial{i}));
end
% Defining virtual SCAPLOC markers
% SCAPLOCB
btkSetPointLabel(h_new, pn_new-2, labels{pn_new-2});
btkSetPoint(h_new, pn_new-2, SCAPLOCB_trial);
% SCAPLOCMM
btkSetPointLabel(h_new, pn_new-1, labels{pn_new-1});
btkSetPoint(h_new, pn_new-1, SCAPLOCMM_trial);
% SCAPLOCLM
btkSetPointLabel(h_new, pn_new, labels{pn_new});
btkSetPoint(h_new, pn_new, SCAPLOCLM_trial);

% Write and save c3d
new_name=[char(filename_trial(1:end-4)) '.c3d'];
btkWriteAcquisition(h_new, new_name);
end