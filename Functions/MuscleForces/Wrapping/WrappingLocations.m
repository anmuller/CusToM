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
end
