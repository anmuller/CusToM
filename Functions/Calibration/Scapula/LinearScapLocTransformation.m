function real_markers=LinearScapLocTransformation(Lastframe,Firstframe,real_markers,O_SCAP_ar,O_SCAP_av,...
PSI_SCAPLOC_vers_epine_av,PSI_SCAPLOC_vers_epine_ar,...
THETA_SCAPLOC_vers_epine_av, THETA_SCAPLOC_vers_epine_ar,...
PHI_SCAPLOC_vers_epine_av, PHI_SCAPLOC_vers_epine_ar,...
O_SCAPLOC_vers_epine_av,O_SCAPLOC_vers_epine_ar,...
SCAPLOCB_SCAPLOC, SCAPLOCLM_SCAPLOC,SCAPLOCMM_SCAPLOC  )

for i=1:Lastframe-Firstframe+1
    SCAPDB=real_markers(end-2).position_c3d(i,:);
    SCAPDL=real_markers(end-1).position_c3d(i,:);
    SCAPDH=real_markers(end).position_c3d(i,:);
    O_SCAP = SCAPDB;
    X_SCAP = (SCAPDL - SCAPDB)/norm(SCAPDL - SCAPDB);
    yt_SCAP = SCAPDH - SCAPDB;
    Z_SCAP = (cross(X_SCAP,yt_SCAP))/norm(cross(X_SCAP,yt_SCAP));
    Y_SCAP = cross(Z_SCAP,X_SCAP);
    H_epine_vers_monde = [X_SCAP' Y_SCAP' Z_SCAP' O_SCAP'; 0 0 0 1];
    
    p=norm(O_SCAP_ar-O_SCAP)/norm(O_SCAP_av-O_SCAP_ar);    
    
    
    PSI_SCAPLOC_vers_epine = (PSI_SCAPLOC_vers_epine_av-PSI_SCAPLOC_vers_epine_ar)*p +PSI_SCAPLOC_vers_epine_ar;
    THETA_SCAPLOC_vers_epine = (THETA_SCAPLOC_vers_epine_av-THETA_SCAPLOC_vers_epine_ar)*p + THETA_SCAPLOC_vers_epine_ar;
    PHI_SCAPLOC_vers_epine = (PHI_SCAPLOC_vers_epine_av-PHI_SCAPLOC_vers_epine_ar)*p + PHI_SCAPLOC_vers_epine_ar;
    O_SCAPLOC_vers_epine = (O_SCAPLOC_vers_epine_av-O_SCAPLOC_vers_epine_ar)*p + O_SCAPLOC_vers_epine_ar;
    R_SCAPLOC_vers_epine=FromEulerAngles2Rotation(PSI_SCAPLOC_vers_epine,THETA_SCAPLOC_vers_epine,PHI_SCAPLOC_vers_epine);
    
    H_SCAPLOC_vers_epine = [R_SCAPLOC_vers_epine O_SCAPLOC_vers_epine; 0 0 0 1];
    
    H_SCAPLOC_vers_monde = H_epine_vers_monde*H_SCAPLOC_vers_epine;
    
    
    SCAPLOCB=H_SCAPLOC_vers_monde*[SCAPLOCB_SCAPLOC';1];
    SCAPLOCLM=H_SCAPLOC_vers_monde*[SCAPLOCLM_SCAPLOC';1];
    SCAPLOCMM=H_SCAPLOC_vers_monde*[SCAPLOCMM_SCAPLOC';1];
    SCAPLOCB=SCAPLOCB(1:3)';
    SCAPLOCLM=SCAPLOCLM(1:3)';
    SCAPLOCMM=SCAPLOCMM(1:3)';
    real_markers(end-5).position_c3d(i,:)=SCAPLOCLM;
    real_markers(end-4).position_c3d(i,:)=SCAPLOCMM;
    real_markers(end-3).position_c3d(i,:)=SCAPLOCB;
end

end