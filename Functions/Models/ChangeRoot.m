function Human_model = ChangeRoot(Human_model, new_root)
% Root changement in the osteoarticular model
%
%   INPUT
%   - Human_model: current osteo-articular model (see the Documentation for the structure)
%   - new_root: name of the new solid root 
%   OUTPUT
%   - Human_model: new osteo-articular model (see the Documentation for the structure)
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

[~, new_root_num] = intersect({Human_model.name}, new_root);

%% Use only children and parents

init_root_num = find([Human_model.mother] == 0);

% Human_model1 initialization
Human_model1 = struct('name',{Human_model.name}, 'child', [], 'mother', []);
Human_model1(init_root_num).mother = 0;

% 1st conversion (use only children and parents)
[Human_model1] = ConvertHumanModelChild(Human_model, Human_model1, init_root_num);
for i=1:numel(Human_model1)
    for j=1:numel(Human_model1(i).child)
        if Human_model1(i).child(j)
            Human_model1(Human_model1(i).child(j)).mother = i; 
        end
    end  
end

%% Root change

% Human_model2 initialization
Human_model2 = struct('name',{Human_model.name}, 'child', [], 'mother', [], 'new_child', []);
Human_model2(new_root_num).mother = 0;

% 2nd conversion (new root)
[Human_model2] = ConvertHumanModelNewRoot(Human_model1, Human_model2, new_root_num);
Human_model3 = Human_model2;
for i=1:numel(Human_model3)
    if Human_model3(i).new_child
        if Human_model3(i).child
            Human_model3(i).child = [Human_model3(i).child Human_model3(i).new_child];
        else
            Human_model3(i).child = Human_model3(i).new_child;
        end
    end    
end
for i=1:numel(Human_model3)
    for j=1:numel(Human_model3(i).child)
        if Human_model3(i).child(j)
            Human_model2(Human_model3(i).child(j)).mother = i; 
        end
    end  
end

%% Geometrical parameters change

% Human_model4 initialization
Human_model4 = Human_model2;
Human_model4(new_root_num).b = zeros(3,1); Human_model4(new_root_num).c = Human_model(new_root_num).c;
Human_model4(new_root_num).a = zeros(3,1);

% Conversion (new geometrical parameters)
[Human_model4] = ConvertHumanModelParameters(Human_model, Human_model4, new_root_num);
for i=1:numel(Human_model4)
    if ~numel(Human_model4(i).new_child)
        Human_model4(i).c = Human_model(i).c;
        Human_model4(i).a = Human_model(i).a;
        Human_model4(i).limit_inf = Human_model(i).limit_inf;
        Human_model4(i).limit_sup = Human_model(i).limit_sup;
        Human_model4(i).u = Human_model(i).u;
        Human_model4(i).theta = Human_model(i).theta;
        if numel(Human_model4(i).b)
            Human_model4(i).b = Human_model4(i).b + Human_model(i).b;
        else
            Human_model4(i).b = Human_model(i).b;
        end        
    end
end

%% Re-use sisters

% Initilization
Human_model5 = Human_model4; 
for i=1:numel(Human_model5)
    Human_model5(i).sister = 0;
end
for i=1:numel(Human_model5)
    if Human_model5(i).new_child
        if Human_model5(i).child
            Human_model5(i).child = [Human_model5(i).child Human_model5(i).new_child];
        else
            Human_model5(i).child = Human_model5(i).new_child;
        end
    end    
end
Human_model5 = rmfield(Human_model5, 'new_child');

% Conversion
Human_model5 = ConvertHumanModelSister(Human_model5, new_root_num);
Human_model5 = rmfield(Human_model5, 'child');
[Human_model5.('child')] = Human_model5.('new_child');
Human_model5 = rmfield(Human_model5, 'new_child');

%% Root in first position

for i=1:numel(Human_model5)
    Human_model(i).sister = Human_model5(i).sister; 
    Human_model(i).mother = Human_model5(i).mother;
    Human_model(i).child = Human_model5(i).child;
    Human_model(i).b = Human_model5(i).b;
    Human_model(i).c = Human_model5(i).c;
    Human_model(i).a = Human_model5(i).a;
    Human_model(i).limit_inf = Human_model5(i).limit_inf;
    Human_model(i).limit_sup = Human_model5(i).limit_sup;
    Human_model(i).u = Human_model5(i).u;
    Human_model(i).theta = Human_model5(i).theta;
