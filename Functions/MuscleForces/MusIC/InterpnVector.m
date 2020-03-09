function [Vq] = InterpnVector(X,V,Xq)
% Linear interpolation of m-dimensions vector in n-dimensions database
%
%   INPUT
%   - X: available coordinates in the database:  X ={X1;X2;...;Xn}
%   - V: coordinates values: n-dimensions cells
%   - Xq: coordinates to interpolate: Xq=[Xq1;Xq2;...;Xqn]
%   OUTPUT
%   - Vq: interpolated values
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

%% find the position in the table of data
Xqn = numel(Xq);
Position = cell(Xqn,1);
Pourcent = cell(Xqn,1);
for i=1:Xqn
    DiffVec = X{i,1}-Xq(i,1);
    pos_sup = max(find(DiffVec>=0,1),2);
    if isempty(pos_sup)
        pos_sup = numel(X{i,1});
    end
    % position
    Position{i,1} = [pos_sup-1 pos_sup];
    % percentage of placement with respect to their neighbors
    pourcent_inf = (Xq(i,1) - X{i,1}(pos_sup-1))/(DiffVec(pos_sup)-DiffVec(pos_sup-1));
    Pourcent{i,1} = [1-pourcent_inf pourcent_inf];
end

%% Linear interpolation computation

list_points = num2cell(cartprod(Position{:})); % points list
list_pourcent = cartprod(Pourcent{:});

ZPoints = zeros(size(list_points,1),numel(V{1}));
for i=1:size(ZPoints,1)
    ZPoints(i,:) = V{list_points{i,:}}';
end
Vq = ZPoints'*prod(list_pourcent,2);

end