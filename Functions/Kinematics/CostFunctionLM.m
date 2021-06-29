function func=CostFunctionLM(q,positions,gamma,hclosedloophandle,zeta,hbutees,weights)
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


 % cut evaluation
    [Rcut,pcut]=fcut(q);

    newweights= repmat(weights,1,3)';
    % dx
    dX = newweights(:).*(-X_markers(q,pcut,Rcut) + positions);
    
    
    func = [ dX ; gamma*hclosedloophandle(q) ; zeta*hbutees(q)];
    
end