function HumanModel = AddExplicitClosedLoop(HumanModel,k, varargin)

[solid_path1,solid_path2,num_solid,num_markers]=Data_ClosedLoop(HumanModel);

syms q [1 length(HumanModel) ] real;

%% Find constraint equation for closing the loop
if size(solid_path1)==[1 1] 
    [~,ConstraintEq]=NonLinCon_ClosedLoop_Sym(HumanModel,solid_path1{1},solid_path2{1},num_solid,num_markers,q,k);
else
    [~,ConstraintEq]=NonLinCon_ClosedLoop_Sym(HumanModel,solid_path1,solid_path2,num_solid,num_markers,q,k);
end

ConstraintEq = unique(simplify(ConstraintEq));


[~,newconstraints] = fCL1(q');
ConstraintEq = newconstraints;
K=jacobian(ConstraintEq,q);

%% Find a first set of q that respects closed loop

q0 =ones(1,length(HumanModel)) ;
fcctout =  matlabFunction(sum(ConstraintEq.^2),  'vars', {q});
options  = optimset('MaxFunEvals',300000,'PlotFcns','optimplotfval' );
oneqset = fmincon(fcctout ,q0, [], [], [], [], [HumanModel.limit_inf], [HumanModel.limit_sup],[],options);

for ind=1:length(oneqset)
    str = ['q', num2str(ind-1),'=',num2str(oneqset(ind)),';'];
    eval(str);
end

KTEMP = eval(subs(K));
KTEMP(abs(KTEMP)<1e-11) = 0;
[p,qcol,~,~,~,~] = dmperm(KTEMP);
temp = KTEMP(p,qcol);
B  = any(temp);
qcol = [qcol(B) , qcol(~B)];
A = KTEMP(p,qcol);

Q1 = eye(length(p));
Q1 = Q1(:,p);
Q2 = eye(length(qcol));
Q2= Q2(qcol,:);

x1x2 = Q2 * q';
y = x1x2( rank(KTEMP) +1 : end);

unknown =  setdiff(symvar(ConstraintEq),y);
syms q [1 length(HumanModel) ] real;


q0 =ones(length(HumanModel),1) ;
q0(31) =pi/2;
q0(32) =pi;
q31 = pi/2;
q32 = pi;

% unknown =  setdiff(symvar(ConstraintEq),[q31 , q32]);
% res = solve(subs(unique(ConstraintEq)),unknown, 'IgnoreAnalyticConstraints', true);

neweq = subs(unique(ConstraintEq));
[~,newconstraints] = fCL1(q');
newconstraints = subs(newconstraints);

fcctout2 =  matlabFunction(sum(neweq.^2),  'vars', {q});
fcctout2 =  matlabFunction(sum(newconstraints.^2),  'vars', {q});
options  = optimset('Algorithm', 'interior-point' , 'MaxFunEvals',300000,'Display','on','TolFun',1e-8);

[oneqset , fval] = fmincon(fcctout2 ,q0', [], [], [], [], [HumanModel.limit_inf], [HumanModel.limit_sup],[],options);

%A=zeros(1,length(HumanModel));
%A(1,31) =1;
%A(2,32) =1;

q31 = linspace(HumanModel(31).limit_inf,HumanModel(31).limit_sup,50);
q32 = linspace(HumanModel(32).limit_inf,HumanModel(32).limit_sup,50);
[X,Y] = meshgrid(q31,q32);
Xrow = X(:);
Yrow = Y(:);
c=[];
nonlcon = @(q) nonlcontest(q,fcctout2);


for idx=1:length(Xrow)
    b = [Xrow(idx)];% ; Yrow(idx)];
    [oneqset(idx,:) , fval(idx)] = fmincon(fcctout2 ,q0', [], [], [], [], [HumanModel.limit_inf], [HumanModel.limit_sup],nonlcon,options);
    q0 = oneqset(idx,:)'; 
end

figure()
surf(X,Y,reshape(fval,length(q32), length(q31)))
title(['Respect de la contrainte']);
xlabel('q31 (rad)')
ylabel('q32 (rad)')

for i=1:length(unknown)
    figure()
    hold on
    numb = char(unknown(i));
    numb = str2num(numb(2:end));
    surf(X,Y,reshape(oneqset(:,numb),length(q32), length(q31)))
    title(['q number ', num2str(numb),' (rad)']);
    xlabel('q31 (rad)')
    ylabel('q32 (rad)')
    colorbar()
end




% for index = 1:length(q)
%     str = ['q', num2str(index)];
%     if isfield(res,str)
%         if size(eval(['res.',str]),1)>1
%             modele_1.OsteoArticularModel(index+1).ClosedLoopEquation = matlabFunction(eval(['res.',str,'(1)']),  'vars', {q});
%         else
%             modele_1.OsteoArticularModel(index+1).ClosedLoopEquation = matlabFunction(eval(['res.',str]),  'vars', {q});
%         end
%     else
%         syms eq
%         eq = eval([str]);
%         modele_1.OsteoArticularModel(index+1).ClosedLoopEquation = matlabFunction(eq,  'vars', {q});
%     end
% end




if isempty(varargin)
    %Automatic choice of constraint coordinates



else
    

end









end