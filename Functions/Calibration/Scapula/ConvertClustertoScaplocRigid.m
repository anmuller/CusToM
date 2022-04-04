function [new_name]=ConvertClustertoScaplocRigid(filename_trial, filename_ne, token_mean)

%% Open files
    subject = char(filename_trial(1:6));
    % Open file of trial
    h_trial = btkReadAcquisition([char(filename_trial)]);
    markers_trial=btkGetMarkers(h_trial);
    ListMarkersName_trial = fieldnames(markers_trial);
    % Open file for neutral pose
    h_ne = btkReadAcquisition([char(filename_ne)]);
    markers_ne=btkGetMarkers(h_ne);

%% Get positions of clusters and scaploc in filename arr and filename av 
    % Trial cluster
    names_trial = fieldnames(markers_trial);
    prefix_trial = names_trial{contains(names_trial,'MTACDB')};
    prefix_trial = prefix_trial(1:6);  
    if strcmp(prefix_trial,'MTACDB')
        prefix_trial='';
    else
        prefix_trial = [prefix_trial '_'];
    end
    SCAPDB_trial=markers_trial.([prefix_trial 'MTACDB']);
    nb_frame = size(SCAPDB_trial,1);
    SCAPDB_trial = reshape(SCAPDB_trial, [nb_frame 1 3]);
    SCAPDB_trial = permute(SCAPDB_trial, [3,2,1]);
    SCAPDH_trial = markers_trial.([prefix_trial 'MTACDM']);
    SCAPDH_trial = reshape(SCAPDH_trial, [nb_frame 1 3]);
    SCAPDH_trial = permute(SCAPDH_trial, [3,2,1]);
    SCAPDL_trial = markers_trial.([prefix_trial 'MTACDL']);
    SCAPDL_trial = reshape(SCAPDL_trial, [nb_frame 1 3]);
    SCAPDL_trial = permute(SCAPDL_trial, [3,2,1]);

    % Neutral cluster
    names_ne = fieldnames(markers_ne);
    prefix_ne = names_ne{contains(names_ne,'MTACDB')};
    prefix_ne = prefix_ne(1:6);
     if strcmp(prefix_ne,'MTACDB')
        prefix_ne='';
    else
        prefix_ne = [prefix_ne '_'];
    end
    SCAPDB_ne=markers_ne.([prefix_ne 'MTACDB']);
    SCAPDH_ne=markers_ne.([prefix_ne 'MTACDM']);
    SCAPDL_ne=markers_ne.([prefix_ne 'MTACDL']);
    % Neutral scaploc
    SCAPLOCB_ne=markers_ne.('ScapLoc_SCLB');
    SCAPLOCMM_ne=markers_ne.('ScapLoc_SCLM');
    SCAPLOCLM_ne=markers_ne.('ScapLoc_SCLL');
    
%% Mean the positions of the markers to reduce noise on static poses
    if token_mean==1
        % Neutral cluster    
        SCAPDB_ne=mean(SCAPDB_ne);
        SCAPDH_ne=mean(SCAPDH_ne);
        SCAPDL_ne=mean(SCAPDL_ne);
        % Neutral scaploc
        SCAPLOCB_ne=mean(SCAPLOCB_ne);
        SCAPLOCMM_ne=mean(SCAPLOCMM_ne);
        SCAPLOCLM_ne=mean(SCAPLOCLM_ne);
    else
        % Neutral cluster    
        SCAPDB_ne=SCAPDB_ne(1,:);
        SCAPDH_ne=SCAPDH_ne(1,:);
        SCAPDL_ne=SCAPDL_ne(1,:);
        % Neutral scaploc
        SCAPLOCB_ne=SCAPLOCB_ne(1,:);
        SCAPLOCMM_ne=SCAPLOCMM_ne(1,:);
        SCAPLOCLM_ne=SCAPLOCLM_ne(1,:);
    end
    
