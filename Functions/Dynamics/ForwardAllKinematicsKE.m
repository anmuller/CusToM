function [Human_model] = ForwardAllKinematicsKE(Human_model,j)
% Computation of spacial position, velocity and kinetic energy
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure)
%   - j: current solid
%   OUTPUT
%   - Human_model: osteo-articular model with additional computations (see
%   the Documentation for the structure)
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

if j==0
    return;
end

%%
if j~=1
    i=Human_model(j).mother;
    %% Position et Orientation
    if Human_model(j).joint == 1    % pin joint
        
        Human_model(j).p=Human_model(i).R*Human_model(j).b+Human_model(i).p;
        Human_model(j).R=Human_model(i).R*Rodrigues(Human_model(j).a,Human_model(j).q)*Rodrigues(Human_model(j).u,Human_model(j).theta);
        c=Human_model(j).R*Human_model(j).c+Human_model(j).p;
    end
    if Human_model(j).joint == 2    % slide joint
        
        Human_model(j).p=Human_model(i).R*Human_model(j).b+Human_model(i).R*Human_model(j).a*Human_model(j).q+Human_model(i).p;
        Human_model(j).R=Human_model(i).R*Rodrigues(Human_model(j).u,Human_model(j).theta);
        c=Human_model(j).R*Human_model(j).c+Human_model(j).p;
    end
    
    %% Vitesse spatiale
    if Human_model(j).joint == 1    % pin joint
        
        sw=Human_model(i).R*Human_model(j).a;
        sv=cross(Human_model(j).p,sw);
        Human_model(j).w=Human_model(i).w+sw*Human_model(j).dq;
        Human_model(j).v0=Human_model(i).v0+sv*Human_model(j).dq;

    else
        if Human_model(j).joint == 2    % slide joint
            
            sv=Human_model(i).R*Human_model(j).a;
            Human_model(j).w=Human_model(i).w;
            Human_model(j).v0=Human_model(i).v0+sv*Human_model(j).dq ;

        end
    end

    %% Kinetic energy    
    I=Human_model(j).R*Human_model(j).I*Human_model(j).R'; % Inertia tensor
    vc=(Human_model(j).v0+cross(Human_model(j).w,c));
    Human_model(j).KE=0.5*Human_model(j).m*(vc'*vc)...
                    +0.5*Human_model(j).w'*(I*Human_model(j).w); % kinetic energy of the jth segment    
end
Human_model=ForwardAllKinematicsKE(Human_model,Human_model(j).sister);
Human_model=ForwardAllKinematicsKE(Human_model,Human_model(j).child);

end

