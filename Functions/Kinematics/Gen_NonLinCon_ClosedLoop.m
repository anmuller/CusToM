function [c,ceq]=Gen_NonLinCon_ClosedLoop(Human_model,nbClosedLoop)
% Non-linear constraints generation.
% These constraints are used in the inverse kinematics step for closed loop
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure)
%   - nb_ClosedLoop: number of closed loop in the model
%   OUTPUT
%   - c: non-linar inequality constraint
%   - ceq: non-linear equality constraint
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
c=[];

%% Number of solids considered in the Inverse Kinematics
   
loop_start=zeros(1 ,nbClosedLoop);
loop_end=zeros(1, nbClosedLoop);
loop_end_anat=zeros(1, nbClosedLoop);
loop_i=1;
for j=1:numel(Human_model)
    if size(Human_model(j).ClosedLoop) ~= [0 0] %#ok<BDSCA>
        % we find the solid and the position where there was a cut
        loop_start(loop_i)=j;
        name=Human_model(j).ClosedLoop;
        token=0;
        for pp=1:numel(Human_model)
            for kk=1:size(Human_model(pp).anat_position,1)
                if strcmp(name,Human_model(pp).anat_position(kk,1))
                    loop_end(loop_i)=pp;
                    loop_end_anat(loop_i)=kk;
                    token=1;
                    loop_i=loop_i+1;
                    break
                end
            end
            if token ~= 0
                break
            end
        end
    end
end

% ceq=sym('ceq',[9*nbClosedLoop 1]);
ceq=sym('ceq',[7*nbClosedLoop 1]);


for j=1:nbClosedLoop
    Rtemp=Human_model(loop_start(j)).R*Human_model(loop_end(j)).R';
    ptemp=Human_model(loop_start(j)).p - Human_model(loop_end(j)).R*Human_model(loop_end(j)).anat_position{loop_end_anat(j),2} - Human_model(loop_end(j)).p ;

%     % Rotation matrix must be equal to eye    
%     Rtemp=Human_model(loop_start(j)).R*Human_model(loop_end(j)).R' -eye(3);
%     ceq(1+9*(j-1))=Rtemp(1,1);
%     ceq(2+9*(j-1))=Rtemp(2,2);
%     ceq(3+9*(j-1))=Rtemp(3,3);
%     ceq(4+9*(j-1))=Rtemp(1,2);
%     ceq(5+9*(j-1))=Rtemp(1,3);
%     ceq(6+9*(j-1))=Rtemp(2,3);
%     ceq(7+9*(j-1))=ptemp(1);
%     ceq(8+9*(j-1))=ptemp(2);
%     ceq(9+9*(j-1))=ptemp(3);

    % Quaternion expression of rotation matrix   
    r=1/2*sqrt(1+Rtemp(1,1)+Rtemp(2,2)+Rtemp(3,3));
    ceq(1+7*(pp-1))=r-1;
    ceq(2+7*(pp-1))=Rtemp(3,2)-Rtemp(2,3);
    ceq(3+7*(pp-1))=Rtemp(1,3)-Rtemp(3,1);
    ceq(4+7*(pp-1))=Rtemp(2,1)-Rtemp(1,2);
    ceq(5+7*(pp-1))=ptemp(1); 
    ceq(6+7*(pp-1))=ptemp(2);
    ceq(7+7*(pp-1))=ptemp(3);
    
end
end


