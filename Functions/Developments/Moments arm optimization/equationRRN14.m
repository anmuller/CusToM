function y=equationRRN14(a,q)

q1=q(:,1);
q2=q(:,2);
q3=q(:,3);
q4=q(:,4);


if size(a,1)<18
    a=[a ; zeros(18-size(a,1),1)];
    disp('Attention il manque des coeffs pour ce muscle (RRN14)');
end

y=a(1) + a(2)*q1 + a(3)*q1.^2 + a(4)*q1.^2 + a(5)*q2 + a(6)*q2.^3 +...
    a(7)*q2.^4 + a(8)*q3 + a(9)*q3.^2 + a(10)*q3.^3 + a(11)*q4 + ...
    a(12)*q4.^2 + a(13)*q4.^3 + a(14)*q4.^4 + a(15)*q1.*q2 +...
    a(16)*q1.^2.*q2 + a(17)*q1.*q2.^2 + a(18)*q2.*q3.^2;

y=y';


end