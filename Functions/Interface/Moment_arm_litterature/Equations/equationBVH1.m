function y=equationBVH1(a,q)

q1=q(:,1);


y=polyval(flip(a),q1);

y=y';

end

