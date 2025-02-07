function BiomechanicalModel = AddClosedLoopandConstraintsEquations(BiomechanicalModel,k,varargin)
% Adding closed-loop equations to the biomechanical model for direct kinematics
%
%   INPUT
%   - BiomechanicalModel: musculoskeletal model
%   - k: vector of homothety coefficient
%   - varargin : vector of willing independant coordinates
%
%   OUTPUT
%   - BiomechanicalModel: musculoskeletal model
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

HumanModel = BiomechanicalModel.OsteoArticularModel;

syms q [length(HumanModel) 1] real;


[solid_path1,solid_path2,num_solid,num_markers]=Data_ClosedLoop(HumanModel);

%% Find constraint equations for closing the loop
if size(solid_path1)==[1 1]
    [~,ConstraintEq]=NonLinCon_ClosedLoop_Sym(HumanModel,solid_path1{1},solid_path2{1},num_solid,num_markers,q,k);
else
    ConstraintEq =[];
    for idx= 1:length(num_solid)
        [~,ConstraintEq1]=NonLinCon_ClosedLoop_Sym(HumanModel,solid_path1{idx},solid_path2{idx},num_solid(idx),num_markers(idx),q,k);
        ConstraintEq = [ConstraintEq ConstraintEq1'];
    end
end

%% Find constraint equations from kinematic dependancies

if isfield(BiomechanicalModel.OsteoArticularModel,'kinematic_dependancy')
    for iddx=1: length(BiomechanicalModel.OsteoArticularModel)-6*sum(strcmp('root0',{BiomechanicalModel.OsteoArticularModel.name}))
        if ~isempty(BiomechanicalModel.OsteoArticularModel(iddx).kinematic_dependancy)
            if BiomechanicalModel.OsteoArticularModel(iddx).kinematic_dependancy.active
                foncq= BiomechanicalModel.OsteoArticularModel(iddx).kinematic_dependancy.q;
                if length(BiomechanicalModel.OsteoArticularModel(iddx).kinematic_dependancy.Joint)==1
                    secondmember = foncq( eval( ['q',num2str(BiomechanicalModel.OsteoArticularModel(iddx).kinematic_dependancy.Joint)] ) );
                    ConstraintEq = [ConstraintEq eval(['q',num2str(iddx),'-',char(secondmember)])];
                else
                    if length(BiomechanicalModel.OsteoArticularModel(iddx).kinematic_dependancy.Joint)==2
                        secondmember = foncq( eval( ['q',num2str(BiomechanicalModel.OsteoArticularModel(iddx).kinematic_dependancy.Joint(1))]),...
                            eval( ['q',num2str(BiomechanicalModel.OsteoArticularModel(iddx).kinematic_dependancy.Joint(2))]));
                        ConstraintEq = [ConstraintEq eval(['q',num2str(iddx),'-',char(secondmember)])];
                    else
                        if length(BiomechanicalModel.OsteoArticularModel(iddx).kinematic_dependancy.Joint)==3
                            secondmember = foncq( eval( ['q',num2str(BiomechanicalModel.OsteoArticularModel(iddx).kinematic_dependancy.Joint(1))]),...
                                eval( ['q',num2str(BiomechanicalModel.OsteoArticularModel(iddx).kinematic_dependancy.Joint(2))]),...
                                eval( ['q',num2str(BiomechanicalModel.OsteoArticularModel(iddx).kinematic_dependancy.Joint(3))]) );
                            ConstraintEq = [ConstraintEq eval(['q',num2str(iddx),'-',char(secondmember)])];
                        end
                    end
                end
            end
        end
    end
end

ConstraintEq = ConstraintEq';
ConstraintEq = simplify(ConstraintEq);
K=jacobian(ConstraintEq,q);


%% Find a first solution of constraints
middlestartingq= ([HumanModel.limit_inf] + [HumanModel.limit_sup])/2+0.05;
middlestartingq(isnan(middlestartingq))=0.05;
fcctout =  matlabFunction(sum(ConstraintEq.^2),  'vars', {q});
options  = optimset('MaxFunEvals',300000,'MaxIter',300000 ,'Algorithm', 'interior-point','Display','off');
oneqset = fmincon(fcctout , ones(length(middlestartingq),1), [], [], [], [], [HumanModel.limit_inf], [HumanModel.limit_sup],[],options);


%% Coordinate partitionning

% Finding null columns (obvious independant coordinates)
[~,col] = find(K);
qindep = setdiff(1:length(q), unique(col));
qinddep =[];

Kartisym = matlabFunction(K,  'vars', {q});
Karti = Kartisym(oneqset);

% User choice
if ~isempty(varargin)
    qinddep = varargin{1};
end
if length(qinddep) <  size(Karti,2) - rank(Karti)
    
    starting_columns = unique(col);
    
    nvK = K(:,starting_columns);
    
    Kartisym = matlabFunction(nvK,  'vars', {q});
    Karti = Kartisym(oneqset);
    
    [~,~,P]= lu(Karti);
    
    % Bloc structure of Karti
    Karti = P*Karti;
    
    % Removing user coordinates from the partitioning
    if ~isempty(qinddep)
        if size(qinddep,2)>1 || size(qinddep,1)>2
            useqidx = find(sum( (starting_columns==qinddep),2));
        else
            useqidx = find((starting_columns==qinddep)' );
        end
    else
        useqidx = [];
    end
    
    useq = intersect(starting_columns,qinddep);
    nvidx = setdiff(1:length(starting_columns),useqidx);
    
    % Choosing independant and dependant coordinates from complete gaussian pivoting
    [~,Q2] = completepivoting(Karti(:,nvidx));
    nvq = Q2' * starting_columns(nvidx);
    
    qinddep = [useq'  nvq(rank(Karti) +1 : end)'];
    qdep = setdiff(nvq,qinddep)';
    
    % Adding partitionning to BiomechanicalModel
    
    syms qsymdep;
    qsymdep=[];
    for idx=1:length(qdep)
        qsymdep =[qsymdep eval( ['q',num2str(qdep(idx))])];
    end
    
    idxp = 1;
    Jv = jacobian(ConstraintEq,qsymdep);
    BiomechanicalModel.ClosedLoopData(idxp).ConstraintEq = matlabFunction(ConstraintEq,  'vars', {q});
    BiomechanicalModel.ClosedLoopData(idxp).Jv = matlabFunction(Jv,  'vars', {q});
    BiomechanicalModel.ClosedLoopData(idxp).drivingqu = qinddep;
    BiomechanicalModel.ClosedLoopData(idxp).drivedqv = qdep;
    
else
    
    qindep = [qindep'; qinddep];
    qdep = setdiff(unique(col),qindep);
    
    syms qsymdep;
    qsymdep=[];
    for idx=1:length(qdep)
        qsymdep =[qsymdep eval( ['q',num2str(qdep(idx))])];
    end
    
    Jv = jacobian(ConstraintEq,qsymdep);
    BiomechanicalModel.ClosedLoopData(1).ConstraintEq = matlabFunction(ConstraintEq,  'vars', {q});
    BiomechanicalModel.ClosedLoopData(1).Jv = matlabFunction(Jv,  'vars', {q});
    BiomechanicalModel.ClosedLoopData(1).drivingqu = qinddep;
    BiomechanicalModel.ClosedLoopData(1).drivedqv = qdep;
    
end

BiomechanicalModel.ClosedLoopData(1).startingq0 = zeros(length(HumanModel),1) ;
BiomechanicalModel.ClosedLoopData(1).startingq0(unique(col)) = oneqset(unique(col))';

% Define startingq0 at the middle range of each joint

middlestartingq=zeros(length(HumanModel),1);
middlestartingq(qinddep) = ([HumanModel(qinddep).limit_inf] + [HumanModel(qinddep).limit_sup])/2+0.05;
middlestartingq(isnan(middlestartingq))=0.05;
Temp = ForwardKinematicsConstrained(BiomechanicalModel,middlestartingq);
q=[Temp.OsteoArticularModel(1:numel(HumanModel)-6*sum(strcmp('root0',{HumanModel.name}))).q]';

BiomechanicalModel.ClosedLoopData(1).startingq0 = q;

end