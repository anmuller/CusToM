function out1 = LBHD_Position(in1,in2,in3,in4,in5,in6)
%LBHD_POSITION
%    OUT1 = LBHD_POSITION(IN1,IN2,IN3,IN4,IN5,IN6)

%    This function was generated by the Symbolic Math Toolbox version 8.7.
%    17-Nov-2021 17:55:38

R4cut1_1 = in6(28);
R4cut1_2 = in6(31);
R4cut1_3 = in6(34);
R4cut2_1 = in6(29);
R4cut2_2 = in6(32);
R4cut2_3 = in6(35);
R4cut3_1 = in6(30);
R4cut3_2 = in6(33);
R4cut3_3 = in6(36);
k_sym3 = in4(3,:);
k_sym8 = in4(8,:);
p4cut1 = in5(10);
p4cut2 = in5(11);
p4cut3 = in5(12);
p_adapt_sym22 = in4(44,:);
p_adapt_sym23 = in4(45,:);
q7 = in3(7,:);
q34 = in3(28,:);
q35 = in3(29,:);
q36 = in3(30,:);
t2 = cos(q7);
t3 = cos(q34);
t4 = cos(q35);
t5 = cos(q36);
t6 = sin(q7);
t7 = sin(q34);
t8 = sin(q35);
t9 = sin(q36);
t28 = k_sym8./5.0;
t32 = p_adapt_sym22./2.0e+1;
t33 = p_adapt_sym23./2.0e+1;
t35 = k_sym8.*(7.0./4.5e+2);
t39 = k_sym3.*7.777777777777778e-4;
t47 = k_sym3.*8.672222222222222e-2;
t10 = R4cut1_1.*t2;
t11 = R4cut1_3.*t2;
t12 = R4cut2_1.*t2;
t13 = R4cut2_3.*t2;
t14 = R4cut3_1.*t2;
t15 = R4cut3_3.*t2;
t16 = R4cut1_2.*t3;
t17 = R4cut2_2.*t3;
t18 = R4cut3_2.*t3;
t19 = R4cut1_1.*t6;
t20 = R4cut1_3.*t6;
t21 = R4cut2_1.*t6;
t22 = R4cut2_3.*t6;
t23 = R4cut3_1.*t6;
t24 = R4cut3_3.*t6;
t25 = R4cut1_2.*t7;
t26 = R4cut2_2.*t7;
t27 = R4cut3_2.*t7;
t34 = t28+1.0;
t43 = t32+7.0./9.0e+1;
t48 = t35+7.0./9.0e+1;
t55 = t33-4.9e+1./7.2e+2;
t56 = t39+3.888888888888889e-3;
t66 = t47+4.336111111111111e-1;
t29 = -t20;
t30 = -t22;
t31 = -t24;
t36 = t11+t19;
t37 = t13+t21;
t38 = t15+t23;
t40 = t10+t29;
t41 = t12+t30;
t42 = t14+t31;
t44 = t4.*t36;
t45 = t4.*t37;
t46 = t4.*t38;
t49 = t3.*t40;
t50 = t3.*t41;
t51 = t3.*t42;
t52 = t7.*t40;
t53 = t7.*t41;
t54 = t7.*t42;
t57 = -t52;
t58 = -t53;
t59 = -t54;
t60 = t25+t49;
t61 = t26+t50;
t62 = t27+t51;
t63 = t16+t57;
t64 = t17+t58;
t65 = t18+t59;
t67 = t8.*t63;
t68 = t8.*t64;
t69 = t8.*t65;
t70 = -t67;
t71 = -t68;
t72 = -t69;
t73 = t44+t70;
t74 = t45+t71;
t75 = t46+t72;
out1 = [p4cut1+R4cut1_2.*t66+t40.*t56-t48.*(t5.*t60-t9.*t73)+t34.*t43.*(t8.*t36+t4.*t63)+t34.*t55.*(t9.*t60+t5.*t73);p4cut2+R4cut2_2.*t66+t41.*t56-t48.*(t5.*t61-t9.*t74)+t34.*t43.*(t8.*t37+t4.*t64)+t34.*t55.*(t9.*t61+t5.*t74);p4cut3+R4cut3_2.*t66+t42.*t56-t48.*(t5.*t62-t9.*t75)+t34.*t43.*(t8.*t38+t4.*t65)+t34.*t55.*(t9.*t62+t5.*t75)];