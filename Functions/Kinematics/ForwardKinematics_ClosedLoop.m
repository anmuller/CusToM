function [Human_model,p,R] = ForwardKinematics_ClosedLoop(Human_model,n,s,solid_path,p,R,q,k,radius)
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
%   - radius : vector of ellipsoid radius
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
if n ~= 0
    % if n~=(numel(solid_path))
    j=solid_path(n); % num�ro du solide
    i=Human_model(j).mother; % num�ro de la m�re

    if size(Human_model(j).linear_constraint) == [0 0]  % si coordonn�e articulaire fonction lin�aire d'une autre coordonn�e articulaire
        angle=q(j);
    else
        angle=Human_model(j).linear_constraint(2)*q(Human_model(j).linear_constraint(1)); % qj=alpha*q
    end

    %ajout parafencing pour palier a la contrainte qui ne depend pas de
    %la gueule de l'ellipse je crois

    switch Human_model(j).name
        case 'RScapuloThoracic_J1'
            
            if sum(contains({Human_model.name},'RScapuloThoracic_Jalpha'))
                [~,idx_theta1] = intersect({Human_model.name},'RScapuloThoracic_J4');
                [~,idx_theta2] = intersect({Human_model.name},'RScapuloThoracic_J5bis');
                angle= -radius(1)*cos(q(idx_theta1))*cos(q(idx_theta2)); %jmettrais bien un moins ici pr correspondre au x de la
            else
                %theta elevation
                [~,idx_theta] = intersect({Human_model.name},'RScapuloThoracic_J4');
                %phi abduction
                [~,idx_phi] = intersect({Human_model.name},'RScapuloThoracic_J5');
                
                
                angle= -radius(1)*cos(q(idx_theta))*cos(q(idx_phi));
            end
            
        case 'RScapuloThoracic_J2'
            if sum(contains({Human_model.name},'RScapuloThoracic_Jalpha'))
                
                [~,idx_theta2] = intersect({Human_model.name},'RScapuloThoracic_J5bis');
                angle= radius(2)*sin(q(idx_theta2));
                
            else
                
                %theta elevation
                [~,idx_theta] = intersect({Human_model.name},'RScapuloThoracic_J4');
                
                angle= radius(2)*sin(q(idx_theta));
                
            end
        case 'RScapuloThoracic_J3'
            
            
            if sum(contains({Human_model.name},'RScapuloThoracic_Jalpha'))
                
                [~,idx_theta1] = intersect({Human_model.name},'RScapuloThoracic_J4');
                [~,idx_theta2] = intersect({Human_model.name},'RScapuloThoracic_J5bis');
                angle= radius(3)*sin(q(idx_theta1))*cos(q(idx_theta2));
                
            else
                
                %theta elevation
                [~,idx_theta] = intersect({Human_model.name},'RScapuloThoracic_J4');
                %phi abduction
                [~,idx_phi] = intersect({Human_model.name},'RScapuloThoracic_J5');
                
                angle=radius(3)*cos(q(idx_theta))*sin(q(idx_phi));
            end
            
        case 'LScapuloThoracic_J1'
            
            
            if sum(contains({Human_model.name},'LScapuloThoracic_Jalpha'))
                [~,idx_theta1] = intersect({Human_model.name},'LScapuloThoracic_J4');
                [~,idx_theta2] = intersect({Human_model.name},'LScapuloThoracic_J5bis');
                angle= radius(4)*cos(q(idx_theta1))*cos(q(idx_theta2));
                
            else
                
                %theta elevation
                [~,idx_theta] = intersect({Human_model.name},'LScapuloThoracic_J4');
                %phi abduction
                [~,idx_phi] = intersect({Human_model.name},'LScapuloThoracic_J5');
                
                angle= -radius(4)*cos(q(idx_theta))*cos(q(idx_phi));
                
                
                
            end
            
        case 'LScapuloThoracic_J2'
            
            
            if sum(contains({Human_model.name},'LScapuloThoracic_Jalpha'))
                
                [~,idx_theta2] = intersect({Human_model.name},'LScapuloThoracic_J5bis');
                angle= radius(5)*sin(q(idx_theta2));
                
            else
                
                %theta elevation
                [~,idx_theta] = intersect({Human_model.name},'LScapuloThoracic_J4');
                
                angle=radius(5)*sin(q(idx_theta));
                
            end
            
        case 'LScapuloThoracic_J3'
            
            if sum(contains({Human_model.name},'LScapuloThoracic_Jalpha'))
                
                [~,idx_theta1] = intersect({Human_model.name},'LScapuloThoracic_J4');
                [~,idx_theta2] = intersect({Human_model.name},'LScapuloThoracic_J5bis');
                angle= -radius(6)*sin(q(idx_theta1))*cos(q(idx_theta2));
                
            else
                
                %theta elevation
                [~,idx_theta] = intersect({Human_model.name},'LScapuloThoracic_J4');
                %phi abduction
                [~,idx_phi] = intersect({Human_model.name},'LScapuloThoracic_J5');
                
                angle=-radius(6)*cos(q(idx_theta))*sin(q(idx_phi));
                
                
            end
            
            
        case 'RScapuloThoracic_J5'
            if sum(contains({Human_model.name},'RScapuloThoracic_Jalpha'))
                
                [~,idx_theta1] = intersect({Human_model.name},'RScapuloThoracic_J4');
                [~,idx_theta2] = intersect({Human_model.name},'RScapuloThoracic_J5bis');
                angle = atan(-(radius(1)*radius(3)*tan(q(idx_theta2))*(1 + tan(q(idx_theta1))^2))/(radius(3)*radius(2)+radius(1)*radius(2)*tan(q(idx_theta1))^2));
                
            end
            
        case 'RScapuloThoracic_Jalpha'
            [~,idx_theta1] = intersect({Human_model.name},'RScapuloThoracic_J4');
            [~,idx_theta2] = intersect({Human_model.name},'RScapuloThoracic_J5bis');
            phi= atan(-(radius(1)*radius(3)*tan(q(idx_theta2))*(1 + tan(q(idx_theta1))^2))/(radius(3)*radius(2)+radius(1)*radius(2)*tan(q(idx_theta1))^2));
            angle= atan(tan(q(idx_theta1))*(-radius(2)/radius(3)*sin(phi)/tan(q(idx_theta2))-cos(phi)));
            
            
        case 'LScapuloThoracic_J5'
            if sum(contains({Human_model.name},'LScapuloThoracic_Jalpha'))
                
                [~,idx_theta1] = intersect({Human_model.name},'LScapuloThoracic_J4');
                [~,idx_theta2] = intersect({Human_model.name},'LScapuloThoracic_J5bis');
                angle = atan(-(radius(4)*radius(6)*tan(q(idx_theta2))*(1 + tan(q(idx_theta1))^2))/(radius(6)*radius(5)+radius(4)*radius(5)*tan(q(idx_theta1))^2));
                
            end
            
        case 'LScapuloThoracic_Jalpha'
            
            [~,idx_theta1] = intersect({Human_model.name},'LScapuloThoracic_J4');
            [~,idx_theta2] = intersect({Human_model.name},'LScapuloThoracic_J5bis');
            phi=atan(-(radius(4)*radius(6)*tan(q(idx_theta2))*(1 + tan(q(idx_theta1))^2))/(radius(6)*radius(5)+radius(4)*radius(5)*tan(q(idx_theta1))^2));
            angle= atan(tan(q(idx_theta1))*(-radius(5)/radius(6)*sin(phi)/tan(q(idx_theta2))-cos(phi)));
            
            
    end
