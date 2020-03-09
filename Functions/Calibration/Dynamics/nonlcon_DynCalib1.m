function [c,ceq] = nonlcon_DynCalib1(X,X0,Human_model,CalibOptiParameters,list_symmetry) %#ok<INUSD>
% Non-linear constraints for the inertial calibration
%   It corresponds to the limitation of the variation of the global mass
%
%   INPUT
%   - X: optimization variables (geometrical parameters of the stadium
%   solids)
%   - X0: initial solution
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure) 
%   - CalibOptiParameters: calibration parameters (coefficient of
%   variation)
%   - list_symmetry: list of symmetric solids
%   OUTPUT
%   - c: non-linear inequality constraints
%   - ceq: non-linear equality constraints
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

ceq = [];
c = [];

Masstot = 0;
Masstot0 = 0;

num_i=0;
for i = 1 : numel(Human_model)
    if numel(Human_model(i).L) ~= 0
        num_i = num_i+1;
        [Masse,Zc]=DynParametersComputation(1000,X(4*(num_i-1)+1),X(4*(num_i-1)+3),X(4*(num_i-1)+2),X(4*(num_i-1)+4),Human_model(i).ParamAnthropo.h);
        [Masse0,Zc0]=DynParametersComputation(1000,X0(4*(num_i-1)+1),X0(4*(num_i-1)+3),X0(4*(num_i-1)+2),X0(4*(num_i-1)+4),Human_model(i).ParamAnthropo.h);
        Masstot = Masstot + Masse;
        Masstot0 = Masstot0 + Masse0;
     end
end

if CalibOptiParameters.DeltaM ~= Inf
    c = [c; abs(Masstot-Masstot0)-CalibOptiParameters.DeltaM*Masstot0]; % abs(m-m0)<0.05*m0
end

end