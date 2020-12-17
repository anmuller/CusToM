function solids=PathConstruction(Human_model,solids_o_i,Regression)

[sp1,sp2]=find_solid_path(Human_model,solids_o_i(1),solids_o_i(2));
visu=find([Human_model.Visual]);

path= unique([sp1,sp2]);
solids = intersect(path,visu);

% sol_cons=zeros(size(Regression,2),2);
% 
% if length(sp1)==1 ||  length(sp2)==1
% 
% for k=1:size(Regression,2)
% %     if length(unique([sp1,sp2]))==2
% %         sol_cons(k,:)=unique([sp1,sp2]);
% %     else
%     for kl=1:size(Regression(k).joints,2)
%         joint_name=Regression(k).joints{kl};
%         [~,joint_num]=intersect({Human_model.FunctionalAngle}, joint_name);
%         for p=1:2
%             if p==1
%                 sp=sp1;
%             else
%                 sp=sp2;
%             end
%             [~,ind]=intersect(sp,joint_num);
%             if ~isempty(ind) && length(sp)>1
%                 j=1;
%                 while ( (ind-j)~=0 && isempty(intersect(visu,sp(ind-j))))
%                     j=j+1;
%                 end
%                 if  (ind-j)~=0
%                     sol_cons(k,1) = sp(ind-j);
%                 end
%                 if ~isempty(intersect(visu,joint_num))
%                     sol_cons(k,1+~~sol_cons(k,1)) = joint_num;
%                 else
%                     j=1;
%                     while ( (ind+j)~=length(sp)+1 && isempty(intersect(visu,sp(ind+j))))
%                         j=j+1;
%                     end
%                     if  (ind+j)~=length(sp)+1
%                         sol_cons(k,2)=  sp(ind+j);
%                     end
%                 end
%             end
%         end
%     end
%  %   end
% end
% else
%     sol_cons=solids_o_i;
% end
% 
% 
% 
% 
% 
% 
% 
% solids=unique(sol_cons,'rows');
% 
% 
% 
% solids=solids(:)';






end