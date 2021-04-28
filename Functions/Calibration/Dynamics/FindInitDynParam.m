function [Human_model] = FindInitDynParam(Human_model)
% Identification of the stadium solid parameters from inertial parameters
%   
%   Based on:
%   - Yeadon M. R. The simulation of aerial movement - II. A mathematical inertia
%   model of the human body. Journal of Biomechanics, 23(1):67–74, 1990.
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the structure)
%   OUTPUT
%   - Human_model: osteo-articular model with additionnal stadium solid
%   parameters (see the Documentation for the structure)
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

%% On fixe des paramètres (cylindre)

nb_solid_opt = numel([Human_model.L]);

t1=zeros(nb_solid_opt,1);
t0=zeros(nb_solid_opt,1);
D=1000*ones(nb_solid_opt,1);

%% On cherche les dimensions géométriques pour coller aux données anthropométriques
%% Looking for geometrical dimensions for fitting with anthropometric data

num_solid_L = 0; % numéro du solide à optimiser (solid index)
for i=1:numel(Human_model) % Pour chaque solide (loop for each solid)
    if numel(Human_model(i).L) ~= 0 % For solids with « L », indicating that a stadium solid is associated. Pour les solides possédant le champ "L"
        num_solid_L = num_solid_L + 1;  % incrementation
        % Symbolic variables declaration
        syms('r0','real')
        syms('r1','real')
        % Anthropo data
            % mass
            MassAnthro = Human_model(i).m;
            % position centre de masse / center of mass position
                % on cherche la position des points / looking for points position
                for s=1:numel(Human_model) % pour chaque solide (loop for each solid)
                    for p=1:size(Human_model(s).anat_position,1) % fo each anatomic point of the solid (pour chaque position anatomique de ce solide)
                        if strcmp(Human_model(i).L{1,1},Human_model(s).anat_position{p,1})
                            N_Bone1 = s; % numéro du solide qui contient ce point (solid number to which this point belongs)
                            N_Point1 = p; % positionnement de la position anatomique dans ce solide (number of anatomical position within the anatomical position list)
                        elseif strcmp(Human_model(i).L{2,1},Human_model(s).anat_position{p,1})
                            N_Bone2 = s; % numéro du solide qui contient ce point (solid number to which this point belongs)
                            N_Point2 = p; % positionnement de la position anatomique dans ce solide (number of anatomical position within the anatomical position list)
                        end
                    end
                end
            ZcAnthro = distance_point_anthropo(N_Point1,N_Bone1,Human_model,zeros(numel(Human_model),1),i);
        % calcul de la hauteur / computation of height
        [h,Typ] = distance_point(N_Point1,N_Bone1,N_Point2,N_Bone2,Human_model,zeros(numel(Human_model),1));       
        % Equations à résoudre / equations to solve
        [Mass,Zc] = DynParametersComputation(D(num_solid_L),r0,t0(num_solid_L),r1,t1(num_solid_L),h);
        eq1 = Mass == MassAnthro;
        eq2 = Zc == ZcAnthro;
        sys=solve([eq1 eq2],[r0 r1]);
        % Evaluation de la bonne solution (r0 et r1 > 0)
        if ~isempty(sys.r0) % si il y a une solution (if the is a solution)
            for sol = 1:numel(sys.r0)
                if eval(sys.r0(sol))>=0 && eval(sys.r1(sol))>=0
                    r0 = eval(sys.r0(sol));
                    r1 = eval(sys.r1(sol));
                end
            end
        else % pas de solution : données inertielles nulles (no solution found: set inertia to 0)
            r0=0;
            r1=0;
        end
        % Sauvegarde des données dans le modèle (save within the model)
        Human_model(i).ParamAnthropo.r0 = r0;
        Human_model(i).ParamAnthropo.r1 = r1;
        Human_model(i).ParamAnthropo.t0 = t0(num_solid_L);
        Human_model(i).ParamAnthropo.t1 = t1(num_solid_L);
        Human_model(i).ParamAnthropo.D = D(num_solid_L);
        Human_model(i).ParamAnthropo.h = h;
        Human_model(i).ParamAnthropo.Zc = ZcAnthro;
        Human_model(i).ParamAnthropo.Typ = Typ;
    end
end

end
