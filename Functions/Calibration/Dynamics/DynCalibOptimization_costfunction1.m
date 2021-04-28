function [y] = DynCalibOptimization_costfunction1(X,Human_model,frame_opti,q,dq,ddq,p_pelvis,r_pelvis,v0,w,dv0,dw,BW,H,external_forces,g,nbframe)
% Cost function for the inertial calibration
%   Cost function corresponds to the normalized sum of dynamic residuals
%   (forces and torques) 
%
%   INPUT
%   - X: optimization variables: geometrical parameters of the stadium solids
%   - Human_model: osteo-articular model (see the Documentation for the structure)
%   - frame_opti: number of frames to be used for the inertial calibration
%   - q: joint coordinates
%   - dq: joint velocities
%   - ddq: joint accelerations
%   - p_pelvis: position of the pelvis
%   - r_pelvis: rotation of the pelvis
%   - v0: linear velocity of the pelvis
%   - w: rotational velocity of the pelvis
%   - dv0: linear acceleration of the pelvis
%   - dw: rotational acceleration of the pelvis
%   - BW: body weight of the subject
%   - H: height of the subject
%   - external_forces: external forces applied on the subject
%   - g: vector of gravity
%   - nbframe: number of frames
%   OUTPUT
%   - y: cost function value
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

%% Model Actualisation based on X
%% Actualisation du modèle à partir de X
num_i=0;
for i=1:numel(Human_model)
    if numel(Human_model(i).L) ~= 0 % Pour les solides possédant le champ « L ». For solids with « L », indicating that a stadium solid is associated
        num_i=num_i+1;
        [Masse,Zc,Ix,Iy,Iz]=DynParametersComputation(1000,X(4*(num_i-1)+1),X(4*(num_i-1)+3),X(4*(num_i-1)+2),X(4*(num_i-1)+4),Human_model(i).ParamAnthropo.h);
        % Mass
        Human_model(i).m=Masse;
        % Center of mass
        if Human_model(i).ParamAnthropo.Typ == 1
        	DeltaZc = (Zc - Human_model(i).ParamAnthropo.Zc);
        else
        	DeltaZc = -(Zc - Human_model(i).ParamAnthropo.Zc);
        end
        Cy=Human_model(i).c(2) + DeltaZc;
        Human_model(i).c(2) = Cy;
        % Inertia
        Human_model(i).I = [Ix 0 0; 0 Iy 0; 0 0 Iz]; % - [Mass*Cy*Cy 0 0;0 0 0;0 0 Mass*Cy*Cy]; % We move the inertia matrix in G. (on déplace la matrice d'inertie en G)
    end
end

%% Dynamique inverse
%% Inverse dynamics
f6dof=zeros(3,nbframe);
t6dof0=zeros(3,nbframe);
t6dof=t6dof0;
for i=frame_opti
    % attribution à chaque articulation de la position/vitesse/accélération
    % setting position/speed/acceleration to each joint
    Human_model(1).p=p_pelvis(i,:)';
    Human_model(1).R=r_pelvis{i};
    Human_model(1).v0=v0(i,:)';
    Human_model(1).w=w(i,:)';
    Human_model(1).dv0=dv0(i,:)';
    Human_model(1).dw=dw(i,:)';    
    for j=2:numel(Human_model)
        Human_model(j).q=q(i,j); 
        Human_model(j).dq=dq(i,j);
        Human_model(j).ddq=ddq(i,j);
    end
    Human_model = ForwardAllKinematics(Human_model,1);
    [Human_model,f6dof(:,i),t6dof0(:,i)]=InverseDynamicsSolid(Human_model,external_forces(i).fext,g,1);
    % Computation of the effort in the 6DoF joint (moment change)
    % Calcul des efforts au niveau de la liaison 6DoF (transport du moment)
    t6dof(:,i) = t6dof0(:,i) + cross(f6dof(:,i),p_pelvis(i,:)'); 
end

%% Calcul de la fonction de cout
%% Computation of the cost function

y=(sum(sum(abs(f6dof(:,frame_opti)./BW).^2))+sum(sum(abs(t6dof(:,frame_opti)./(BW*H)).^2)))/numel(frame_opti);

end