function [Human_model,Markers_set,num_cut,numClosedLoop,c,ceq]=...
Symbolic_ForwardKinematicsCoupure_A(Human_model,Markers_set,j,Q,k,p_adapt,alpha,num_cut,numClosedLoop,c,ceq)
% Computation of a symbolic forward kinematics 
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure) 
%   - Markers_set: set of markers (see the Documentation for the structure)
%   - j: current solid
%   - Q: vector of joint coordinates
%   - k: vector of homothety coefficient
%   - p_adapt: vector of variation of local model markers position
%   - alpha : joint axis of rotation
%   - num_cut: number of geometrical cut done in the osteo-articular model
%   - numClosedLoop: number of closed loop in the model
%   - p_ClosedLoop: position of the closed loops
%   - R_ClosedLoop: matrix rotatio of the closed loops
%   OUTPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure) 
%   - Markers_set: set of markers (see the Documentation for the structure)
%   - num_cut: number of geometrical cut done in the osteo-articular model
%   - numClosedLoop: number of closed loop in the model
%   - p_ClosedLoop: position of the closed loops
%   - R_ClosedLoop: matrix rotatio of the closed loops
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

if nargin<12
%     p_ClosedLoop={};
%     R_ClosedLoop={};
    c={};
    ceq={};
end

%%
if j==0
    return;
end

%%
if Human_model(j).mother ~= 0
    i=Human_model(j).mother;
    
    % regarder combien il y a de m�res avant (sans coupure) (how many Mothers/antecedent without finding a cut)
    num_solid=NbSolidUpstream(Human_model,j,1);
    
    % angle = alpha*qi si exist(linear_constraint) sinon angle=qj
    if size(Human_model(j).linear_constraint) == [0 0]  % si coordonn�e articulaire fonction lin�aire d'une autre coordonn�e articulaire (if an articular coordinate if function of another one)
        q=Q(j);
    else
        q=Human_model(j).linear_constraint(2)*Q(Human_model(j).linear_constraint(1)); % qj=alpha*q
    end
    
    %Axe
    %On fait varier la position de ces axes selon
    if ~isfield(Human_model,'v') || isempty(Human_model(j).v)
        axe = Human_model(j).a;
    else
        %Angles
        alpha_j=alpha(2*j-1:2*j);
        % Nouvel axe
        axe = Rodrigues(Human_model(j).v(:,2),alpha_j(2))*Rodrigues(Human_model(j).v(:,1),alpha_j(1))*Human_model(j).a;
    end
   
   
   
    % si c'est sup�rieur � 10 : alors on coupe --> position de la m�re picoupure, rotation de la m�re : Ricoupure
    % If > 10, then proceed to a cut in the chain => position of the Mother picoupure, rotation of the Mother Ricoupure
    if num_solid > 6 % mother : coupure
       Human_model(i).KinematicsCut=num_cut;
       
       
        eval(['p' num2str(num_cut) 'cut = sym([''p'' num2str(num_cut) ''cut''], [3 1]);'])
        eval(['R' num2str(num_cut) 'cut = sym([''R'' num2str(num_cut) ''cut''], [3 3]);'])
        for zz=1:3   % d�calaration des variables de coupure
            eval(['assume(p' num2str(num_cut) 'cut(' num2str(zz) ',1),''real'');'])
            for z=1:3
                eval(['assume(R' num2str(num_cut) 'cut(' num2str(zz) ',' num2str(z) '),''real'');'])
            end
        end
            if Human_model(j).joint == 1    % liaison pivot (pin joint)
%        Human_model(j).p=eval(['R' num2str(num_cut) 'cut'])*(k(i)*Human_model(j).b)+eval(['p' num2str(num_cut) 'cut']); % position du rep�re (reference frame position)
       Human_model(j).p=eval(['R' num2str(num_cut) 'cut'])*(k(i)*Human_model(j).b)+eval(['p' num2str(num_cut) 'cut']); % position du rep�re (reference frame position)
       Human_model(j).R=eval(['R' num2str(num_cut) 'cut'])*Rodrigues(axe,q)*Rodrigues(Human_model(j).u,Human_model(j).theta); % orientation du rep�re (reference frame orientation)
            end
            if Human_model(j).joint == 2    % liaison glissi�re (slide joint)
