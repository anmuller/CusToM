function [Human_model,Human_model_save]=Maj_Human_model(Human_model,Human_model_save,j)
% Update the numbers of child,sister,mother of the human model after delete
% one line 
%(Warning, you have to suppress a complete branch)
% Recursive function
%   INPUT
%   - Human_model (the new one with deleted lines)
%   - Human_model_save (the old one with all saved lines)
%   OUTPUT
%   - Human_model (with refreshed numbers)
%   - Human_model_save (the old one with all saved lines)
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Pierre Puchaud, Antoine Muller, Charles Pontonnier, and
% Georges Dumont
%________________________________________________________

ind_mother_old = find([Human_model_save.mother]==j);

for ii=1:length(ind_mother_old)
    
    ind_mother_new=find(contains({Human_model.name}',...
    Human_model_save(ind_mother_old(ii)).name),1);

    if ~isempty(ind_mother_new)
        
        ind_child_old  = Human_model_save(ind_mother_old(ii)).child;
        ind_sister_old = Human_model_save(ind_mother_old(ii)).sister;
        
        [Human_model,Human_model_save]=  ...
            Maj_child_or_sister(Human_model,Human_model_save,ind_mother_old(ii),ind_mother_new,ind_child_old,0);
        
        [Human_model,Human_model_save]=  ...
            Maj_child_or_sister(Human_model,Human_model_save,ind_mother_old(ii),ind_mother_new,ind_sister_old,j);
    end
    
end
end

function [Human_model,Human_model_save]=...
    Maj_child_or_sister(Human_model,Human_model_save,ind_mother_old,ind_mother_new,ind_child_or_sister_old,nb)

if ind_child_or_sister_old~=0
    
    cur_name = Human_model_save(ind_child_or_sister_old).name;
    % check if the solid is in the new
    ind_child_or_sister_new = find(contains({Human_model.name}',cur_name),1);
    
    if ~isempty(ind_child_or_sister_new)
        
        if nb==0
            Human_model(ind_mother_new).child=ind_child_or_sister_new;
                    Human_model(ind_child_or_sister_new).mother=ind_mother_new;
        elseif nb~=0
            Human_model(ind_mother_new).sister=ind_child_or_sister_new;
                    Human_model(ind_child_or_sister_new).mother=nb;
        end
        

        
        [Human_model,Human_model_save]= Maj_Human_model(Human_model,Human_model_save,ind_mother_old);
        
    elseif Human_model_save(ind_child_or_sister_old).sister~=0
        
        ind_old_sister=Human_model_save(ind_child_or_sister_old).sister;
        cur_name = Human_model_save(ind_old_sister).name;
        ind_child_or_sister_new = find(contains({Human_model.name}',cur_name),1);
        
        Human_model(ind_mother_new).child=ind_child_or_sister_new;
        Human_model(ind_child_or_sister_new).mother=ind_mother_new;
        
        [Human_model,Human_model_save]= Maj_Human_model(Human_model,Human_model_save,ind_mother_old);
    end
end

end