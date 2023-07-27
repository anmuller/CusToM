function [kp_opt,crit,errorm,q0]=GeomCalibOptimization(k_init,weights,Nb_qred,nb_frame_calib,Base_position,Base_rotation,list_function,Rcut,pcut,real_markers_calib,nbcut,list_function_markers,Aeq_ik,beq_ik,l_inf,l_sup,Aeq_calib,beq_calib)
f = 1    ;  % initial frame
q0=zeros(Nb_qred,1);
q_value{1}=zeros(Nb_qred,nb_frame_calib);

ik_function_objective=@(qvar)CostFunctionSymbolicCalib(qvar,k_init,Base_position{f},Base_rotation{f},list_function ,Rcut,pcut,real_markers_calib,nbcut,list_function_markers,f,weights);


nonlcon=@(qvar)ClosedLoopCalib(Base_position{f},Base_rotation{f},qvar,k_init); % testé!

options1 = optimoptions(@fmincon,'Algorithm','interior-point','Display','off','TolFun',1e-4,'MaxFunEvals',2e5,'MaxIter',2e5);
options2 = optimoptions(@fmincon,'Algorithm','interior-point','Display','off','TolFun',1e-6,'MaxFunEvals',2e9,'MaxIter',2e9);
h = waitbar(0,['First iteration of Inverse Kinematics']);

[q_value{1}(:,f)] = fmincon(ik_function_objective,q0,[],[],Aeq_ik,beq_ik,l_inf,l_sup,nonlcon,options1);



optionsLM = optimset('Algorithm','Levenberg-Marquardt','Display','off','MaxIter',4e6,'MaxFunEval',5e6,'TolFun',1e-4);

buteehandle = @(q)  Limits(q,l_inf,l_sup);
gamma = 150;
zeta = 20;
waitbar(f/nb_frame_calib)
q_inter = zeros(Nb_qred,nb_frame_calib);
ik_function_objective=@(qvar) ErrorMarkersCalibLM(qvar,k_init,real_markers_calib,f,list_function_markers,Base_position{f},Base_rotation{f},Rcut,pcut,nbcut,list_function);
hclosedloophandle = {@(qvar)ClosedLoopCalib(Base_position{f},Base_rotation{f},qvar,k_init);  @(x) Aeq_ik*x - beq_ik} ;
fun = @(q) CostFunctionLMCalib(q,ik_function_objective,gamma,hclosedloophandle,zeta,buteehandle,weights);
[q_inter(:,f)] = lsqnonlin(fun,q_inter(:,f),[],[],optionsLM);
for f = 2:nb_frame_calib
    ik_function_objective=@(qvar) ErrorMarkersCalibLM(qvar,k_init,real_markers_calib,f,list_function_markers,Base_position{f},Base_rotation{f},Rcut,pcut,nbcut,list_function);
    hclosedloophandle = {@(qvar)ClosedLoopCalib(Base_position{f},Base_rotation{f},qvar,k_init);  @(x) Aeq_ik*x - beq_ik} ;
    fun = @(q) CostFunctionLMCalib(q,ik_function_objective,gamma,hclosedloophandle,zeta,buteehandle,weights);
    [q_inter(:,f)] = lsqnonlin(fun,q_inter(:,f-1),[],[],optionsLM);
    waitbar(f/nb_frame_calib)
end
q_value{1}= q_inter;
close(h)


% Error computation
errorm{1}=zeros(sum(weights~=0),nb_frame_calib);
for f=1:nb_frame_calib
    temp = weights.*ErrorMarkersCalib(q_value{1}(:,f),k_init,real_markers_calib,f,list_function_markers,Base_position{f},Base_rotation{f},Rcut,pcut,nbcut,list_function);
    [errorm{1}(:,f)] = temp(weights~=0);
end


%% Boundaries for setting variation limits
taille = length(beq_calib);
limit_inf_calib = -ones(taille,1);
limit_sup_calib = ones(taille,1);

g=1;
crit(:,g)=1; % stop criteria

kp_opt(:,g)=k_init;

while crit(:,g) > 0.05
    
    % Geometric parameters optimisation
    
    pk_function_objective=@(kp)OptCalibrationSymbolic(...
        q_value{g},kp,nb_frame_calib,Base_position,Base_rotation,real_markers_calib,list_function,Rcut,pcut,nbcut,list_function_markers,weights);
    
    [kp_opt(:,g+1)] = fmincon(pk_function_objective,kp_opt(:,g),[],[],Aeq_calib,beq_calib,limit_inf_calib,limit_sup_calib,[],options2);
    
    q_value{g+1}=zeros(size(q_value{g})); %#ok<AGROW>
    q_inter=q_value{g};
    % Articular coordinates optimisation
    
    kp_g = kp_opt(:,g+1);
    parfor f =1:nb_frame_calib
        ik_function_objective=@(qvar) ErrorMarkersCalibLM(qvar,kp_g,real_markers_calib,f,list_function_markers,Base_position{f},Base_rotation{f},Rcut,pcut,nbcut,list_function);
        
        hclosedloophandle = {@(qvar)ClosedLoopCalib(Base_position{f},Base_rotation{f},qvar,kp_g);  @(x) Aeq_ik*x - beq_ik} ;

        fun = @(q) CostFunctionLMCalib(q,ik_function_objective,gamma,hclosedloophandle,zeta,buteehandle,weights);
        [q_inter(:,f)] = lsqnonlin(fun,q_inter(:,f),[],[],optionsLM);
    end
    q_value{g+1} = q_inter;
    
    % Error computation
    errorm{g+1}=zeros(length(real_markers_calib),nb_frame_calib); %#ok<AGROW>
    for f=1:nb_frame_calib
        
        [errorm{g+1}(:,f)] = ErrorMarkersCalib(q_value{g+1}(:,f),kp_opt(:,g+1),real_markers_calib,f,list_function_markers,Base_position{f},Base_rotation{f},Rcut,pcut,nbcut,list_function);
        
    end
    
    % Stop criteria
    crit(:,g+1)=abs(mean(mean(errorm{g+1}))-mean(mean(errorm{g})))/mean(mean(errorm{g}));
    
    g=g+1;
end

q0 = q_value{g-1}(:,1);

end