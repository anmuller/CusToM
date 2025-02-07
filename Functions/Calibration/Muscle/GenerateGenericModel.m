function BiomechanicalModel=GenerateGenericModel(ModelParameters)

ModelParameters.Size=1.80;

%% Generation of Generic musculoskeletal model with homothetic factor 1
[BiomechanicalModel.OsteoArticularModel, BiomechanicalModel.Markers, BiomechanicalModel.Muscles] = ModelGeneration(ModelParameters);

% %% Symbolic functions
% disp('Preliminary Computations ...')
% [BiomechanicalModel.OsteoArticularModel] = Add6dof(BiomechanicalModel.OsteoArticularModel);
% [BiomechanicalModel.OsteoArticularModel, BiomechanicalModel.Jacob,~,...
%     BiomechanicalModel.Generalized_Coordinates] = SymbolicFunctionGenerationIK(BiomechanicalModel.OsteoArticularModel,BiomechanicalModel.Markers);
% disp('... Preliminary Computations done')

%% Adding 6 DOF joint (pelvis to world)
[BiomechanicalModel.OsteoArticularModel] = Add6dof(BiomechanicalModel.OsteoArticularModel);
s_root=find([BiomechanicalModel.OsteoArticularModel.mother]==0);
if ~isempty([BiomechanicalModel.Muscles])
    if ~isempty([BiomechanicalModel.Muscles.wrap]')
        BiomechanicalModel = WrappingLocations(BiomechanicalModel);
    end
end
end