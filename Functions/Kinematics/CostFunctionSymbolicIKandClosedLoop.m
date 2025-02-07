function [error] = CostFunctionSymbolicIKandClosedLoop(q,nb_cut,real_markers,f,list_function,list_function_markers,Rcut,pcut,startingq0,numqu,numqv,Jv,h)
% Cost function used for the inverse kinematics step using an optimization method
%   
%   INPUT
%   - q: vector of joint coordinates at a given instant
%   - nb_cut: number of geometrical cut done in the osteo-articular model
%   - real_markers: 3D position of experimental markers
%   - f: current frame
%   - list_function: list of functions used for the evaluation of the
%   geometrical cuts position 
%   - list_function_markers: list of functions used for the evaluation of the
%   markers position 
%   - Rcut: pre-initialization of Rcut
%   - pcut: pre-initialization of pcut
%   OUTPUT
%   - error: cost function value
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
for c=1:nb_cut
	[Rcut(:,:,c),pcut(:,:,c)]=list_function{c}(q,pcut,Rcut);
end

q = ForwardKConstrained(q,startingq0,numqu,numqv,Jv,h);

error=0;
for m=1:numel(list_function_markers)
    a= norm(list_function_markers{m}(q,pcut,Rcut) - real_markers(m).position(f,:)')^2;
    if ~isnan(a)
        error = error + a;
    end
end

end