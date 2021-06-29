function [error] = ErrorMarkersIK(q,nb_cut,real_markers,f,list_markers,Rcut,pcut)
% Computation of reconstruction error for the inverse kinematics step
%   Computation of the distance between the position of each experimental 
%   marker and the position of the corresponded model marker
%
%   INPUT
%   - q: vector of joint coordinates at a given instant
%   - nb_cut: number of geometrical cut done in the osteo-articular model
%   - real_markers: 3D position of experimental markers
%   - f: current frame
%   - list_markers: list of the marker names
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
list_function=cell(nb_cut,1);
for c=1:nb_cut
    list_function{c}=str2func(sprintf('f%dcut',c));
    if c==1          
    [Rcut(:,:,c),pcut(:,:,c)]=list_function{c}(q,[],[]);
    else
        [Rcut(:,:,c),pcut(:,:,c)]=list_function{c}(q,pcut,Rcut);
    end
end

error=zeros(numel(list_markers),1);
for m=1:numel(list_markers)
    error(m,:) = norm(feval([list_markers{m} '_Position'],q,pcut,Rcut) - real_markers(m).position(f,:)');
end

end