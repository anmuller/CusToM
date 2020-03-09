function yp=derivee2(h,y)
% 2-order numerical derivative
%
%   INPUT
%   - h: time step
%   - y: input data
%   OUTPUT
%   - yp: output filtered data
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

k=size(y);%Size of vector y (or of matrix i y is a matrix)
n=k(1);% Numbre of samples
for i=1:k(2)
    yp(1,i)=(-y(3,i)+4*y(2,i)-3*y(1,i))/(2*h); % for the first term a forward 2nd order difference is used
    yp(n,i)=(3*y(n,i)-4*y(n-1,i)+y(n-2,i))/(2*h); % for the last terme, a backward 2nd order differenece is used
	yp(2:n-1,i) = (y(3:n,i)-y(1:n-2,i))/(2*h);% for other terms, a 2nd order difference is used
end
end