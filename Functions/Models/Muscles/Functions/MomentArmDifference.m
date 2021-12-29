function diff=MomentArmDifference(x,BiomechanicalModel,num_muscle,Regression,nb_points,involved_solids,num_markersprov,angles,ideal_curve)
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



mac=momentarmcurve(x,BiomechanicalModel,num_muscle,Regression,nb_points,involved_solids(2:end-1),num_markersprov(2:end-1),angles);


mac_norme=[];
 decalage=1;
 diff=0;
 

 
for j=1:size(Regression,2)
     size_dec = nb_points^size(Regression(j).joints,2);

    ideal_curve_temp = ideal_curve(decalage: decalage + size_dec - 1);
    norm_id=norm(ideal_curve_temp);
    
    mac_temp=mac(decalage: decalage + size_dec - 1);
    decalage=decalage+size_dec;

    
    mac_norme=[mac_norme mac_temp];
    
    diff=diff + (norm(mac_temp-ideal_curve_temp,2)/norm_id)^2;

    
end


end