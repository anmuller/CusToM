function out1 = RTOE_Position(in1,in2,in3,in4,in5,in6)
%RTOE_POSITION
%    OUT1 = RTOE_POSITION(IN1,IN2,IN3,IN4,IN5,IN6)

%    This function was generated by the Symbolic Math Toolbox version 8.7.
%    17-Nov-2021 17:55:43

R3cut1_1 = in6(19);
R3cut1_2 = in6(22);
R3cut1_3 = in6(25);
R3cut2_1 = in6(20);
R3cut2_2 = in6(23);
R3cut2_3 = in6(26);
R3cut3_1 = in6(21);
R3cut3_2 = in6(24);
R3cut3_3 = in6(27);
k_sym11 = in4(11,:);
p3cut1 = in5(7);
p3cut2 = in5(8);
p3cut3 = in5(9);
q42 = in3(36,:);
t2 = cos(q42);
t3 = sin(q42);
t4 = k_sym11.*9.722222222222222e-4;
t5 = k_sym11.*3.616666666666667e-2;
t6 = k_sym11.*9.236111111111111e-3;
t7 = t4+4.861111111111111e-3;
t8 = t5+1.808333333333333e-1;
t9 = t6+4.618055555555556e-2;
mt1 = [p3cut1-t9.*(R3cut1_1./9.007199254740992e+15+R3cut1_2.*t2+R3cut1_3.*t3)-t8.*(-R3cut1_1+(R3cut1_2.*t2)./9.007199254740992e+15+(R3cut1_3.*t3)./9.007199254740992e+15)-t7.*(R3cut1_2.*t3-R3cut1_3.*t2),p3cut2-t9.*(R3cut2_1./9.007199254740992e+15+R3cut2_2.*t2+R3cut2_3.*t3)-t8.*(-R3cut2_1+(R3cut2_2.*t2)./9.007199254740992e+15+(R3cut2_3.*t3)./9.007199254740992e+15)-t7.*(R3cut2_2.*t3-R3cut2_3.*t2)];
mt2 = [p3cut3-t9.*(R3cut3_1./9.007199254740992e+15+R3cut3_2.*t2+R3cut3_3.*t3)-t8.*(-R3cut3_1+(R3cut3_2.*t2)./9.007199254740992e+15+(R3cut3_3.*t3)./9.007199254740992e+15)-t7.*(R3cut3_2.*t3-R3cut3_3.*t2)];
out1 = reshape([mt1,mt2],3,1);