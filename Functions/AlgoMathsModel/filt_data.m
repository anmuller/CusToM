function [data]=filt_data(data,f,f_mocap)
% 4-th order Butterworth low pass filter with no phase shift
%
%   INPUT
%   - data: data to filter
%   - f: cut-off frequency
%   - f_mocap: acquisition frequency
%   OUTPUT
%   - data: filtered data
%________________________________________________________
%
% Licence
% Toolbox distributed under 3-Clause BSD License
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

for i=1:size(data,2)
    data(:,i)=filtrage_data(data(:,i),f,f_mocap);
end
end

function [datafilt]=filtrage_data(data,f,f_mocap)
%% filtre
% data : vector
init=data(1);
data_inter=data-init;
datafilt=filtre(data_inter,f,f_mocap);
datafilt=datafilt+init;

end

function [y]=filtre(data,f,f_mocap)
%% fonction filtre

Wn=f/(f_mocap/2); % f=100Hz (/2) et fréquence d'échantillonnage : 5Hz
% Wn=2/50; % f=100Hz (/2) et fréquence d'échantillonnage : 5Hz

[b,a] = butter(4,Wn,'low');
y=filtfilt(b,a,data);

end

