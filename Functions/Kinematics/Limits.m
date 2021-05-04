function lim=Limits(q,l_inf1,l_sup1)
% Limit penalisation for LM algorithm
%   
%   INPUT
%   - q: joint cooridnates
%   - l_inf1: lower bound
%   - l_sup1: upper bound
%   OUTPUT
%   - lim: limit penalisation
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

lim = zeros(length(q),1);

idxsup = q>l_sup1;
idxinf = q<l_inf1;
    
lim(idxsup)=(q(idxsup)-l_sup1(idxsup)).^2;
lim(idxinf)=(q(idxinf) - l_inf1(idxinf)).^2;

end