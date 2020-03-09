function [Fopt] = MinMax(F0, Aeq, beq, Fmin, Fmax, fmincon_options, ~, Fmaxbis, varargin)
% Optimization used for the force sharing problem: min/max criteria
%
%	Based on:
%	- Rasmussen, J., Damsgaard, M., & Voigt, M., 2001. 
%	Muscle recruitment by the min/max criterion—a comparative numerical study. Journal of biomechanics, 34(3), 409-415.
%   
%   INPUT
%   - F0: initial solution
%   - Aeq / beq: matrix used for the equality contraints: Aeq*X=beq
%   - Fmin: lower bounds 
%   - Fmax: upper bounds
%   - fmincon_options: options for the fmincon optimization function
%   - Fmaxbis: upper boundss
%   OUTPUT
%   - Fopt: solution of the optimization problem
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

% cost fucntion
cost_function = @(F) F(1);
% optimization
Aeqbis=[zeros(size(Aeq,1),1) Aeq];
Fopt_inter = fmincon(cost_function,[1;F0],[],[],Aeqbis,beq,[0;Fmin],[Inf;Fmax],@(F) constraint_minmax(F,Fmaxbis),fmincon_options);
Fopt=Fopt_inter(2:end,:);
        
end

function [g,h] = constraint_minmax(F,Fmax)
    % Constraint for min/max optimization
    g=F(2:end)./Fmax-F(1);
    h=[];
end
