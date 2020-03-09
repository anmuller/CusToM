function [Human_model] = ForwardKinematics(Human_model,j)
% Forward kinematics

if j==0
    return;
end

%%
if j~=1
    i = Human_model(j).mother;
    %% Position and Orientation
    Human_model(j).p = Human_model(i).R*Human_model(j).b+Human_model(i).p;
    Human_model(j).R = Human_model(i).R*Rodrigues(Human_model(j).a,Human_model(j).q)*Rodrigues(Human_model(j).u,Human_model(j).theta);
end

Human_model = ForwardKinematics(Human_model,Human_model(j).sister);
Human_model = ForwardKinematics(Human_model,Human_model(j).child);

end

