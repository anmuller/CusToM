function y=equationRRN12(b,q)

q1=q(:,1);
q2=q(:,2);
q3=q(:,3);



if size(b,1)<22
    b=[b ; zeros(22-size(b,1),1)];    
    disp('Attention il manque des coeffs pour ce muscle (RRN12)');
end

c=b(1);
a=b(2:end);


y = c+a(1).*q2+a(2).*q3+a(3).*q2.^2+a(4).*q3.^2+a(5).*q2.^3+a(6).*q3.^3+a(7).*q1.*q2+a(8).*q2.*q3+a(9).*q1.*q2.*q3+a(10).*q1.^2.*q2+a(11).*q1.*q2.^2+a(12).*q2.^2.*q3+...
+a(13).*q1.*q3.^2+a(14).*q2.*q3.^2+a(15).*q1.^3.*q2+a(16).*q1.^3.*q3+a(17).*q1.*q2.^3+a(18).*q2.^3.*q3+a(19).*q1.*q3.^3+a(20).*q2.*q3.^3+a(21).*q1.^2.*q2.^2.*q3.^2;




y=y';


end





