function J_marqueurs = JacobianMarker(q,pcut,Rcut,Jfq,indexesNumericJfq , nonNumericJfq ,Jfcut,indexesNumericJfcut,nonNumericJfcut ,Jcutq ,...
                                                                   indexesNumericJcutq ,nonNumericJcutq, Jcutcut , indexesNumericJcutcut , nonNumericJcutcut)

        % Jfq
        Jfq(indexesNumericJfq) = nonNumericJfq(q,pcut,Rcut);
        % Jfcut
        Jfcut(indexesNumericJfcut) = nonNumericJfcut(q,pcut,Rcut);
        % Jcutq
        Jcutq(indexesNumericJcutq) = nonNumericJcutq(q,pcut,Rcut);
        % Jcutcut
        Jcutcut(indexesNumericJcutcut) = nonNumericJcutcut(q,pcut,Rcut);
        % J
        J_marqueurs = sparse(Jfq + Jfcut*dJcutq(Jcutcut,Jcutq));                                 

                                                               
                                                               
end