function y=equationRRN3(a,q)

q1=q(:,1);
q2=q(:,2);


if size(a,1)<11
    a=[a ; zeros(11-size(a,1),1)];
    disp('Attention il manque des coeffs pour ce muscle (RRN3)');
end

y=a(1) + a(2)*q1 + a(3)*q1.^2 + a(4)*q1.^3  + a(5)*q2 + a(6)*q2.^2 + a(7)*q2.^3+...
    a(8)*q1.^4 + a(9)*q1.^5 + a(10)*q2.^4 + a(11)*q2.^5;


y=y';


end