function [Human_model] = ForwardAllKinematics(Human_model,j)
% Computation of spacial position, velocity and acceleration for each solid
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
    end
    if Human_model(j).joint == 2    % slide joint
        
        Human_model(j).p=Human_model(i).R*Human_model(j).b+Human_model(i).R*Human_model(j).a*Human_model(j).q+Human_model(i).p;
        Human_model(j).R=Human_model(i).R*Rodrigues(Human_model(j).u,Human_model(j).theta);
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
    %% Acc�l�ration spatiale
    if Human_model(j).joint == 1    % pin joint
        
        
        dsv=cross(Human_model(i).w,sv)+cross(Human_model(i).v0,sw);
        dsw=cross(Human_model(i).w,sw);
        Human_model(j).dw=Human_model(i).dw+dsw*Human_model(j).dq+sw*Human_model(j).ddq;
        Human_model(j).dv0=Human_model(i).dv0+dsv*Human_model(j).dq+sv*Human_model(j).ddq;
        Human_model(j).sw=sw;
        Human_model(j).sv=sv;
        
    else
        if Human_model(j).joint == 2    % slide joint
            
            dsv=cross(Human_model(i).w,sv);
            Human_model(j).dw=Human_model(i).dw;
            Human_model(j).dv0=Human_model(i).dv0+sv*Human_model(j).ddq+ dsv*Human_model(j).dq;
            Human_model(j).sw=0*sv;
            Human_model(j).sv=sv;
            
        end
    end
    
end
Human_model=ForwardAllKinematics(Human_model,Human_model(j).sister);
Human_model=ForwardAllKinematics(Human_model,Human_model(j).child);

end

