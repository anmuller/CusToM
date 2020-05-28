function solids=solid_VP_choice(Human_model,solids_o_i,Regression,Sign)

[sp1,sp2]=find_solid_path(Human_model,solids_o_i(1),solids_o_i(2));
visu=find([Human_model.Visual]);

solids=[];
sol_cons=[];
for k=1:size(Regression,2)
    joint_name=Regression(k).primaryjoint;
    [~,joint_num]=intersect({Human_model.name},[Sign, joint_name]);
    [~,ind]=intersect(sp1,joint_num);
    if ~isempty(ind) && length(sp1)>1
        j=1;
        while ( (ind-j)~=0 && isempty(intersect(visu,sp1(ind-j))))
            j=j+1;
        end
        if  (ind-j)~=0
            sol_cons = [ sol_cons,  sp1(ind-j)];
        end
        if ~isempty(intersect(visu,joint_num))
            sol_cons = [sol_cons ,joint_num];
        else
            j=1;
            while ( (ind+j)~=length(sp1)+1 && isempty(intersect(visu,sp1(ind+j))))
                j=j+1;
            end
            if  (ind+j)~=length(sp1)+1
                sol_cons =  [sol_cons , sp1(ind+j)];
            end
        end
    end
    
    [~,ind]=intersect(sp2,joint_num);
    if ~isempty(ind) && length(sp2)>1
        j=1;
        while ( (ind-j)~=0 && isempty(intersect(visu,sp2(ind-j))))
            j=j-1;
        end
        if  (ind-j)~=0
            sol_cons =[ sol_cons,  sp2(ind-j)];
        end
        if ~isempty(intersect(visu,joint_num))
            sol_cons = [sol_cons ,joint_num];
        else
        j=1;
        while ( (ind+j)~=length(sp2)+1 && isempty(intersect(visu,sp2(ind+j))))
            j=j+1;
        end
        if  (ind+j)~=length(sp2)+1
            sol_cons =  [sol_cons , sp2(ind+j)];
        end
        end
        
    end
    
    if isfield(Regression,'secondaryjoint')
        joint_name2=Regression(k).secondaryjoint;
        [~,joint_num2]=intersect({Human_model.name},[Sign, joint_name]);
        [~,ind]=intersect(sp1,joint_num2);
        if ~isempty(ind) && length(sp1)>1
            j=1;
            while ( (ind-j)~=0 && isempty(intersect(visu,sp1(ind-j))))
                j=j-1;
            end
            if  (ind-j)~=0
                sol_cons = [ sol_cons,  sp1(ind-j)];
            end
            if ~isempty(intersect(visu,joint_num))
                sol_cons = [sol_cons ,joint_num];
            else
            j=1;
            while ( (ind+j)~=length(sp1)+1 && isempty(intersect(visu,sp1(ind+j))))
                j=j+1;
            end
            if  (ind+j)~=length(sp1)+1
                sol_cons =  [sol_cons , sp1(ind+j)];
            end
            end
            
        end
        
        [~,ind]=intersect(sp2,joint_num2);
        if ~isempty(ind) && length(sp2)>1
            j=1;
            while ( (ind-j)~=0 && isempty(intersect(visu,sp2(ind-j))))
                j=j+1;
            end
            if  (ind-j)~=0
                sol_cons =[ sol_cons,  sp2(ind-j)];
            end
            if ~isempty(intersect(visu,joint_num))
                sol_cons = [sol_cons ,joint_num];
            else
            j=1;
            while ( (ind+j)~=length(sp2)+1 && isempty(intersect(visu,sp2(ind+j))))
                j=j+1;
            end
            if  (ind+j)~=length(sp2)+1
                sol_cons =  [sol_cons , sp2(ind+j)];
            end
            end
            
        end
        
        
    end
    solids=[solids sol_cons];
end

solids=unique(solids);








end