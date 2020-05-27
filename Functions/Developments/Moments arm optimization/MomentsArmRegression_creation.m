k=1;
MomentsArmRegression(k).name="ExtensorDigitorum";
MomentsArmRegression(k).regression(1).equation=1;
%MomentsArmRegression(k).regression(1).primaryjoint={"WFE"};
MomentsArmRegression(k).regression(1).primaryjoint='Wrist_J1';
MomentsArmRegression(k).regression(2).equation=1;
%MomentsArmRegression(k).regression(2).primaryjoint={"RUD"};
MomentsArmRegression(k).regression(2).primaryjoint='Hand';
MomentsArmRegression(k).regression(1).coeffs=[-14.1276 1.7325]';
MomentsArmRegression(k).regression(2).coeffs=[2.0459 4.5732]';

k=k+1;
MomentsArmRegression(k).name="FlexorDigitorumSuperior";
MomentsArmRegression(k).regression(1).equation=1;
MomentsArmRegression(k).regression(1).primaryjoint='WFE';
MomentsArmRegression(k).regression(2).equation=1;
MomentsArmRegression(k).regression(2).primaryjoint='RUD';
MomentsArmRegression(k).regression(1).coeffs=[10.3467 1.0641 1.0495]';
MomentsArmRegression(k).regression(2).coeffs=[1.6252 6.3604]';

save('MomentsArmRegression.mat','MomentsArmRegression');