end
save_new_root = Human_model(new_root_num);
Human_model(new_root_num) = Human_model(init_root_num);
Human_model(init_root_num) = save_new_root;
for i=1:numel(Human_model)
    % sister
    if Human_model(i).sister == init_root_num
        test = 1;
    elseif Human_model(i).sister == new_root_num
        test = 2;
    else
        test = 0;
    end
    if test == 1
        Human_model(i).sister = new_root_num;
    elseif test == 2
        Human_model(i).sister = init_root_num;
    end
    % mother
    if Human_model(i).mother == init_root_num
        test = 1;
    elseif Human_model(i).mother == new_root_num
        test = 2;
    else
        test = 0;
    end
    if test == 1
        Human_model(i).mother = new_root_num;
    elseif test == 2
        Human_model(i).mother = init_root_num;
    end
    % child
    if Human_model(i).child == init_root_num
        test = 1;
    elseif Human_model(i).child == new_root_num
        test = 2;
    else
        test = 0;
    end
    if test == 1
        Human_model(i).child = new_root_num;
    elseif test == 2
        Human_model(i).child = init_root_num;
    end
end

end

function [Human_model1] = ConvertHumanModelChild(Human_model, Human_model1, j)
% Use only children and mother

if j
    Human_model1(j).child = Human_model(j).child;
    if Human_model(j).child    
        Human_model1 = AddNewChild(Human_model, Human_model1, Human_model(j).child, j);
    end
    
    [Human_model1] = ConvertHumanModelChild(Human_model, Human_model1, Human_model(j).sister);
    [Human_model1] = ConvertHumanModelChild(Human_model, Human_model1, Human_model(j).child);
else 
    return;
end

end

function [Human_model1] = AddNewChild(Human_model, Human_model1, j, i)

if Human_model(j).sister
    Human_model1(i).child = [Human_model1(i).child Human_model(j).sister];
    Human_model1 = AddNewChild(Human_model, Human_model1, Human_model(j).sister, i);
else
    return;
end

end

function [Human_model2] = ConvertHumanModelNewRoot(Human_model1, Human_model2, j)
% Conversion with the new root

if j
    for i=1:numel(Human_model1(j).child) % added of previous children (by removing the current parent)
        if Human_model1(j).child
            if ~numel(Human_model2(Human_model1(j).child(i)).new_child) || Human_model2(Human_model1(j).child(i)).new_child ~= j
            	Human_model2(j).child = [Human_model2(j).child Human_model1(j).child(i)];
            end
        end
    end
    Human_model2(j).new_child = Human_model1(j).mother;
    
    for i = 1:numel(Human_model2(j).child)
        if Human_model2(j).child
            Human_model2 = AddSameChild(Human_model1, Human_model2, Human_model2(j).child(i));
        end
    end
    
    Human_model2 = ConvertHumanModelNewRoot(Human_model1, Human_model2, Human_model2(j).new_child);
else
    return;
end


end

function [Human_model2] = AddSameChild(Human_model1, Human_model2, j)

if j
    Human_model2(j).child = Human_model1(j).child;
    for i = 1:numel(Human_model1(j).child)
        if Human_model1(j).child
            Human_model2 = AddSameChild(Human_model1, Human_model2, Human_model1(j).child(i));
        end
    end
else
    return;
end

end

function [Human_model4] = ConvertHumanModelParameters(Human_model, Human_model4, j)

if Human_model4(j).mother
    if Human_model4(Human_model4(j).mother).mother
        Human_model4(j).b = - Human_model(Human_model4(Human_model4(j).mother).mother).b;
    else
        Human_model4(j).b = zeros(3,1);
    end
    Human_model4(j).c = -Human_model(Human_model4(j).mother).b + Human_model(j).c;
    Human_model4(j).a = Human_model(Human_model4(j).mother).a;
    Human_model4(j).limit_inf = Human_model(Human_model4(j).mother).limit_inf;
    Human_model4(j).limit_sup = Human_model(Human_model4(j).mother).limit_sup;
    Human_model4(j).u = Human_model(Human_model4(j).mother).u;
    Human_model4(j).theta = -Human_model(Human_model4(j).mother).theta;
end
if Human_model4(j).new_child
    [Human_model4] = ConvertHumanModelParameters(Human_model, Human_model4, Human_model4(j).new_child);
else
    for i=1:numel(Human_model4(j).child)
        Human_model4(Human_model4(j).child(i)).b = - Human_model(Human_model4(j).mother).b;
    end
    return;
end

end

function [Human_model5] = ConvertHumanModelSister(Human_model5, j)

if j
    Human_model5(j).new_child = Human_model5(j).child(1);
    for i=2:numel(Human_model5(j).child)
        Human_model5 = AddSister(Human_model5,Human_model5(j).new_child,Human_model5(j).child(i));
    end
    [Human_model5] = ConvertHumanModelSister(Human_model5, Human_model5(j).new_child);
    [Human_model5] = ConvertHumanModelSister(Human_model5, Human_model5(j).sister);
else
    return;
end

end

function [Human_model]=AddSister(Human_model,j,i)

if Human_model(j).sister == 0
    Human_model(j).sister = i;
    return;
end

[Human_model]=AddSister(Human_model,Human_model(j).sister,i);

end
