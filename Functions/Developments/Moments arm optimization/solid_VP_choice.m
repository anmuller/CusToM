function solids=solid_VP_choice(Human_model,solids_o_i,Regression,Sign)

[sp1,sp2]=find_solid_path(Human_model,solids_o_i(1),solids_o_i(2));
visu=find([Human_model.Visual]);

solids=[];
sol_cons=zeros(size(Regression,2),2);
for k=1:size(Regression,2)
    joint_name=Regression(k).primaryjoint;
    [~,joint_num]=intersect({Human_model.name},[Sign, joint_name]);
    for p=1:2
        if p==1
            sp=sp1;
        else
            sp=sp2;
        end
        [~,ind]=intersect(sp,joint_num);
        if ~isempty(ind) && length(sp)>1
            j=1;
            while ( (ind-j)~=0 && isempty(intersect(visu,sp(ind-j))))
                j=j+1;
            end
            if  (ind-j)~=0
                sol_cons(k,1) = sp(ind-j);
            end
            if ~isempty(intersect(visu,joint_num))
                sol_cons(k,1+~~sol_cons(k,1)) = joint_num;
            else
                j=1;
                while ( (ind+j)~=length(sp)+1 && isempty(intersect(visu,sp(ind+j))))
                    j=j+1;
                end
                if  (ind+j)~=length(sp)+1
                    sol_cons(k,2)=  sp(ind+j);
                end
            end
        end
    end
    
    
    if isfield(Regression,'secondaryjoint')
        joint_name2=Regression(k).secondaryjoint;
        [~,joint_num2]=intersect({Human_model.name},[Sign, joint_name]);
        for p=1:2
            if p==1
                sp=sp1;
            else
                sp=sp2;
            end
            [~,ind]=intersect(sp,joint_num2);
            if ~isempty(ind) && length(sp)>1
                j=1;
                while ( (ind-j)~=0 && isempty(intersect(visu,sp(ind-j))))
                    j=j+1;
                end
                if  (ind-j)~=0
                    sol_cons(k,1) = sp(ind-j);
                end
                if ~isempty(intersect(visu,joint_num2))
                    sol_cons(k,1+~~sol_cons(k,1)) = joint_num2;
                else
                    j=1;
                    while ( (ind+j)~=length(sp)+1 && isempty(intersect(visu,sp(ind+j))))
                        j=j+1;
                    end
                    if  (ind+j)~=length(sp)+1
                        sol_cons(k,2)=  sp(ind+j);
                    end
                end
            end
        end
        
        
    end
end



solids=unique(sol_cons,'rows');


solids=solids(:)';






end