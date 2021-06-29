function [Human_model]=OnCircle(theta,joint_num,Human_model,involved_solids,num_markersprov)
% Rotating via points of theta angle arounf joint_num
%
%   INPUT
%   - theta : vector of rotation of via points
%   - joint_num  : vector of solids around via points rotates of theta
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure)
%   - involved_solids : vector of solids of origin, via, and insertion points 
%   - num_markersprov : vector of anatomical positions of origin, via, and insertion points 
%
%   OUTPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure)
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

Nb_q=numel(Human_model)-6*(~isempty(intersect({Human_model.name},'root0')));

num_sol=involved_solids;
num_mark= num_markersprov;
for k=2:2:numel(num_sol)-2
    
    Mbone=num_sol(k);
    Mpos=num_mark(k);
    
    Mbone2=num_sol(k+1);
    Mpos2=num_mark(k+1);
    
    for j=1:length(theta)
        if joint_num(j)<=Mbone2 && joint_num(j)>Mbone
            q=zeros(1,Nb_q);
            
            
            [Human_model] = rotation(Mpos,Mbone,Human_model,q,joint_num(j),theta(j));
            [Human_model] = rotation(Mpos2,Mbone2,Human_model,q,joint_num(j),theta(j));
        else
            if joint_num(j)<=Mbone2
                
            q=zeros(1,Nb_q);
            
            [Human_model] = rotation(Mpos,Mbone,Human_model,q,joint_num(j),theta(j));
            [Human_model] = rotation(Mpos2,Mbone2,Human_model,q,joint_num(j),theta(j));

            
            end
            
        end
    end
    
    
    
    
end






end