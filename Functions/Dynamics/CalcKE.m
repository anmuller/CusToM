function KE=CalcKE(Human_model,j)
if j==0
    KE=0;
else
    c=Human_model(j).R*Human_model(j).c+Human_model(j).p;
    I=Human_model(j).R*Human_model(j).I*Human_model(j).R'; % Inertia tensor
    vc=(Human_model(j).v0+cross(Human_model(j).w,c));
    KE=0.5*Human_model(j).m*(vc'*vc)...
                    +0.5*Human_model(j).w'*(I*Human_model(j).w); % kinetic energy of the jth segment    
    KE=KE+CalcKE(Human_model,Human_model(j).sister)+CalcKE(Human_model,Human_model(j).child);
end
end