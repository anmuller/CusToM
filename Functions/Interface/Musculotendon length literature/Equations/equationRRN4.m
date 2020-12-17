function y=equationRRN4(a,q)

q1=q(:,1);
q2=q(:,2);


if size(a,1)<12
    a=[a ; zeros(12-size(a,1),1)];    
    disp('Attention il manque des coeffs pour ce muscle (RRN4)');
end

y=a(1) + a(2)*q1 + a(3)*q1.^2 + a(4)*q1.^3  + a(5)*q2 + a(6)*q2.^2 + a(7)*q2.^3+...
    a(8)*q1.*q2 + a(9)*q1.^2.*q2 + a(10)*q1.*q2.^2 + a(11)*q1.^3.*q2 + a(12)*q1.*q2.^3;


y=y';


end