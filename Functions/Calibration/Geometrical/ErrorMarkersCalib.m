function [error] = ErrorMarkersCalib(q,k,Human_model,real_markers,f,list_markers,Pelvis_position,Pelvis_rotation,Rcut,pcut)
% Computation of reconstruction error for the geometrical calibration
%   Computation of the distance between the position of each experimental 
%   marker and the position of the corresponded model marker
%
%   INPUT
%   - q: vector of joint coordinates at a given instant
%   - k: vector of homothety coefficient
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure)
%   - real_markers: 3D position of experimental markers
%   - f: current frame
%   - list_markers: list of the marker names
%   - Pelvis_position: position of the pelvis at the considered instant
%   - Pelvis_rotation: rotation of the pelvis at the considered instant
%   - Rcut: pre-initialization of Rcut
%   - pcut: pre-initialization of pcut
%   OUTPUT
%   - error: distance between the position of each experimental marker and
%   the position of the corresponded model marker
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

list_function=cell(max([Human_model.KinematicsCut]),1);
    for c=1:max([Human_model.KinematicsCut])
        list_function{c}=str2func(sprintf('f%dcut',c));
        if c==1          
        [Rcut(:,:,c),pcut(:,:,c)]=list_function{c}(Pelvis_position,Pelvis_rotation,q,k,[],[]);
        else
            [Rcut(:,:,c),pcut(:,:,c)]=list_function{c}(Pelvis_position,Pelvis_rotation,q,k,pcut,Rcut);
        end
    end

    error=zeros(numel(list_markers),1);
    for m=1:numel(list_markers)
        error(m,:) = norm(eval([list_markers{m} '_Position(Pelvis_position,Pelvis_rotation,q,k,pcut,Rcut)']) - real_markers(m).position(f,:)');
    end

end