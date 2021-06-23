function    SaveDataIK(filename,ExperimentalData,InverseKinematicsResults)


save([filename '/ExperimentalData'],'ExperimentalData');
save([filename '/InverseKinematicsResults'],'InverseKinematicsResults');

end