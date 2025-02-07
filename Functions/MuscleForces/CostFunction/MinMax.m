function [Aopt] = MinMax(A0, Aeq, beq, Amin, Amax, fmincon_options, ~, ~, ~, varargin)
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
cost_function = @(A) A(1);
% optimization
Aeqbis=[zeros(size(Aeq,1),1) Aeq];
Aopt_inter = fmincon(cost_function,[1;A0],[],[],Aeqbis,beq,[0;Amin],[Inf;Amax],@(A) constraint_minmax(A),fmincon_options);
Aopt=Aopt_inter(2:end,:);
end

function [g,h] = constraint_minmax(A)
    % Constraint for min/max optimization
    g=A(2:end)-A(1);
    h=[];
end
