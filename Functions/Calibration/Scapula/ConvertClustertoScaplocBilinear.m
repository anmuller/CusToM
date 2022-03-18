function [new_name,p_trial]=ConvertClustertoScaplocBilinear(filename_trial, filename_arr, filename_av, filename_n, token_mean)


    [~,p_trial_arr_n,SCAPLOCB_trial_arr_n,SCAPLOCMM_trial_arr_n,SCAPLOCLM_trial_arr_n]=ConvertClustertoScaplocLinear(filename_trial, filename_arr, filename_n, token_mean);
    p_trial_arr_n = p_trial_arr_n(:);
    %% Arr -> neutre
 
    
    [~,p_trial_n_av,SCAPLOCB_trial_n_av,SCAPLOCMM_trial_n_av,SCAPLOCLM_trial_n_av]=ConvertClustertoScaplocLinear(filename_trial, filename_n, filename_av, token_mean);
    
    
    
    
    SCAPLOCB_trial = SCAPLOCB_trial_arr_n;
    SCAPLOCB_trial(p_trial_arr_n>1,:) = SCAPLOCB_trial_n_av(p_trial_arr_n>1,:);
    
    
    SCAPLOCMM_trial = SCAPLOCMM_trial_arr_n;
    SCAPLOCMM_trial(p_trial_arr_n>1,:) = SCAPLOCMM_trial_n_av(p_trial_arr_n>1,:);
    
    
    SCAPLOCLM_trial = SCAPLOCLM_trial_arr_n;
    SCAPLOCLM_trial(p_trial_arr_n>1,:) = SCAPLOCLM_trial_n_av(p_trial_arr_n>1,:);
    
    p_trial = p_trial_arr_n;
    p_trial(p_trial_arr_n>1) = p_trial_n_av(p_trial_arr_n>1);
    
    
    
    % Open file of trial
    h_trial = btkReadAcquisition([char(filename_trial)]);
    markers_trial=btkGetMarkers(h_trial);
    ListMarkersName_trial = fieldnames(markers_trial);
    
%% Open files
    subject = char(filename_trial(1:6));
    % Open file of trial
    h_trial = btkReadAcquisition([char(filename_trial)]);
    markers_trial=btkGetMarkers(h_trial);
    ListMarkersName_trial = fieldnames(markers_trial);

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
    new_name=[char(filename_trial(1:end-4)) '_scaplocBilinear.c3d'];
    btkWriteAcquisition(h_new, new_name);
end