function [Fopt] = PolynomialFunction(F0, Aeq, beq, Fmin, Fmax, fmincon_options, options, Fmaxbis, varargin)
% Optimization used for the force sharing problem: polynomial function
%   
%	Based on :
%	-Pedotti, A., Krishnan, V. V., & Stark, L., 1978. 
%	Optimization of muscle-force sequencing in human locomotion. Mathematical Biosciences, 38(1-2), 57-76.
%	-Herzog, W., 1987. 
%	Individual muscle force estimations using a non-linear optimal design. Journal of Neuroscience Methods, 21(2-4), 167-179.
%	-Happee, R., 1994. 
%	Inverse dynamic optimization including muscular dynamics, a new simulation method applied to goal directed movements. Journal of Biomechanics, 27(7), 953-960.
%
%   INPUT
%   - F0: initial solution
%   - Aeq / beq: matrix used for the equality contraints: Aeq*X=beq
%   - Fmin: lower bounds 
%   - Fmax: upper bounds
%   - fmincon_options: options for the fmincon optimization function
%   - options: degree of the polynomial function
%   - Fmaxbis: upper boundss
%   OUTPUT
%   - Fopt: solution of the optimization problem
%________________________________________________________
%
% Licence
% Toolbox distributed under 3-Clause BSD License
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

% Cost function
cost_function = @(F) sum((F./Fmaxbis).^(options));
% Optimization
Fopt = fmincon(cost_function,F0,[],[],Aeq,beq,Fmin,Fmax,[],fmincon_options);

end