%     %Rscapula
%     if j==10
% 
%         [~,idx_theta1] = intersect({Human_model.name},'RScapuloThoracic_J4');
%         [~,idx_theta2] = intersect({Human_model.name},'RScapuloThoracic_J5bis');
%         angle= -radius(1)*cos(q(idx_theta1))*cos(q(idx_theta2)); %jmettrais bien un moins ici pr correspondre au x de la
%     end
% 
% 
%     if j==11
% 
%         [~,idx_theta2] = intersect({Human_model.name},'RScapuloThoracic_J5bis');
%         angle= radius(2)*sin(q(idx_theta2));
%     end
% 
%     if j==12
%         [~,idx_theta1] = intersect({Human_model.name},'RScapuloThoracic_J4');
%         [~,idx_theta2] = intersect({Human_model.name},'RScapuloThoracic_J5bis');
%         angle= radius(3)*sin(q(idx_theta1))*cos(q(idx_theta2));
%     end

%     %LScapula
%      if j==25
% 
%         [~,idx_theta1] = intersect({Human_model.name},'RScapuloThoracic_J4');
%         [~,idx_theta2] = intersect({Human_model.name},'RScapuloThoracic_J5bis');
%         angle= -radius(1)*cos(q(idx_theta1))*cos(q(idx_theta2)); %jmettrais bien un moins ici pr correspondre au x de la
%     end
% 
% 
%     if j==26
% 
%         [~,idx_theta2] = intersect({Human_model.name},'RScapuloThoracic_J5bis');
%         angle= radius(2)*sin(q(idx_theta2));
%     end
% 
%     if j==27
%         [~,idx_theta1] = intersect({Human_model.name},'RScapuloThoracic_J4');
%         [~,idx_theta2] = intersect({Human_model.name},'RScapuloThoracic_J5bis');
%         angle= radius(3)*sin(q(idx_theta1))*cos(q(idx_theta2));
%     end
    %fin ajout


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

[Human_model,p,R] = ForwardKinematics_ClosedLoop(Human_model,n,s,solid_path,p,R,q,k,radius);

end