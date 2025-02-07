function [BiomechanicalModel]=WrappingLocations(BiomechanicalModel)
% Location of where are wraps
%   INPUT
%   - BiomechanicalModel
%   OUTPUT
%   - BiomechanicalModel
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
OsteoArticularModel=BiomechanicalModel.OsteoArticularModel;

for ii=1:length(OsteoArticularModel)
    if ~isempty(OsteoArticularModel(ii).wrap)
        for jj=1:length(OsteoArticularModel(ii).wrap)
            % Num solid
            OsteoArticularModel(ii).wrap(jj).num_solid=ii;
            % find the number of the anat position
            [~,ind]=intersect(OsteoArticularModel(ii).anat_position(:,1),...
                OsteoArticularModel(ii).wrap(jj).anat_position);
            % save the anat position
            OsteoArticularModel(ii).wrap(jj).location = ...
                OsteoArticularModel(ii).anat_position{ind,2};
        end
    end
end
BiomechanicalModel.OsteoArticularModel=OsteoArticularModel;


%% Wrapping sides 
% Considering in anatomical position we are wrapping on the proper side.
q= zeros(numel(OsteoArticularModel),1);
Muscles = BiomechanicalModel.Muscles;
for ii=1:numel(Muscles)
    if Muscles(ii).exist && ~isempty(Muscles(ii).wrap) && ~isempty(Muscles(ii).wrap{1})
        %find the wrap
        Wrap = [OsteoArticularModel.wrap]; names = {Wrap.name}'; [~,ind]=intersect(names,Muscles(ii).wrap{1});
        cur_Wrap=Wrap(ind);
        for p=1:(numel(Muscles(ii).path)-1)
            % distance between p and p+1 point
            M_Bone = Muscles(ii).num_solid(p); % number of the solid which contains this position
            M_pos = Muscles(ii).num_markers(p); % number of the anatomical landmark in this solid
            N_Bone = Muscles(ii).num_solid(p+1);
            N_pos = Muscles(ii).num_markers(p+1);
            EnforcedWrap= 1;
            [~,~,wrapside]=distance_point_wrap(M_pos,M_Bone,N_pos,N_Bone,OsteoArticularModel,q,cur_Wrap,[],EnforcedWrap);
            BiomechanicalModel.Muscles(ii).wrapside=wrapside;
        end
    else
        BiomechanicalModel.Muscles(ii).wrapside=[];
    end
end

