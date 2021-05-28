function func=CostFunctionLM(q, f,gamma,hclosedloophandle,real_markers,list_function_markers,zeta,hbutees)
% Limit penalisation for LM algorithm
%   
%   INPUT
%   - q: vector of joint coordinates at a given instant
%   - f: current frame
%   - nb_cut: number of geometrical cut done in the osteo-articular model
%   - pcut: pre-initialization of pcut
%   - Rcut: pre-initialization of Rcut
%   - gamma: closed loop penalisation
%   - hclosedloophandle: closed loop function handle
%   - list_function: list of functions used for the evaluation of the
%   geometrical cuts position 
%   - real_markers: 3D position of experimental markers
%   - list_function_markers: list of functions used for the evaluation of the
%   markers position 
%   - zeta: bound penalisation
%   - hbutees: bound function handle
%   OUTPUT
%   - func: cost function for marker tracking with constraints and bounds
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________


 % cut evaluation
    [Rcut,pcut]=fcut(q);

    % dx
    for m=1:numel(list_function_markers)
        dX((m-1)*3+1:3*m,:) = real_markers(m).position(f,:)'-list_function_markers{m}(q,pcut,Rcut);
    end
    
    
    func = [ dX ; gamma*hclosedloophandle(q) ; zeta*hbutees(q)];
    
end