function [new_name,p_trial]=ConvertClustertoScaploc(filename_trial, filename_arr, filename_av, token_mean)
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
    prefix_trial = names_trial{contains(names_trial,'MTACDB')};
    prefix_trial = prefix_trial(1:6);  
    SCAPDB_trial=markers_trial.([prefix_trial '_MTACDB']);
    nb_frame = size(SCAPDB_trial,1);
    SCAPDB_trial = reshape(SCAPDB_trial, [nb_frame 1 3]);
    SCAPDB_trial = permute(SCAPDB_trial, [3,2,1]);
    SCAPDH_trial = markers_trial.([prefix_trial '_MTACDM']);
    SCAPDH_trial = reshape(SCAPDH_trial, [nb_frame 1 3]);
    SCAPDH_trial = permute(SCAPDH_trial, [3,2,1]);
    SCAPDL_trial = markers_trial.([prefix_trial '_MTACDL']);
    SCAPDL_trial = reshape(SCAPDL_trial, [nb_frame 1 3]);
    SCAPDL_trial = permute(SCAPDL_trial, [3,2,1]);

    % Rear cluster
    names_arr = fieldnames(markers_arr);
    prefix_arr = names_arr{contains(names_arr,'MTACDB')};
    prefix_arr = prefix_arr(1:6);
    SCAPDB_arr=markers_arr.([prefix_arr '_MTACDB']);
    SCAPDH_arr=markers_arr.([prefix_arr '_MTACDM']);
    SCAPDL_arr=markers_arr.([prefix_arr '_MTACDL']);
    % Rear scaploc
    SCAPLOCB_arr=markers_arr.('ScapLoc_SCLB');
    SCAPLOCMM_arr=markers_arr.('ScapLoc_SCLM');
    SCAPLOCLM_arr=markers_arr.('ScapLoc_SCLL');
    
    % Advanced cluster
    names_av = fieldnames(markers_av);
    prefix_av = names_av{contains(names_av,'MTACDB')};
    prefix_av = prefix_av(1:6);
    SCAPDB_av=markers_av.([prefix_av '_MTACDB']);
    SCAPDH_av=markers_av.([prefix_av '_MTACDM']);
    SCAPDL_av=markers_av.([prefix_av '_MTACDL']);
    % Advanced scaploc
    SCAPLOCB_av=markers_av.('ScapLoc_SCLB');
    SCAPLOCMM_av=markers_av.('ScapLoc_SCLM');
    SCAPLOCLM_av=markers_av.('ScapLoc_SCLL');
    
%% Mean the positions of the markers to reduce noise on static poses
    if token_mean==1
        % Rear cluster    
        SCAPDB_arr=mean(SCAPDB_arr);
        SCAPDH_arr=mean(SCAPDH_arr);
        SCAPDL_arr=mean(SCAPDL_arr);
        % Rear scaploc
        SCAPLOCB_arr=mean(SCAPLOCB_arr);
        SCAPLOCMM_arr=mean(SCAPLOCMM_arr);
        SCAPLOCLM_arr=mean(SCAPLOCLM_arr);
        % Advanced scaploc
        SCAPDB_av=mean(SCAPDB_av);
        SCAPDH_av=mean(SCAPDH_av);
        SCAPDL_av=mean(SCAPDL_av);
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
        % Advanced scaploc
        SCAPDB_av=SCAPDB_av(1,:);
        SCAPDH_av=SCAPDH_av(1,:);
        SCAPDL_av=SCAPDL_av(1,:);
        % Advanced scaploc
        SCAPLOCB_av=SCAPLOCB_av(1,:);
        SCAPLOCMM_av=SCAPLOCMM_av(1,:);
        SCAPLOCLM_av=SCAPLOCLM_av(1,:);
    end
    
%% Find coefficients for quaternion interpolation
    % Rear cluster homogeneous matrix
    O_spine_arr = SCAPDB_arr;
    X_spine_arr = (SCAPDL_arr - SCAPDB_arr)/norm(SCAPDL_arr - SCAPDB_arr);
    yt_spine_arr = SCAPDH_arr - SCAPDB_arr;
    Z_spine_arr = (cross(X_spine_arr,yt_spine_arr))/norm(cross(X_spine_arr,yt_spine_arr));
    Y_spine_arr = cross(Z_spine_arr,X_spine_arr);
    T_spine_world_arr = [X_spine_arr' Y_spine_arr' Z_spine_arr' O_spine_arr'; 0 0 0 1];
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

%% Apply quaternion interpolation to cluster from filename_trial
    % Interpolation coefficient based on cluster position
    p_trial=vecnorm(O_spine_arr'-O_spine_trial)./norm(O_spine_av-O_spine_arr);
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
    labels=[ListMarkersName_trial; {'SCAPLOCB';'SCAPLOCMM';'SCAPLOCLM'}];
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
    new_name=[char(filename_trial(1:end-4)) '_scaploc.c3d'];
    btkWriteAcquisition(h_new, new_name);
end