%        Human_model(j).p=eval(['R' num2str(num_cut) 'cut'])*(k(i)*Human_model(j).b + angle*Human_model(j).a)+eval(['p' num2str(num_cut) 'cut']);         
       Human_model(j).p=eval(['R' num2str(num_cut) 'cut'])*(k(i)*Human_model(j).b + q*axe)+eval(['p' num2str(num_cut) 'cut']);         
       Human_model(j).R=eval(['R' num2str(num_cut) 'cut'])*Rodrigues(Human_model(j).u,Human_model(j).theta);         
            end
       num_cut=num_cut+1; % incr�mentation du num�ro de coupure
    else   
            if Human_model(j).joint == 1    % liaison pivot (pin joint)
%         Human_model(j).p=Human_model(i).R*(k(i)*Human_model(j).b)+Human_model(i).p; % position du rep�re     
        Human_model(j).p=Human_model(i).R*(k(i)*Human_model(j).b)+Human_model(i).p; % position du rep�re     
%         Human_model(j).R=Human_model(i).R*Rodrigues(Human_model(j).a,angle)*Rodrigues(Human_model(j).u,Human_model(j).theta); % orientation du rep�re
        Human_model(j).R=Human_model(i).R*Rodrigues(axe,q)*Rodrigues(Human_model(j).u,Human_model(j).theta); % orientation du rep�re
            end
            if Human_model(j).joint == 2    % liaison glissi�re (slide joint)
%         Human_model(j).p = Human_model(i).R *( k(i)*Human_model(j).b + angle* Human_model(j).a) + Human_model(i).p;
        Human_model(j).p = Human_model(i).R *( k(i)*Human_model(j).b + q* axe ) + Human_model(i).p;
        % l'orientation de l'axe de rotation d�pend de a, et d'une
        % variation d'orientation
        Human_model(j).R = Human_model(i).R * Rodrigues( Human_model(j).u , Human_model(j).theta );
            end
    end
    
    % Si fermeture de boucle
    if size(Human_model(j).ClosedLoop) ~= [0 0] %#ok<BDSCA>
        % on trouve le solide et la position du point o� il y a eu la coupure
        % Finding the solid and the point�s position where the cut was performed
        name=Human_model(j).ClosedLoop;
        test=0;
        for pp=1:numel(Human_model)
            for kk=1:size(Human_model(pp).anat_position,1)
                if strcmp(name,Human_model(pp).anat_position(kk,1))
                    num_solid=pp;
                    num_markers=kk;
                    test=1;
                    break
                end
            end
            if test == 1
                break
            end
        end
        [solid_path1,solid_path2]=find_solid_path(Human_model,j,num_solid);
        [c{numClosedLoop},ceq{numClosedLoop}]=NonLinCon_ClosedLoop_Sym(Human_model,solid_path1,solid_path2,num_solid,num_markers,Q,k);
        numClosedLoop=numClosedLoop+1;
    end
    
end

%% Calcul de la position des marqueurs (computation of markers position)
for m=1:numel(Markers_set)
    if Markers_set(m).exist
        if Markers_set(m).num_solid == j
            Markers_set(m).position_symbolic=( Human_model(j).p + ...
                                    Human_model(j).R*(k(j)*( Human_model(j).c + Human_model(Markers_set(m).num_solid).anat_position{Markers_set(m).num_markers,2} + ...
                                    p_adapt(sum([Markers_set(1:m).exist]),:)') ) );
        end
    end
end

% [Human_model,Markers_set,num_cut,numClosedLoop,p_ClosedLoop,R_ClosedLoop]=Symbolic_ForwardKinematicsCoupure_A(Human_model,Markers_set,Human_model(j).sister,Q,k,p_adapt,alpha,num_cut,numClosedLoop,p_ClosedLoop,R_ClosedLoop);
% [Human_model,Markers_set,num_cut,numClosedLoop,p_ClosedLoop,R_ClosedLoop]=Symbolic_ForwardKinematicsCoupure_A(Human_model,Markers_set,Human_model(j).child,Q,k,p_adapt,alpha,num_cut,numClosedLoop,p_ClosedLoop,R_ClosedLoop);
[Human_model,Markers_set,num_cut,numClosedLoop,c,ceq]=Symbolic_ForwardKinematicsCoupure_A(Human_model,Markers_set,Human_model(j).sister,Q,k,p_adapt,alpha,num_cut,numClosedLoop,c,ceq);
[Human_model,Markers_set,num_cut,numClosedLoop,c,ceq]=Symbolic_ForwardKinematicsCoupure_A(Human_model,Markers_set,Human_model(j).child,Q,k,p_adapt,alpha,num_cut,numClosedLoop,c,ceq);

end