function [Human_model] = ForwardPositionsandProj(Human_model,n,solid_path)
% Computation of spacial position and rotation for each solid starting from
% j
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure)
%   - j: current solid
%   OUTPUT
%   - Human_model: osteo-articular model with additional computations (see
%   the Documentation for the structure)
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

if n==(numel(solid_path)+1) % quand on arrive au bout de la cha�ne
    return;
end

%% Position vector and Rotation Matrix computation
if n~=0
    j=solid_path(n); % num�ro du solide
    i=Human_model(j).mother;
    
    % Pin joint
    if Human_model(j).joint == 1    
        Human_model(j).p=Human_model(i).R*Human_model(j).b+Human_model(i).p;
        Human_model(j).R=Human_model(i).R*Rodrigues(Human_model(j).a,Human_model(j).q)*Rodrigues(Human_model(j).u,Human_model(j).theta);
        temporary = pagemtimes(reshape([Human_model(solid_path).Rproj],3,3,numel(solid_path)),Rodrigues(Human_model(j).a,Human_model(j).q)*Rodrigues(Human_model(j).u,Human_model(j).theta));
        
      for kk=1:numel(solid_path)
            Human_model(solid_path(kk)).Rproj = temporary(:,:,kk);
            Human_model(solid_path(kk)).pproj = Human_model(solid_path(kk)).pproj+Human_model(solid_path(kk)).Rproj *Human_model(j).b;
         end
        
        Human_model(j).Rproj=Human_model(j).R*wedge(Human_model(j).a);
    end
    
    % Slide joint
    if Human_model(j).joint == 2    
        Human_model(j).p=Human_model(i).R*Human_model(j).b+Human_model(i).R*Human_model(j).a*Human_model(j).q+Human_model(i).p;
        Human_model(j).R=Human_model(i).R*Rodrigues(Human_model(j).u,Human_model(j).theta);
        temporary = pagemtimes(reshape([Human_model(solid_path).Rproj],3,3,numel(solid_path)),Rodrigues(Human_model(j).u,Human_model(j).theta));

         for kk=1:numel(solid_path)
            Human_model(solid_path(kk)).Rproj = temporary(:,:,kk);
            Human_model(solid_path(kk)).pproj = Human_model(solid_path(kk)).pproj+Human_model(solid_path(kk)).Rproj *(Human_model(j).b+Human_model(j).a*Human_model(j).q);
         end
        
    end    
end

n = n+1;
 [Human_model] = ForwardPositionsandProj(Human_model,n,solid_path);

end

