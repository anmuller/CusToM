function func=CostFunctionLMCalib(q,ik_function_objective,gamma,hclosedloophandle,zeta,hbutees,weights)
% Limit penalisation for LM algorithm
%   
%   INPUT
%   - q: vector of joint coordinates at a given instant
%   - positions : vector of experimental marker positions
%   - gamma: closed loop penalisation
%   - hclosedloophandle: closed loop function handle
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

    
    constraints=[];
    for k=1:length(hclosedloophandle)
        fonc = hclosedloophandle{k};
        constraints = [constraints ; fonc(q)];
    end
    newweights= repmat(weights,3,1);
    dX = newweights(:).*ik_function_objective(q);
    func = [ dX ; gamma*constraints(:) ; zeta*hbutees(q)];
    
end