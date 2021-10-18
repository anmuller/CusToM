function    SaveDataIK(filename,ExperimentalData,InverseKinematicsResults,castest)


save([filename '/ExperimentalData'],'ExperimentalData');
save([filename '/InverseKinematicsResults','_', num2str(castest) ],'InverseKinematicsResults');

end