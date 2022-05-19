function J = IK_Jacobian(q,pcut,Rcut,l_inf1,l_sup1,Aeq_ik,gamma,zeta,J_marqueurs_handle)

J_marqueurs = J_marqueurs_handle(q,pcut,Rcut);

J_closedloop =  Jacobian_closedloop(q,pcut,Rcut);

J_Aek = Aeq_ik;

idxsup = q>l_sup1;
idxinf = q<l_inf1;

J_handle = zeros(length(q));

J_handle(diag(idxsup)) =2*(q(idxsup) - l_sup1(idxsup));
J_handle(diag(idxinf)) =2*(q(idxinf) - l_inf1(idxinf));

J = [-J_marqueurs ; gamma*J_closedloop ; gamma*J_Aek ; zeta*J_handle];

end



