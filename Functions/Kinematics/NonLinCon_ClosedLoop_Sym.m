function [c,ceq]=NonLinCon_ClosedLoop_Sym(Human_model,solid_path1,solid_path2,num_solid,num_markers,q,k)
% Non-linear equation used in the inverse kinematics step for closed loops
%
%   INPUT
%  - Human_model: osteo-articular model (see the Documentation for the
%   structure)
%   - solid_path1 : vector of one of the two paths to close the loop
%   - solid_path2 : vector of the other of the two paths to close the loop
%   - num_solid : vector of the number of solid where the anatomical point must join the
%   origin of another joint to close the loo
%   - num_markers : vector of the position in the list "anat_position" that
%   corresponds to the point to close the loop
%   - q: vector of joint coordinates at a given instant
%   - k: vector of homothety coefficient
%
%   OUTPUT
%   - c: non-linar inequality
%   - ceq: non-linear equality
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

% Contraints initialization
c=[];
ceq=sym('ceq',[6,1]);
    
if isempty(solid_path2) % if the beginning coincides with the end of the loop

    % Computation on path
    s = Human_model(num_solid).c + Human_model(num_solid).anat_position{num_markers,2}; % position with respects to the position of the mother solid joint of the closed loop
    [~,p_ClosedLoop,R_ClosedLoop] = ForwardKinematics_ClosedLoop(Human_model,1,s,solid_path1,[0 0 0]',eye(3),q,k);

    % Rotation matrix and Position vector
  %  Rtemp=R_ClosedLoop;
    ptemp=p_ClosedLoop;

%         % Rotation matrix must be equal to eye
        Rtemp=R_ClosedLoop -eye(3);
        ceq(1)=Rtemp(1,1);
        ceq(2)=Rtemp(2,2);
        ceq(3)=Rtemp(3,3);
%         ceq(4)=Rtemp(1,2);
%         ceq(5)=Rtemp(1,3);
%         ceq(6)=Rtemp(2,3);
        ceq(4)=ptemp(1);
        ceq(5)=ptemp(2);
        ceq(6)=ptemp(3);

    % Quaternion expression of rotation matrix   
%     r=1/2*sqrt(1+Rtemp(1,1)+Rtemp(2,2)+Rtemp(3,3));
%     ceq(1)=r-1;
%     ceq(2)=Rtemp(2,3);
%     ceq(3)=Rtemp(1,3);
%     ceq(4)=Rtemp(1,2);
%     ceq(5)=ptemp(1); 
%     ceq(6)=ptemp(2);
%     ceq(7)=ptemp(3);


else
    if isempty(solid_path1) % if the beginning coincides with the end of the loop

        % Computation on path
        s = Human_model(num_solid).c + Human_model(num_solid).anat_position{num_markers,2}; % position with respects to the position of the mother solid joint of the closed loop
        [~,p_ClosedLoop,R_ClosedLoop] = ForwardKinematics_ClosedLoop(Human_model,1,s,solid_path2,[0 0 0]',eye(3),q,k);

        % Rotation matrix and Position vector
        %Rtemp=R_ClosedLoop;
        ptemp=p_ClosedLoop;

%             % Rotation matrix must be equal to eye
            Rtemp=R_ClosedLoop -eye(3);
            ceq(1)=Rtemp(1,1);
            ceq(2)=Rtemp(2,2);
            ceq(3)=Rtemp(3,3);
%             ceq(4)=Rtemp(1,2);
%             ceq(5)=Rtemp(1,3);
%             ceq(6)=Rtemp(2,3);
            ceq(4)=ptemp(1);
            ceq(5)=ptemp(2);
            ceq(6)=ptemp(3);

        % Quaternion expression of rotation matrix   
%         r=1/2*sqrt(1+Rtemp(1,1)+Rtemp(2,2)+Rtemp(3,3));
%         ceq(1)=r-1;
%         ceq(2)=Rtemp(2,3);
%         ceq(3)=Rtemp(1,3);
%         ceq(4)=Rtemp(1,2);
%         ceq(5)=ptemp(1); 
%         ceq(6)=ptemp(2);
%         ceq(7)=ptemp(3);


    else% if the loop is cut elsewhere in the loop

        % Computation on path
        [Human_model,p_ClosedLoop1,R_ClosedLoop1] = ForwardKinematics_ClosedLoop(Human_model,1,[0 0 0],solid_path1,[0 0 0]',eye(3),q,k);
        [Human_model,p_ClosedLoop2,R_ClosedLoop2] = ForwardKinematics_ClosedLoop(Human_model,1,[0 0 0],solid_path2,[0 0 0]',eye(3),q,k);
        if ~isempty(intersect(solid_path1,num_solid)) % Finding the solid with the anatomical position to be respected
            p_ClosedLoop1 = p_ClosedLoop1 + R_ClosedLoop1*(Human_model(num_solid).c+Human_model(num_solid).anat_position{num_markers,2});
        else
            p_ClosedLoop2= p_ClosedLoop2 + R_ClosedLoop2*(Human_model(num_solid).c+Human_model(num_solid).anat_position{num_markers,2});
        end

        % Rotation matrix and Position vector
        ptemp=p_ClosedLoop2-p_ClosedLoop1;
        %Rtemp=R_ClosedLoop1*R_ClosedLoop2';

%             % Rotation matrix must be eye
            Rtemp=R_ClosedLoop1*R_ClosedLoop2' -eye(3);
            ceq(1)=Rtemp(1,1);
            ceq(2)=Rtemp(2,2);
            ceq(3)=Rtemp(3,3);
%             ceq(4)=Rtemp(1,2);
%             ceq(5)=Rtemp(1,3);
%             ceq(6)=Rtemp(2,3);
            ceq(4)=ptemp(1);
            ceq(5)=ptemp(2);
            ceq(6)=ptemp(3);

        % Quaternion expression of rotation matrix   
%         r=1/2*sqrt(1+Rtemp(1,1)+Rtemp(2,2)+Rtemp(3,3));
%         ceq(1)=r-1;
%         ceq(2)=Rtemp(2,3);
%         ceq(3)=Rtemp(1,3);
%         ceq(4)=Rtemp(1,2);
%         ceq(5)=ptemp(1); 
%         ceq(6)=ptemp(2);
%         ceq(7)=ptemp(3);


    end
end
end