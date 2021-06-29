function [Q1,Q2] = completepivoting(K)
% Gives row and column permutation matrixce resulting from complete gaussian pivoting
%
%   INPUT
%   - K, a matrix of any kind
%   OUTPUT
%   - Q1 : row permutation matrix
%   - Q2 : column permutation matrix
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

A = K;
[m, n] = size(A);

h=1; %row
k=1; %column

Q1 = eye(m);
Q2 = eye(n);

while h<=m && k<=n
    [M,I]  = max((abs(A(h:end,k:end))));
    if h==m
        indrow = m;
        indcol= k+I-1;
    else
        [~,indcol] = max(M);
        indrow=I(indcol);
        indrow= h+indrow-1;
        indcol= k+indcol-1;
    end
    if abs(A(indrow,indcol))<1e-15
        break;
    else
        A([ h, indrow] , : ) = A([ indrow , h] ,: );
        A(:, [ k, indcol]  ) = A( : , [ indcol , k] );
        Q1([ h, indrow] , : ) = Q1([ indrow , h] ,: );
        Q2(:, [ k, indcol] ) = Q2( : , [ indcol , k] );
         for i= h+1:m
            f = A(i,k)/A(h,k);
            for j = 1:n
                A(i,j) = A(i,j) - A(h,j)*f;
            end
        end
   
        h=h+1;
        k=k+1;
    end
end

    



end
