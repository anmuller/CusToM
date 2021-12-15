function diff=MomentArmDifference(x,BiomechanicalModel,num_muscle,Regression,nb_points,involved_solids,num_markersprov)
% Root mean square difference between input moment arm and moment arm from the model 
%
%   INPUT
%   - x : vector of via points positions;
%   - BiomechanicalModel: musculoskeletal model
%   - num_muscle : number of the muscle in the Muscles structure
%   - Regression : structure of moment arm 
%   - nb_points : number of point for coordinates discretization
%   - involved_solids : vector of solids of origin, via, and insertion points 
%   - num_markersprov : vector of anatomical positions of origin, via, and insertion points 
%
%   OUTPUT
%   - diff : root mean square difference
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________


ideal_curve=[];

[mac,BiomechanicalModel]=momentarmcurve(x,BiomechanicalModel,num_muscle,Regression,nb_points,involved_solids(2:end-1),num_markersprov(2:end-1));


mac_norme=[];
 decalage=1;
 diff=0;
diff2 =  0;
[sp1,sp2]=find_solid_path(BiomechanicalModel.OsteoArticularModel,involved_solids(1),involved_solids(end));
path = unique([sp1,sp2]);
FunctionalAnglesofInterest = {BiomechanicalModel.OsteoArticularModel(path).FunctionalAngle};

 
for j=1:size(Regression,2)
    ideal_curve_temp=[];
    rangeq=zeros(nb_points,size(Regression(j).joints,2));
    map_q=zeros(nb_points^size(Regression(j).joints,2),size(Regression(j).joints,2));

    for k=1:size(Regression(j).joints,2)
        joint_name=Regression(j).joints{k};
        [~,joint_num]=intersect(FunctionalAnglesofInterest,joint_name);
        joint_num=path(joint_num);
        rangeq(:,k)=linspace(BiomechanicalModel.OsteoArticularModel(joint_num).limit_inf,BiomechanicalModel.OsteoArticularModel(joint_num).limit_sup,nb_points)';

        B1=repmat(rangeq(:,k),1,nb_points^(k-1));
        B1=B1';
        B1=B1(:)';
   
        B2=repmat(B1,1,nb_points^(size(Regression(j).joints,2)-k));
        map_q(:,k) = B2;
    end
    
    if isfield(Regression,'equation')
        c = ['equation',Regression(j).equation] ;
        fh = str2func(c);
        
        ideal_curve_temp=fh(Regression(j).coeffs,map_q);
    elseif isfield(Regression,'EquationHandle')
        
        ideal_curve_temp = Regression(j).EquationHandle(map_q)';
        
    end
        
            
            
    
    norm_id=norm(ideal_curve_temp);
    
    ideal_curve=[ ideal_curve  ideal_curve_temp];
    
    
    mac_temp=mac(decalage: decalage + size(map_q,1) - 1);
    decalage=decalage+size(map_q,1);

    
    mac_norme=[mac_norme mac_temp];
    
    diff=diff + (norm(mac_temp-ideal_curve_temp,2)/norm_id)^2;

    
end


end