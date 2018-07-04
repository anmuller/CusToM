function [Moment_Arms,C] = MomentArmsComputation(Human_model,Muscles)
% Computation of the moment arms matrix
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the structure)
%   - Muscles: set of muscles (see the Documentation for the structure)
%   OUTPUT
%   - Moment_Arms: moment arms matrix
%   - C: muscular coupling matrix
%________________________________________________________
%
% Licence
% Toolbox distributed under 3-Clause BSD License
%________________________________________________________

% Initialisation of joint coordinate vector array
q = sym('q',[numel(Human_model)-6,1],'real'); % nb de ddl

%% Computation of moment arms
Moment_Arms=cell(numel(q),numel(Muscles));
C = zeros(numel(q));
for m=1:numel(Muscles) % for each muscle
    if Muscles(m).exist % if this muscle exist on the model
        % Compute muscle length
        L = Muscle_length(Human_model,Muscles,q,m);
        % derivative with respect to qi
        for n=1:(numel(Human_model)-6) % pour chaque qi
            R1 = -diff(L,q(n));
            R1 = simplify(R1);
            % Generation moment arms matrix
            if R1 == 0
                Moment_Arms{n,m} = 0;
            else
                Moment_Arms{n,m} = matlabFunction(R1,'Vars',{q});
                % Computation of muscular coupling matrix
                for k=1:(numel(Human_model)-6) % for each qi
                    if C(n,k)~= 1 % We already have a muscular coupling with another muscle
                        dR = diff(R1,q(k));
                        dR = simplify(dR);
                        if dR ~= 0
                            C(n,k)=1; C(k,n)=1;
                        end
                    end
                end
            end
        end
    end
end

end