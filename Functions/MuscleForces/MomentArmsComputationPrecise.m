function [R] = MomentArmsComputationPrecise(BiomechanicalModel,qval)
% Computation of the moment arms matrix (numerical version)
%
%   INPUT
%   - Biomechanical model: osteo-articular model (see the Documentation for the structure)
%   - q : current coordinates of the model
%   - dp: differentiation step
%   - Ucall : is a unique call for finding
%   OUTPUT
%   - R: moment arms matrix at the current frame
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
% Modification : Pierre Puchaud
%________________________________________________________
Human_model=BiomechanicalModel.OsteoArticularModel;
Muscles=BiomechanicalModel.Muscles;
% nq=numel(qval);

idxm=find([Muscles.exist]);
nmr=numel(idxm);

%
if length(qval)==numel(BiomechanicalModel.OsteoArticularModel(:)) && ~isempty(intersect({BiomechanicalModel.OsteoArticularModel.name},'root0'))
    q=qval(1:end-6); %only degrees of freedom of the body, not the floating base.
else
    q=qval;
end

if isfield(BiomechanicalModel,'Coupling')
    C=BiomechanicalModel.Coupling;
else
    C= ones(nmr,length(q));
end
[row,col] = find(C);

%% Computation of moment arms
R=zeros(nmr,length(q));%init R


Human_model(1).p=[0 0 0]';
Human_model(1).R=eye(3);
for j=1:numel(Human_model)
    Human_model(j).q=q(j); %#ok<*SAGROW>
end
[Human_model] = ForwardPositions(Human_model,1);


for i=unique(col)'
    
    liste = find(col==i);
    
    Human_model2 = Human_model;
    [Human_model2.R] = deal(zeros(3));
    [Human_model2.p] = deal([0 0 0]');
    
    if Human_model2(i).joint == 1
        Human_model2(i).R = Human_model(i).R*wedge(Human_model2(i).a);
    else
        Human_model2(i).p = Human_model(i).R*Human_model2(i).a;
    end
    
    Human_model2=ForwardPositions(Human_model2,Human_model2(i).child);
    
    for k=liste'
        
        j= row(k) ; % muscle indice
        
        % Find concerned points
        if sum(ismember(Muscles(idxm(j)).num_solid,i))
            num_p2 =find(Muscles(idxm(j)).num_solid==i);
            if  num_p2(1)~=1
                num_p2  = num_p2(1);
                num_p1 = num_p2-1;
                
                
                M_Bone = Muscles(idxm(j)).num_solid(num_p1); % number of the solid which contains this position
                M_pos = Muscles(idxm(j)).num_markers(num_p1); % number of the anatomical landmark in this solid
                N_Bone = Muscles(idxm(j)).num_solid(num_p2);
                N_pos = Muscles(idxm(j)).num_markers(num_p2);
                P1 = Human_model(M_Bone).p + Human_model(M_Bone).R * (Human_model(M_Bone).c+  Human_model(M_Bone).anat_position{M_pos,2});
                P2 = Human_model(N_Bone).p + Human_model(N_Bone).R * (Human_model(N_Bone).c + Human_model(N_Bone).anat_position{N_pos,2});
                P3 = Human_model2(N_Bone).p + Human_model2(N_Bone).R*(Human_model(N_Bone).c + Human_model(N_Bone).anat_position{N_pos,2});
                P4 = Human_model2(M_Bone).p + Human_model2(M_Bone).R*(Human_model(M_Bone).c + Human_model(M_Bone).anat_position{M_pos,2});
                
                
                
                R(j,i)= -1/norm(P1 - P2)*(P1 - P2)'*(P4 - P3);
                
                
            else
                if Muscles(idxm(j)).num_solid(1) == Muscles(idxm(j)).num_solid(2)
                    depk = 2;
                else
                    depk=1;
                end
                for kk=depk:length(Muscles(idxm(j)).num_solid)-1
                    [solid_1_path,solid_2_path]=find_solid_path(Human_model,...
                        Muscles(idxm(j)).num_solid(kk),...
                        Muscles(idxm(j)).num_solid(kk+1));
                    if sum(ismember(solid_1_path,i)) ||  sum(ismember(solid_2_path,i))
                        num_p2 = kk+1;
                        num_p1 = kk;
                        break;
                    end
                end
                
                
                M_Bone = Muscles(idxm(j)).num_solid(num_p1); % number of the solid which contains this position
                M_pos = Muscles(idxm(j)).num_markers(num_p1); % number of the anatomical landmark in this solid
                N_Bone = Muscles(idxm(j)).num_solid(num_p2);
                N_pos = Muscles(idxm(j)).num_markers(num_p2);
                P1 = Human_model(M_Bone).p + Human_model(M_Bone).R * Human_model(M_Bone).c + Human_model(M_Bone).R * Human_model(M_Bone).anat_position{M_pos,2};
                P2 = Human_model(N_Bone).p + Human_model(N_Bone).R * Human_model(N_Bone).c + Human_model(N_Bone).R * Human_model(N_Bone).anat_position{N_pos,2};
                P3 = Human_model2(N_Bone).p + Human_model2(N_Bone).R*(Human_model(N_Bone).c + Human_model(N_Bone).anat_position{N_pos,2});
                P4 = Human_model2(M_Bone).p + Human_model2(M_Bone).R*(Human_model(M_Bone).c + Human_model(M_Bone).anat_position{M_pos,2});
                
                R(j,i)= -1/norm(P1 - P2)*(P1 - P2)'*(P4 - P3);
                
                
                
            end
        else
            for kk=1:length(Muscles(idxm(j)).num_solid)-1
                [solid_1_path,solid_2_path]=find_solid_path(Human_model,...
                    Muscles(idxm(j)).num_solid(kk),...
                    Muscles(idxm(j)).num_solid(kk+1));
                if sum(ismember(solid_1_path,i)) ||  sum(ismember(solid_2_path,i))
                    num_p2 = kk+1;
                    num_p1 = kk;
                    break;
                end
            end
            
            M_Bone = Muscles(idxm(j)).num_solid(num_p1); % number of the solid which contains this position
            M_pos = Muscles(idxm(j)).num_markers(num_p1); % number of the anatomical landmark in this solid
            N_Bone = Muscles(idxm(j)).num_solid(num_p2);
            N_pos = Muscles(idxm(j)).num_markers(num_p2);
            P1 = Human_model(M_Bone).p + Human_model(M_Bone).R * Human_model(M_Bone).c + Human_model(M_Bone).R * Human_model(M_Bone).anat_position{M_pos,2};
            P2 = Human_model(N_Bone).p + Human_model(N_Bone).R * Human_model(N_Bone).c + Human_model(N_Bone).R * Human_model(N_Bone).anat_position{N_pos,2};
            P3 = Human_model2(N_Bone).p + Human_model2(N_Bone).R*(Human_model(N_Bone).c + Human_model(N_Bone).anat_position{N_pos,2});
            P4 = Human_model2(M_Bone).p + Human_model2(M_Bone).R*(Human_model(M_Bone).c + Human_model(M_Bone).anat_position{M_pos,2});
            
            
            
            R(j,i)= -1/norm(P1 - P2)*(P1 - P2)'*(P4 - P3);
            
            
            
        end
        
    end
    
    
end




% beware that the matrix is finally nq*nm
R=R';





end