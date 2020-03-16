function [Human_model,p,R] = ForwardKinematics_ClosedLoop(Human_model,n,s,solid_path,p,R,q,k)
% Computation of a symbolic forward kinematics
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure)
%   - n: current solid
%   - s: position of current solid in regards to articulation of parent
%   solid of closedloop
%   - solid_path: solid list included in the closed loop
%   - numClosedLoop: number of closed loop in the model
%   - p: position of the closed loops
%   - R: matrix rotatio of the closed loops
%   - q: vector of joint coordinates
%   - k: vector of homothety coefficient
%   OUTPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure)
%   - p: position of the closed loops
%   - R: matrix rotatio of the closed loops
%________________________________________________________
%
% Licence
% Toolbox distributed under GLP 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

if n==(numel(solid_path)+1) % quand on arrive au bout de la cha�ne
    p=p-k(solid_path(1))*s;   % le point extr�me est attach� � un point de coordonn�es s sur le solide de base
    return;
end

%% incr�mentation de la position et orientation
if n ~= 1
   % if n~=(numel(solid_path))
        j=solid_path(n); % num�ro du solide
        i=Human_model(j).mother; % num�ro de la m�re
        
        if size(Human_model(j).linear_constraint) == [0 0]  % si coordonn�e articulaire fonction lin�aire d'une autre coordonn�e articulaire
            angle=q(j);
        else
            angle=Human_model(j).linear_constraint(2)*q(Human_model(j).linear_constraint(1)); % qj=alpha*q
        end
        
        if Human_model(j).joint == 1    % liaison pivot
            p=R*(k(i)*Human_model(j).b)+p; % position du rep�re
            R=R*Rodrigues(Human_model(j).a,angle)*Rodrigues(Human_model(j).u,Human_model(j).theta); % orientation du rep�re
        end
        if Human_model(j).joint == 2    % liaison glissi�re
            p=R*(k(i)*Human_model(j).b + angle*Human_model(j).a)+p;
            R=R*Rodrigues(Human_model(j).u,Human_model(j).theta);
        end
        
 %   else
%         if n==(numel(solid_path)) && ~isempty(Human_model(solid_path(n)).ClosedLoop)
%             j=solid_path(n); % num�ro du solide
%             i=Human_model(j).mother; % num�ro de la m�re
%             
%             if size(Human_model(j).linear_constraint) == [0 0]  % si coordonn�e articulaire fonction lin�aire d'une autre coordonn�e articulaire
%                 angle=-q(j);
%             else
%                 angle=-Human_model(j).linear_constraint(2)*q(Human_model(j).linear_constraint(1)); % qj=alpha*q
%             end
%             
%             if Human_model(j).joint == 1    % liaison pivot
%                 p=R*(k(i)*Human_model(j).b)+p; % position du rep�re
%                 R=R*Rodrigues(Human_model(j).a,angle)*Rodrigues(Human_model(j).u,Human_model(j).theta); % orientation du rep�re
%             end
%             if Human_model(j).joint == 2    % liaison glissi�re
%                 p=R*(k(i)*Human_model(j).b + angle*Human_model(j).a)+p;
%                 R=R*Rodrigues(Human_model(j).u,Human_model(j).theta);
%             end
            
%        end
 %   end
end

n=n+1;

[Human_model,p,R] = ForwardKinematics_ClosedLoop(Human_model,n,s,solid_path,p,R,q,k);

end