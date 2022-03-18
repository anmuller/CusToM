function [C] = MomentArmsComputationInit(BiomechanicalModel,q0,dp)
% Computation of the moment arms matrix (numerical version)
%
%   INPUT
%   - Biomechanical model: osteo-articular model (see the Documentation for the structure)
%   - q : current coordinates of the model
%   - dp: differentiation step
%   - Ucall : is a unique call for finding
%   OUTPUT
%   - C: muscular coupling matrix (meaning, which muscle actuate which
%   joint)
%   - Clines: active joints (joints being actuated by muscles)
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

idxm=find([Muscles.exist]);
nmr=numel(idxm);

%
if length(q0)==numel(BiomechanicalModel.OsteoArticularModel(:)) && ~isempty(intersect({BiomechanicalModel.OsteoArticularModel.name},'root0'))  
    q=q0(1:end-6); %only degrees of freedom of the body, not the floating base.
else
    q=q0;
end

%% Computation of moment arms
R=zeros(nmr,length(q));%init R

%for i=1:nqred_unsix
for i=1:length(q)
    dq=zeros(length(q),1); %differentiation step vector
    dq(i)=dp;
    
    Lpdq=zeros(nmr,1);
    Lmdq=zeros(nmr,1);

    for j=1:nmr % for each muscle
        % compute the length of the muscle at q+dq
        Lpdq(j) = Muscle_lengthNum(Human_model,Muscles(idxm(j)),q+dq); 
        % compute the length of the muscle at q-dq
        Lmdq(j) = Muscle_lengthNum(Human_model,Muscles(idxm(j)),q-dq);
    end
    R(:,i)=(-Lpdq+Lmdq)/(2*dp); % it is -dl/dq
end


C=zeros(nmr,length(q));
%C=zeros(nmr,nqred_unsix);


for i=1:nmr
%    for j=1:nqred_unsix
    for j=1:length(q)
        if R(i,j)~=0
            C(i,j)=1;
        end
    end
end

[row,col] = find(C);
for i=unique(col)'
        
    
    liste = find(col==i);
    
    for k=liste'
BiomechanicalModel.M_pos = M_pos;
BiomechanicalModel.M_Bone = M_Bone;
BiomechanicalModel.N_pos = N_pos;
BiomechanicalModel.N_Bone = N_Bone;
end
        end
            N_pos(j,i) = Muscles(idxm(j)).num_markers(num_p2);
            
    end

            M_pos(j,i) = Muscles(idxm(j)).num_markers(num_p1); % number of the anatomical landmark in this solid
            N_Bone(j,i) = Muscles(idxm(j)).num_solid(num_p2);
                if sum(ismember(solid_1_path,i)) ||  sum(ismember(solid_2_path,i))
                    num_p2 = kk+1;
                    num_p1 = kk;
                    break;
            end
                end
            M_Bone(j,i) = Muscles(idxm(j)).num_solid(num_p1); % number of the solid which contains this position
            
                    Muscles(idxm(j)).num_solid(kk+1));
                [solid_1_path,solid_2_path]=find_solid_path(Human_model,...
            end
                
                    Muscles(idxm(j)).num_solid(kk),...
            for kk=1:length(Muscles(idxm(j)).num_solid)-1
        else
               
                N_Bone(j,i) = Muscles(idxm(j)).num_solid(num_p2);
                N_pos(j,i) = Muscles(idxm(j)).num_markers(num_p2);
                M_Bone(j,i) = Muscles(idxm(j)).num_solid(num_p1); % number of the solid which contains this position
                
                M_pos(j,i) = Muscles(idxm(j)).num_markers(num_p1); % number of the anatomical landmark in this solid
                    end
                        num_p1 = kk;
                        Muscles(idxm(j)).num_solid(kk+1));
                for kk=depk:length(Muscles(idxm(j)).num_solid)-1
                else
                end
                        break;
                    if sum(ismember(solid_1_path,i)) ||  sum(ismember(solid_2_path,i))
                        num_p2 = kk+1;
                        Muscles(idxm(j)).num_solid(kk),...
                    [solid_1_path,solid_2_path]=find_solid_path(Human_model,...
                    depk=1;
                end
                if Muscles(idxm(j)).num_solid(1) == Muscles(idxm(j)).num_solid(2)
                N_pos(j,i) = Muscles(idxm(j)).num_markers(num_p2);
                
                num_p2  = num_p2(1);
                    depk = 2;
            else
                
                N_Bone(j,i) = Muscles(idxm(j)).num_solid(num_p2);
                M_pos(j,i) = Muscles(idxm(j)).num_markers(num_p1); % number of the anatomical landmark in this solid
                M_Bone(j,i) = Muscles(idxm(j)).num_solid(num_p1); % number of the solid which contains this position
                
                num_p1 = num_p2-1;
            if  num_p2(1)~=1
        % Find concerned points
        if sum(ismember(Muscles(idxm(j)).num_solid,i))
            num_p2 =find(Muscles(idxm(j)).num_solid==i);
        
        j = row(k);
end