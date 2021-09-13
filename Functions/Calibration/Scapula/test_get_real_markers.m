% Fichier test unitaire function get_real_markers

%% Génération d'une faussse trajectoire de cluster
clear;
time= 0:0.01:1.5;
real_markers(6).position_c3d = [sin(2*0.001*time);cos(2*time);0.01*time]';
real_markers(5).position_c3d =real_markers(6).position_c3d + [0.01; -0.02; 0.04]';
real_markers(4).position_c3d =real_markers(6).position_c3d+ [-0.03; 0.02; 0.00]';
% 
% figure();
% for i=1:length(time)
%     
%     plot3(real_markers(end-2).position_c3d(i,1),real_markers(end-2).position_c3d(i,2),real_markers(end-2).position_c3d(i,3),'o');
%     hold on
%     plot3(real_markers(end-1).position_c3d(i,1),real_markers(end-1).position_c3d(i,2),real_markers(end-1).position_c3d(i,3),'o');
%     plot3(real_markers(end).position_c3d(i,1),real_markers(end).position_c3d(i,2),real_markers(end).position_c3d(i,3),'o');
%     
%     xlim([-0.2 0.2])
%     ylim([-1 1])
%     zlim([-0.5 1])
%     
%     pause(0.1)
%     hold off
% end
    
%% Variables utilisées
Lastframe = length(time);
Firstframe = 1;


%% Tests sur les valeurs 

O_SCAP_av = real_markers(6).position_c3d(1,:);
O_SCAP_arr = real_markers(6).position_c3d(end,:);

PSI_SCAPLOC_vers_epine_av =0;
PSI_SCAPLOC_vers_epine_ar=0;

THETA_SCAPLOC_vers_epine_av=0;
THETA_SCAPLOC_vers_epine_ar=0;

PHI_SCAPLOC_vers_epine_av=0;
PHI_SCAPLOC_vers_epine_ar=0;


O_SCAPLOC_vers_epine_av =  0*real_markers(6).position_c3d(1,:)';
O_SCAPLOC_vers_epine_ar =  0*real_markers(6).position_c3d(1,:)';

SCAPLOCB_SCAPLOC=0.2*[1;0;0]';
SCAPLOCLM_SCAPLOC=0.2*[0;1;0]';
SCAPLOCMM_SCAPLOC=0.2*[0;0;1]';

real_markers=LinearScapLocTransformation(Lastframe,Firstframe,real_markers,O_SCAP_arr,O_SCAP_av,...
                                                                                                                    PSI_SCAPLOC_vers_epine_av,PSI_SCAPLOC_vers_epine_ar,...
                                                                                                                    THETA_SCAPLOC_vers_epine_av, THETA_SCAPLOC_vers_epine_ar,...
                                                                                                                    PHI_SCAPLOC_vers_epine_av, PHI_SCAPLOC_vers_epine_ar,...
                                                                                                                    O_SCAPLOC_vers_epine_av,O_SCAPLOC_vers_epine_ar,...
                                                                                                                    SCAPLOCB_SCAPLOC, SCAPLOCLM_SCAPLOC,SCAPLOCMM_SCAPLOC);
                                                                                                                
                                                                                                                
                                                                                                                
figure();
for i=1:length(time)
    
    plot3(real_markers(end-2).position_c3d(i,1),real_markers(end-2).position_c3d(i,2),real_markers(end-2).position_c3d(i,3),'o');
    hold on
    plot3(real_markers(end-1).position_c3d(i,1),real_markers(end-1).position_c3d(i,2),real_markers(end-1).position_c3d(i,3),'o');
    plot3(real_markers(end).position_c3d(i,1),real_markers(end).position_c3d(i,2),real_markers(end).position_c3d(i,3),'o');
    
    
    
    plot3(real_markers(end-5).position_c3d(i,1),real_markers(end-5).position_c3d(i,2),real_markers(end-5).position_c3d(i,3),'*');
         hold on
    plot3(real_markers(end-4).position_c3d(i,1),real_markers(end-4).position_c3d(i,2),real_markers(end-4).position_c3d(i,3),'*');
    plot3(real_markers(end-3).position_c3d(i,1),real_markers(end-3).position_c3d(i,2),real_markers(end-3).position_c3d(i,3),'*');
    
    
    xlim([-0.2 0.2])
    ylim([-1.2 1])
    zlim([-0.5 0.7])
    
    pause(0.05)
    hold off
end
