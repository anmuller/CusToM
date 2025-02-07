% Post Processing "Cycling" example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This example aimed at comparing the muscle activations from the left and the
% right side of the athlete. Muscles activations were computed through the MusiC
% method.
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%_______________________________________________________

% Loading the Biomechanicalmodel file
load('BiomechanicalModel.mat')

%Muscles of interests
R_Muscles = {'RGluteusMaximus2','RSemitendinosus','RRectusFemoris','RGastrocnemius','RSoleus','RTibialisAnterior'};
L_Muscles = {'LGluteusMaximus2','LSemitendinosus','LRectusFemoris','LGastrocnemius','LSoleus','LTibialisAnterior'};

% Muscle list extracted from the Muscles struct
Muscle_list = {BiomechanicalModel.Muscles.name}';

% Get the numbers of solids on which the forces are applied
[~,num_Rm]=intersect(Muscle_list,R_Muscles);
[~,num_Lm]=intersect(Muscle_list,L_Muscles);

% Name of the trial treated
filename='JOTH_Fin_125HzModif';

% Loading Muscle force computations outputs
load(fullfile(filename,'MuscleForcesComputationResults.mat'))

% Get the activations
Activations=MuscleForcesComputationResults.MuscleActivations;

% of the desired muscles
R_Activations=Activations(num_Rm,:);
L_Activations=Activations(num_Lm,:);

% Number of frames
Nb_frames = size(Activations,2);

%% Plot the result
figure()
for ii=1:6
    subplot(2,3,ii)
    plot(R_Activations(ii,:)*100,'r-','LineWidth',2)
    hold on
    plot(L_Activations(ii,:)*100,'b-','LineWidth',2)
    xlim([0 Nb_frames])
    ylim([0 100])
    xlabel('Frames')
    ylabel('Muscle Activation (%)')
    title(['Activation of Right and Left ' R_Muscles{ii}(2:end)])
end

legend('Right Side','Left Side')

% On the graph, we can see that the computed activations are
% oppositely activited during the pedaling cycle. Differences arised from
% the left and right side, showing an assymetry of the pedaling technique.