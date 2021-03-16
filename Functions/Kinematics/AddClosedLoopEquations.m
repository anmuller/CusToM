function BiomechanicalModel = AddClosedLoopEquations(BiomechanicalModel,varargin)
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

syms q qred real;

q = BiomechanicalModel.Generalized_Coordinates.q_complete;
qred = BiomechanicalModel.Generalized_Coordinates.q_red;

[solid_path1,solid_path2,num_solid,num_markers]=Data_ClosedLoop(HumanModel);

ConstraintEq =[];
%% Find constraint equations for closing the loop
if size(solid_path1)==[1 1]
    [~,ConstraintEq]=NonLinCon_ClosedLoop_Sym(HumanModel,solid_path1{1},solid_path2{1},num_solid,num_markers,q,ones(1,length(q)));
    ConstraintEq=ConstraintEq';
else
    ConstraintEq =[];
    for idx= 1:length(num_solid)
        [~,ConstraintEq1]=NonLinCon_ClosedLoop_Sym(HumanModel,solid_path1{idx},solid_path2{idx},num_solid(idx),num_markers(idx),q,ones(1,length(q)));
        ConstraintEq = [ConstraintEq ConstraintEq1'];
    end
end

if ~isempty(ConstraintEq)
    
    
    ConstraintEq = ConstraintEq';
    ConstraintEq = simplify(ConstraintEq);
    K=jacobian(ConstraintEq,qred);
    
    
    %% Find a first solution of constraints
    
    % Joint limits
    if isfield(BiomechanicalModel,'Generalized_Coordinates')
        q_map=BiomechanicalModel.Generalized_Coordinates.q_map;
        l_inf1=[HumanModel.limit_inf]';
        l_sup1=[HumanModel.limit_sup]';
        % to handle infinity
        ind_infinf=not(isfinite(l_inf1));
        ind_infsup=not(isfinite(l_sup1));
        % tip to handle inflinity with a complex number.
        l_inf1(ind_infinf)=1i;
        l_sup1(ind_infsup)=1i;
        % new indexing
        l_inf1=q_map'*l_inf1;
        l_sup1=q_map'*l_sup1;
        %find 1i to replay by inf
        l_inf1(l_inf1==1i)=-inf;
        l_sup1(l_sup1==1i)=+inf;
    else
        l_inf1=[HumanModel.limit_inf]';
        l_sup1=[HumanModel.limit_sup]';
    end
    
    middlestartingq= ( l_inf1+ l_sup1)/2+0.05;
    middlestartingq(isnan(middlestartingq))=0.05;
    fcctout =  matlabFunction(sum(ConstraintEq.^2),  'vars', {qred});
    options  = optimset('MaxFunEvals',300000,'MaxIter',300000 ,'Algorithm', 'interior-point','Display','off');
    oneqset = fmincon(fcctout ,middlestartingq, [], [], [], [], l_inf1, l_sup1,[],options);
    
    % fcctout =  matlabFunction(sum(ConstraintEq.^2),  'vars', {qred'});
    % options = optimoptions('particleswarm','SwarmSize',50,'HybridFcn',@fmincon,'PlotFcn','pswplotbestf');
    % x = particleswarm(fcctout,length(middlestartingq),l_inf1,l_sup1,options);
    
    %% Coordinate partitionning
    
    % Finding null columns (obvious independant coordinates)
    [~,col] = find(K);
    qindep = setdiff(1:length(qred), unique(col));
    qinddep =[];
    
    Kartisym = matlabFunction(K,  'vars', {qred});
    Karti = Kartisym(oneqset);
    
    % User choice
    if ~isempty(varargin)
        qinddep = varargin{1};
    end
    if length(qinddep) <  size(Karti,2) - rank(Karti)
        
        starting_columns = unique(col);
        
        nvK = K(:,starting_columns);
        
        Kartisym = matlabFunction(nvK,  'vars', {qred});
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
        
        qinddep = [useq'  nvq(rank(Karti) +1 : end)' qindep];
        qdep = setdiff(nvq,qinddep)';
        
        % Adding partitionning to BiomechanicalModel
        idxp = 1;
        Jv = jacobian(ConstraintEq,qred(qdep));
        BiomechanicalModel.ClosedLoopData(idxp).ConstraintEq = matlabFunction(ConstraintEq,  'vars', {qred});
        BiomechanicalModel.ClosedLoopData(idxp).Jv = matlabFunction(Jv,  'vars', {qred});
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
        BiomechanicalModel.ClosedLoopData(1).ConstraintEq = matlabFunction(ConstraintEq,  'vars', {qred});
        BiomechanicalModel.ClosedLoopData(1).Jv = matlabFunction(Jv,  'vars', {qred});
        BiomechanicalModel.ClosedLoopData(1).drivingqu = qinddep;
        BiomechanicalModel.ClosedLoopData(1).drivedqv = qdep;
        
    end
    
    BiomechanicalModel.ClosedLoopData(1).startingq0 = zeros(1,length(qred)) ;
    BiomechanicalModel.ClosedLoopData(1).startingq0(unique(col)) = oneqset(unique(col))';
    
    % Define startingq0 at the middle range of each joint
    
    middlestartingq=zeros(1,length(qred));
    middlestartingq(qinddep) =  ( l_inf1(qinddep)+ l_sup1(qinddep))/2+0.05;
    middlestartingq(isnan(middlestartingq))=0.05;
    BiomechanicalModel = ForwardKinematicsConstrained(BiomechanicalModel,middlestartingq);
    
end

end