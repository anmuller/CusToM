function BiomechanicalModel = ForwardKinematicsConstrained(BiomechanicalModel,q0)
% Forward kinematics constrained from a command q0
%
%   INPUT
%   - BiomechanicalModel : complete model (see the Documentation for the structure)
%   - q0 : column vector of command q to actuate all the angles of the
%   BiomechanicalModel.OsteoArticularModel
%
%   OUTPUT
%   - BiomechanicalModel : complete model (see the Documentation for the structure)
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________





%% Interpolating  from the startingq0 position to the command q0

startingq0 = BiomechanicalModel.ClosedLoopData(1).startingq0;
step = 0.1;
nb_prog = 0;

% Find the number of interpolation needed
for jdx = 1:length(BiomechanicalModel.ClosedLoopData)
    
    numqu = BiomechanicalModel.ClosedLoopData(jdx).drivingqu;
    numqv = BiomechanicalModel.ClosedLoopData(jdx).drivedqv;
    
    for k=1:length(numqu)
        if  startingq0(numqu(k))<=q0(numqu(k))
            A= q0(numqu(k)):-step:startingq0(numqu(k));
        else
            A= q0(numqu(k)):step:startingq0(numqu(k));
        end
        
        oldprogr= length(A);
        if oldprogr >nb_prog
            nb_prog = oldprogr;
        end
    end
end

% Interpolation 
qlin = repmat(startingq0,1,nb_prog);

for k=1:length(numqu)
    qlin(numqu(k),:) = linspace(startingq0(numqu(k)),q0(numqu(k)),nb_prog);
end



%% Finding the new solution for every loop and every step of interpolation
for jdx = 1:length(BiomechanicalModel.ClosedLoopData)
    
    Jv = BiomechanicalModel.ClosedLoopData(jdx).Jv;
    h = BiomechanicalModel.ClosedLoopData(jdx).ConstraintEq;
    
    numqv = BiomechanicalModel.ClosedLoopData(jdx).drivedqv;
    
    for idx = 2:nb_prog+1
        
        qtot = qlin(:,idx-1);
        cpt=1;
        while h(qtot')'*h(qtot') >1e-8 && cpt<10000
            
            %%Newton-Raphson
            Jvnum=Jv(qtot');
            deltaqvnum = -Jvnum\h(qtot');
            qtot(numqv) = qtot(numqv) + deltaqvnum;
            
            for jj=1:length(BiomechanicalModel.OsteoArticularModel)-6*sum(strcmp('root0',{BiomechanicalModel.OsteoArticularModel.name}))
                if BiomechanicalModel.OsteoArticularModel(jj).joint==1
                    qtot(jj) = mod(qtot(jj),2*pi);
                end
            end
            
            cpt = cpt+1;
       end
        
        if cpt==10000
            warning(' Chosen partitioning may be irrelevant.')
        end
        
        if idx ~=nb_prog+1
            % Update of the interpolation vector
            for k=1:length(numqv)
                qlin(numqv(k),idx) = qtot(numqv(k));
            end
        end
        
        
    end
    
end


%% Update of the BiomechanicalModel.OsteoArticularModel with found coordinates
for k=1:length(BiomechanicalModel.OsteoArticularModel)-6*sum(strcmp({BiomechanicalModel.OsteoArticularModel.name},'root0'))
    BiomechanicalModel.OsteoArticularModel(k).q = qtot(k);
end

 BiomechanicalModel.ClosedLoopData(1).startingq0 = qtot; %For faster displaying

BiomechanicalModel.OsteoArticularModel(1).p=[0 0 0]';
BiomechanicalModel.OsteoArticularModel(1).R=eye(3);

[BiomechanicalModel.OsteoArticularModel] = ForwardPositions(BiomechanicalModel.OsteoArticularModel,1);

end

