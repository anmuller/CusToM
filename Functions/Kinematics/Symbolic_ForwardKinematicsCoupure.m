function [Human_model,Markers_set,num_cut,numClosedLoop,c,ceq]=...
    Symbolic_ForwardKinematicsCoupure(Human_model,Markers_set,j,q,k,p_adapt,num_cut,numClosedLoop,c,ceq)
% Computation of a symbolic forward kinematics 
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure) 
%   - Markers_set: set of markers (see the Documentation for the structure)
%   - j: current solid
%   - q: vector of joint coordinates
%   - k: vector of homothety coefficient
%   - p_adapt: vector of variation of local model markers position
%   - num_cut: number of geometrical cut done in the osteo-articular model
%   - numClosedLoop: number of closed loop in the model
%   - p_ClosedLoop: position of the closed loops
%   - R_ClosedLoop: matrix rotatio of the closed loops
%   OUTPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure) 
%   - Markers_set: set of markers (see the Documentation for the structure)
%   - num_cut: number of geometrical cut done in the osteo-articular model
%   - numClosedLoop: number of closed loop in the model
%   - p_ClosedLoop: position of the closed loops
%   - R_ClosedLoop: matrix rotatio of the closed loops
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

if nargin<10
    c={};
    ceq={};
end

%%
if j==0
    return;
end

%%
if Human_model(j).mother ~= 0
    i=Human_model(j).mother;
    
    % how many mother without cut
    num_solid=NbSolidUpstream(Human_model,j,1);
    
    % angle = alpha*qi if exist(linear_constraint) otherwise angle=qj
    if size(Human_model(j).linear_constraint) == [0 0]  % if joint coordinate is a function to another one
        angle=q(j);
    else
        angle=Human_model(j).linear_constraint(2)*q(Human_model(j).linear_constraint(1)); % qj=alpha*q
    end

    % if it is higher than N : we cut --> position of the cut: picoupure, rotation of the mother: Ricoupure
    if num_solid > 6
       Human_model(i).KinematicsCut=num_cut;
       
       
        eval(['p' num2str(num_cut) 'cut = sym([''p'' num2str(num_cut) ''cut''], [3 1]);'])
        eval(['R' num2str(num_cut) 'cut = sym([''R'' num2str(num_cut) ''cut''], [3 3]);'])
        for zz=1:3   % cut variables declariation
            eval(['assume(p' num2str(num_cut) 'cut(' num2str(zz) ',1),''real'');'])
            for z=1:3
                eval(['assume(R' num2str(num_cut) 'cut(' num2str(zz) ',' num2str(z) '),''real'');'])
            end
        end
            if Human_model(j).joint == 1    % pin joint
       Human_model(j).p=eval(['R' num2str(num_cut) 'cut'])*(k(i)*Human_model(j).b)+eval(['p' num2str(num_cut) 'cut']); % coordinate frame position
       Human_model(j).R=eval(['R' num2str(num_cut) 'cut'])*Rodrigues(Human_model(j).a,angle)*Rodrigues(Human_model(j).u,Human_model(j).theta); % coordinate frame orientation
            end
            if Human_model(j).joint == 2    % slide joint
       Human_model(j).p=eval(['R' num2str(num_cut) 'cut'])*(k(i)*Human_model(j).b + angle*Human_model(j).a)+eval(['p' num2str(num_cut) 'cut']);         
       Human_model(j).R=eval(['R' num2str(num_cut) 'cut'])*Rodrigues(Human_model(j).u,Human_model(j).theta);         
            end
       num_cut=num_cut+1; % number of the cut incrementation
    else   
            if Human_model(j).joint == 1    % pin joint
        Human_model(j).p=Human_model(i).R*(k(i)*Human_model(j).b)+Human_model(i).p; % coordinate frame position   
        Human_model(j).R=Human_model(i).R*Rodrigues(Human_model(j).a,angle)*Rodrigues(Human_model(j).u,Human_model(j).theta); % coordinate frame orientation
            end
            if Human_model(j).joint == 2    % slide joint
                
        Human_model(j).p=Human_model(i).R*(k(i)*Human_model(j).b + angle*Human_model(j).a)+Human_model(i).p;
        Human_model(j).R=Human_model(i).R*Rodrigues(Human_model(j).u,Human_model(j).theta);
            end
    end
    
    % If closed loopt
    if size(Human_model(j).ClosedLoop) ~= [0 0] %#ok<BDSCA>
        % we find the solid and the position where there was a cut
        name=Human_model(j).ClosedLoop;
        test=0;
        for pp=1:numel(Human_model)
            for kk=1:size(Human_model(pp).anat_position,1)
                if strcmp(name,Human_model(pp).anat_position(kk,1))
                    num_solid=pp;
                    num_markers=kk;
                    test=1;
                    break
                end
            end
            if test == 1
                break
            end
        end
        [solid_path1,solid_path2]=find_solid_path(Human_model,j,num_solid);
        [c{numClosedLoop},ceq{numClosedLoop}]=NonLinCon_ClosedLoop_Sym(Human_model,solid_path1,solid_path2,num_solid,num_markers,q,k);
%         s = Human_model(num_solid).c + Human_model(num_solid).anat_position{num_markers,2}; % position with respects to the position of the mother solid joint of the closed loop
%         [Human_model,p_ClosedLoop{numClosedLoop},R_ClosedLoop{numClosedLoop}] = ForwardKinematics_ClosedLoop(Human_model,1,s,solid_path,[0 0 0]',eye(3),q,k);
        numClosedLoop=numClosedLoop+1;
    end
    
end

%% Markers position computation
for m=1:numel(Markers_set)
    if Markers_set(m).exist
        if Markers_set(m).num_solid == j
            Markers_set(m).position_symbolic=(Human_model(j).p+Human_model(j).R*(k(j)*(Human_model(j).c+Human_model(Markers_set(m).num_solid).anat_position{Markers_set(m).num_markers,2}+p_adapt(sum([Markers_set(1:m).exist]),:)')));
        end
    end
end

[Human_model,Markers_set,num_cut,numClosedLoop,c,ceq]=Symbolic_ForwardKinematicsCoupure(Human_model,Markers_set,Human_model(j).sister,q,k,p_adapt,num_cut,numClosedLoop,c,ceq);
[Human_model,Markers_set,num_cut,numClosedLoop,c,ceq]=Symbolic_ForwardKinematicsCoupure(Human_model,Markers_set,Human_model(j).child,q,k,p_adapt,num_cut,numClosedLoop,c,ceq);

end