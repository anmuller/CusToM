function [P1P2,P4P3] = MomentArmsComputationPreciseSym(BiomechanicalModel,qval)
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

NBoneMat = BiomechanicalModel.N_Bone;
NPosMat = BiomechanicalModel.N_pos;
MBoneMat = BiomechanicalModel.M_Bone;
MPosMat = BiomechanicalModel.M_pos;

%% Computation of moment arms
P1P2 = sym(zeros(nmr,length(q),3));%init
P4P3 = sym(zeros(nmr,length(q),3));%init

[Human_model.R] = deal(eye(3));
[Human_model.p] = deal([0 0 0]');
for j=1:numel(Human_model)
    Human_model(j).q=q(j); %#ok<*SAGROW>
end



for i=unique(col)'
    
    liste = find(col==i);
    
    for k=liste'
        
        j= row(k) ; % muscle indice
        
        
        M_Bone = MBoneMat(j,i);
        M_pos = MPosMat(j,i); % number of the anatomical landmark in this solid
        N_Bone = NBoneMat(j,i);
        N_pos = NPosMat(j,i);
        
        if M_Bone>N_Bone
            [solid1,solid2] = find_solid_path(Human_model,M_Bone,N_Bone);
        else
            [solid2,solid1] = find_solid_path(Human_model,N_Bone,M_Bone);
        end
        ppac=solid1(1);
        
        [Human_model] = ForwardPositions(Human_model,ppac);
        
        
        Human_model2 = Human_model;
        [Human_model2.R] = deal(zeros(3));
        [Human_model2.p] = deal([0 0 0]');
        
        if Human_model2(i).joint == 1
            Human_model2(i).R = Human_model(i).R*wedge(Human_model2(i).a);
        else
            Human_model2(i).p = Human_model(i).R*Human_model2(i).a;
        end
        
        Human_model2=ForwardPositions(Human_model2,Human_model2(i).child);
        
        P1 = Human_model(M_Bone).p + Human_model(M_Bone).R * (Human_model(M_Bone).c+  Human_model(M_Bone).anat_position{M_pos,2});
        P2 = Human_model(N_Bone).p + Human_model(N_Bone).R * (Human_model(N_Bone).c + Human_model(N_Bone).anat_position{N_pos,2});
        P3 = Human_model2(N_Bone).p + Human_model2(N_Bone).R*(Human_model(N_Bone).c + Human_model(N_Bone).anat_position{N_pos,2});
        P4 = Human_model2(M_Bone).p + Human_model2(M_Bone).R*(Human_model(M_Bone).c + Human_model(M_Bone).anat_position{M_pos,2});
        
        P1P2(j,i,:) = P1 - P2;
        P4P3(j,i,:) = P4 - P3;
        
    end
    
    
end




% beware that the matrix is finally nq*nm
%R=R';





end