%% Find coefficients for quaternion interpolation
    % Neutral cluster homogeneous matrix
    O_spine_ne = SCAPDB_ne;
    X_spine_ne = (SCAPDL_ne - SCAPDB_ne)/norm(SCAPDL_ne - SCAPDB_ne);
    yt_spine_ne = SCAPDH_ne - SCAPDB_ne;
    Z_spine_ne = (cross(X_spine_ne,yt_spine_ne))/norm(cross(X_spine_ne,yt_spine_ne));
    Y_spine_ne = cross(Z_spine_ne,X_spine_ne);
    T_spine_world_ne = [X_spine_ne' Y_spine_ne' Z_spine_ne' O_spine_ne'; 0 0 0 1];
    % Neutral scaploc homogeneous matrix
    O_SCAPLOC_ne = SCAPLOCB_ne;
    X_SCAPLOC_ne = (SCAPLOCLM_ne - SCAPLOCB_ne)/norm(SCAPLOCLM_ne - SCAPLOCB_ne);
    yt_SCAPLOC_ne = (SCAPLOCMM_ne - SCAPLOCB_ne)/norm(SCAPLOCMM_ne - SCAPLOCB_ne);
    Z_SCAPLOC_ne = cross(X_SCAPLOC_ne,yt_SCAPLOC_ne)/norm(cross(X_SCAPLOC_ne,yt_SCAPLOC_ne));
    Y_SCAPLOC_ne = cross(Z_SCAPLOC_ne,X_SCAPLOC_ne);
    T_SCAPLOC_world_ne = [X_SCAPLOC_ne' Y_SCAPLOC_ne' Z_SCAPLOC_ne' O_SCAPLOC_ne'; 0 0 0 1];
    % Scaploc markers in scaploc frame
    SCAPLOCMM_SCAPLOC=T_SCAPLOC_world_ne\[SCAPLOCMM_ne';1];
    SCAPLOCLM_SCAPLOC=T_SCAPLOC_world_ne\[SCAPLOCLM_ne';1];
    SCAPLOCB_SCAPLOC=T_SCAPLOC_world_ne\[SCAPLOCB_ne';1];
    SCAPLOCMM_SCAPLOC=SCAPLOCMM_SCAPLOC(1:3)';
    SCAPLOCLM_SCAPLOC=SCAPLOCLM_SCAPLOC(1:3)';
    SCAPLOCB_SCAPLOC=SCAPLOCB_SCAPLOC(1:3)';
    % Neutral homogenous matrix between scaploc and cluster
    T_SCAPLOC_spine_ne = T_spine_world_ne\T_SCAPLOC_world_ne;
    % Distance between scaploc and cluster on Neutral pose
    O_SCAPLOC_spine_ne = T_SCAPLOC_spine_ne(:,4);
    O_SCAPLOC_spine_ne = O_SCAPLOC_spine_ne(1:3);

    % Rotation matrix between scaploc and cluster on Neutral pose
    R_SCAPLOC_spine_ne = T_SCAPLOC_spine_ne(1:3,1:3);
    % Quaternion between scaploc and cluster on Neutral pose
    Q_SCAPLOC_spine_ne = quaternion(rotm2quat(R_SCAPLOC_spine_ne));
    
    % Trial cluster homogeneous matrix
    O_spine_trial = SCAPDB_trial;
    X_spine_trial = (SCAPDL_trial - SCAPDB_trial)./vecnorm(SCAPDL_trial - SCAPDB_trial);
    yt_spine_trial = SCAPDH_trial - SCAPDB_trial;
    Z_spine_trial = (cross(X_spine_trial,yt_spine_trial))./vecnorm(cross(X_spine_trial,yt_spine_trial));
    Y_spine_trial = cross(Z_spine_trial,X_spine_trial);
    last_row = zeros(1,4,nb_frame);last_row(:,4,:)=1;
    H_spine_world_trial = [X_spine_trial Y_spine_trial Z_spine_trial O_spine_trial];
    H_spine_world_trial(4,:,:)=last_row;

    % Homogeneous matrix between virtaul scaploc and cluster
    H_SCAPLOC_spine_trial = T_SCAPLOC_spine_ne;
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
    new_name=[char(filename_trial(1:end-4)) '_scaplocRigid.c3d'];
    btkWriteAcquisition(h_new, new_name);
end