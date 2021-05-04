function T = FindFrameDynCalibration(KinematicsError,n_framecalib)
% Frames choice for the inertial calibration
%   The motion is divided into n_framecalib sequences. Into each of them,
%   the frame with the lower reconstruction error is selected
% 
%   INPUT
%   - KinematicsError: matrix of reconstruction error
%   - n_framecalib: number of frames to select
%   OUTPUT
%   - T: number of frames to be used for the inertial calibration
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

T=[];
MeanError=mean(KinematicsError,1);
nu=round(size(KinematicsError,2)/n_framecalib);

for k=1:nu:size(KinematicsError,2)
    d=max(-round(0.5*nu),-k+1);
    while d<round(0.5*nu) && MeanError(k+d)~=min(MeanError([max(k-round(0.5*nu),1):min(k+round(0.5*nu),size(KinematicsError,2))]))
        d=d+1;
    end
    T=[T k+d]; 
end

end