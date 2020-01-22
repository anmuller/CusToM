function [Muscles]=LegMusclesTLEM_for_wrapping(Muscles,Signe)
% Definition of the leg muscle model
%   This model contains 166 muscles, actuating the hip, the knee and the
%   ankle joint
%
%   Based on:
%	-	V. Carbone et al., “TLEM 2.0 - A comprehensive musculoskeletal geometry 
%	dataset for subject-specific modeling of lower extremity,” 
%	J. Biomech., vol. 48, no. 5, pp. 734–741, 2015.
%
%   INPUT
%   - Muscles: set of muscles (see the Documentation for the structure)
%   - Signe: side of the leg model ('R' for right side or 'L' for left side)
%   OUTPUT
%   - Muscles: new set of muscles (see the Documentation for the structure)
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

if strcmp(Signe,'Right')
    Signe = 'R';
else
    Signe = 'L';
end

s=cell(0);

s=[s;{...
[Signe 'GluteusMaximusInferior1'],164.534,16.0048,[],0.056302,0,{['GluteusMaximusInferior1Origin1' Signe  'Pelvis'];['GluteusMaximusInferior1Insertion1' Signe  'Thigh']},{'Wrap' Signe 'Pelvis' 'GluteusMaximus'};...
[Signe 'GluteusMaximusInferior2'],164.534,16.0048,[],0.046707,0,{['GluteusMaximusInferior2Origin1' Signe  'Pelvis'];['GluteusMaximusInferior2Insertion1' Signe  'Thigh']},{'Wrap' Signe 'Pelvis' 'GluteusMaximus'};...
[Signe 'GluteusMaximusInferior3'],164.534,16.0048,[],0.071564,0,{['GluteusMaximusInferior3Origin1' Signe  'Pelvis'];['GluteusMaximusInferior3Insertion1' Signe  'Thigh']},{'Wrap' Signe 'Pelvis' 'GluteusMaximus'};...
[Signe 'GluteusMaximusInferior4'],164.534,16.0048,[],0.058949,0,{['GluteusMaximusInferior4Origin1' Signe  'Pelvis'];['GluteusMaximusInferior4Insertion1' Signe  'Thigh']},{'Wrap' Signe 'Pelvis' 'GluteusMaximus'};...
[Signe 'GluteusMaximusInferior5'],164.534,16.0048,[],0.081813,0,{['GluteusMaximusInferior5Origin1' Signe  'Pelvis'];['GluteusMaximusInferior5Insertion1' Signe  'Thigh']},{'Wrap' Signe 'Pelvis' 'GluteusMaximus'};...
[Signe 'GluteusMaximusInferior6'],164.534,16.0048,[],0.078605,0,{['GluteusMaximusInferior6Origin1' Signe  'Pelvis'];['GluteusMaximusInferior6Insertion1' Signe  'Thigh']},{'Wrap' Signe 'Pelvis' 'GluteusMaximus'};...
[Signe 'GluteusMaximusSuperior1'],85.414,12.6833,[],0.10677,0,{['GluteusMaximusSuperior1Origin1' Signe  'Pelvis'];['GluteusMaximusSuperior1Insertion1' Signe  'Thigh']},{'Wrap' Signe 'Pelvis' 'GluteusMaximus'};...
[Signe 'GluteusMaximusSuperior2'],85.414,12.6833,[],0.10446,0,{['GluteusMaximusSuperior2Origin1' Signe  'Pelvis'];['GluteusMaximusSuperior2Insertion1' Signe  'Thigh']},{'Wrap' Signe 'Pelvis' 'GluteusMaximus'};...
[Signe 'GluteusMaximusSuperior3'],85.414,12.6833,[],0.10123,0,{['GluteusMaximusSuperior3Origin1' Signe  'Pelvis'];['GluteusMaximusSuperior3Insertion1' Signe  'Thigh']},{'Wrap' Signe 'Pelvis' 'GluteusMaximus'};...
[Signe 'GluteusMaximusSuperior4'],85.414,12.6833,[],0.091809,0,{['GluteusMaximusSuperior4Origin1' Signe  'Pelvis'];['GluteusMaximusSuperior4Insertion1' Signe  'Thigh']},{'Wrap' Signe 'Pelvis' 'GluteusMaximus'};...
[Signe 'GluteusMaximusSuperior5'],85.414,12.6833,[],0.092831,0,{['GluteusMaximusSuperior5Origin1' Signe  'Pelvis'];['GluteusMaximusSuperior5Insertion1' Signe  'Thigh']},{'Wrap' Signe 'Pelvis' 'GluteusMaximus'};...
[Signe 'GluteusMaximusSuperior6'],85.414,12.6833,[],0.085671,0,{['GluteusMaximusSuperior6Origin1' Signe  'Pelvis'];['GluteusMaximusSuperior6Insertion1' Signe  'Thigh']},{'Wrap' Signe 'Pelvis' 'GluteusMaximus'};...
    }];


% Création de la structure
ff = fieldnames(Muscles);
cur_fnames={'name','f0','l0','Kt','ls','alpha0','path','wrap'};
for ii=1:length(cur_fnames)
    
    if ~contains(cur_fnames{ii},ff)
        [Muscles.(cur_fnames{ii})] = cell(numel(Muscles),1);
    end
end

Muscles=[Muscles;struct('name',{s{:,1}}','f0',{s{:,2}}','l0',{s{:,3}}',...
    'Kt',{s{:,4}}','ls',{s{:,5}}','alpha0',{s{:,6}}','path',{s{:,7}}','wrap',{s{:,8}}')]; %#ok<CCAT1>

end