function [Human_model] = Add6dof(Human_model)
% Addition of a 6 dof joint
%   A 6 dof joint (3 translations and 3 rotations) is added between the
%   global frame and the biomechanical model root
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure).
%   OUTPUT
%   - Human_model: osteo-articular model with the added 6 dof joint (see the
%   Documentation for the structure).
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

%% Numerotation incrementation and root parameters changement

s_root=find([Human_model.mother]==0); % number of the root solid
list_solid={'root0' '6dofTx' '6dofTy' '6dofTz' '6dofRx' '6dofRy'};  % list of the degrees of freedom
for i=1:numel(list_solid)  % numbers incrementation
    eval(['s_' list_solid{i} '=numel(Human_model)+i;'])    
end
% Adding the field mother to the root
eval(['Human_model(s_root).mother=s_' list_solid{end} ';'])
Human_model(s_root).a=[0 0 1]';
Human_model(s_root).limit_inf=-Inf;
Human_model(s_root).limit_sup=Inf;
Human_model(s_root).comment='Rotation - Z-Rotation - Anterior(-)/Posterior(+)';%
Human_model(s_root).FunctionalAngle = 'Rotation - Z-Rotation - Anterior(-)/Posterior(+)';%
%% Solids definition of the 6-dof joint

Human_model(s_root0).name='root0';   
Human_model(s_root0).sister=0;        
Human_model(s_root0).child=s_6dofTx; 
Human_model(s_root0).mother=0;                 
Human_model(s_root0).a=[0 0 0]';            
Human_model(s_root0).limit_inf=0;    
Human_model(s_root0).limit_sup=0;   
Human_model(s_root0).Visual=0;
Human_model(s_root0).m=0;                  
Human_model(s_root0).b=[0 0 0]';       
Human_model(s_root0).I=zeros(3,3);  
Human_model(s_root0).c=[0 0 0]';   
Human_model(s_root0).comment='';%
Human_model(s_root0).FunctionalAngle = ' ';%

Human_model(s_6dofTx).name='6dofTx';   
Human_model(s_6dofTx).sister=0;        
Human_model(s_6dofTx).child=s_6dofTy; 
Human_model(s_6dofTx).mother=s_root0;                 
Human_model(s_6dofTx).a=[1 0 0]';            
Human_model(s_6dofTx).joint=2;
Human_model(s_6dofTx).limit_inf=-Inf;    
Human_model(s_6dofTx).limit_sup=Inf; 
Human_model(s_6dofTx).Visual=0;
Human_model(s_6dofTx).m=0;                  
Human_model(s_6dofTx).b=[0 0 0]';       
Human_model(s_6dofTx).I=zeros(3,3);  
Human_model(s_6dofTx).c=[0 0 0]'; 
Human_model(s_6dofTx).comment='Antero-Posterior Translation';%
Human_model(s_6dofTx).FunctionalAngle = 'Antero-Posterior Translation';%

Human_model(s_6dofTy).name='6dofTy';   
Human_model(s_6dofTy).sister=0;        
Human_model(s_6dofTy).child=s_6dofTz; 
Human_model(s_6dofTy).mother=s_6dofTx;                 
Human_model(s_6dofTy).a=[0 1 0]';            
Human_model(s_6dofTy).joint=2;
Human_model(s_6dofTy).limit_inf=-Inf;    
Human_model(s_6dofTy).limit_sup=Inf; 
Human_model(s_6dofTy).Visual=0;
Human_model(s_6dofTy).m=0;                  
Human_model(s_6dofTy).b=[0 0 0]';       
Human_model(s_6dofTy).I=zeros(3,3);  
Human_model(s_6dofTy).c=[0 0 0]';  
Human_model(s_6dofTy).comment='Vertical Translation';%
Human_model(s_6dofTy).FunctionalAngle = 'Vertical Translation';%

Human_model(s_6dofTz).name='6dofTz';   
Human_model(s_6dofTz).sister=0;        
Human_model(s_6dofTz).child=s_6dofRx; 
Human_model(s_6dofTz).mother=s_6dofTy;                 
Human_model(s_6dofTz).a=[0 0 1]';            
Human_model(s_6dofTz).joint=2;
Human_model(s_6dofTz).limit_inf=-Inf;    
Human_model(s_6dofTz).limit_sup=Inf;
Human_model(s_6dofTz).Visual=0;
Human_model(s_6dofTz).m=0;                  
Human_model(s_6dofTz).b=[0 0 0]';       
Human_model(s_6dofTz).I=zeros(3,3);  
Human_model(s_6dofTz).c=[0 0 0]';
Human_model(s_6dofTz).comment='Mediolateral Translation';%
Human_model(s_6dofTz).FunctionalAngle = 'Mediolateral Translation';%

Human_model(s_6dofRx).name='6dofRx';   
Human_model(s_6dofRx).sister=0;        
Human_model(s_6dofRx).child=s_6dofRy; 
Human_model(s_6dofRx).mother=s_6dofTz;                 
Human_model(s_6dofRx).a=[1 0 0]';            
Human_model(s_6dofRx).joint=1;
Human_model(s_6dofRx).limit_inf=-Inf;    
Human_model(s_6dofRx).limit_sup=Inf;  
Human_model(s_6dofRx).Visual=0;
Human_model(s_6dofRx).m=0;                  
Human_model(s_6dofRx).b=[0 0 0]';       
Human_model(s_6dofRx).I=zeros(3,3);  
Human_model(s_6dofRx).c=[0 0 0]';
Human_model(s_6dofRx).comment='Obliquity - X-Rotation - Right(-)/Left(+))';%
Human_model(s_6dofRx).FunctionalAngle = 'Obliquity - X-Rotation - Right(-)/Left(+))';%

Human_model(s_6dofRy).name='6dofRy';   
Human_model(s_6dofRy).sister=0;        
Human_model(s_6dofRy).child=s_root; 
Human_model(s_6dofRy).mother=s_6dofRx;                 
Human_model(s_6dofRy).a=[0 1 0]';            
Human_model(s_6dofRy).joint=1;
Human_model(s_6dofRy).limit_inf=-Inf;    
Human_model(s_6dofRy).limit_sup=Inf;  
Human_model(s_6dofRy).Visual=0;
Human_model(s_6dofRy).m=0;                  
Human_model(s_6dofRy).b=[0 0 0]';       
Human_model(s_6dofRy).I=zeros(3,3);  
Human_model(s_6dofRy).c=[0 0 0]';
Human_model(s_6dofRy).comment='Rotation - Y-Rotation - Internal(-)/External(+))';%
Human_model(s_6dofRy).FunctionalAngle = 'Rotation - Y-Rotation - Internal(-)/External(+))';%

end