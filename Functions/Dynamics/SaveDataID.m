function    SaveDataID(filename,InverseDynamicsResults,f6dof,t6dof,torques,FContactDyn)



InverseDynamicsResults.DynamicResiduals.f6dof = f6dof;
InverseDynamicsResults.DynamicResiduals.t6dof = t6dof; 
InverseDynamicsResults.JointTorques = torques; 
InverseDynamicsResults.ForceContactDynamics = FContactDyn;
    
 save([filename '/InverseDynamicsResults'],'InverseDynamicsResults');

end