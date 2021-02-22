function [Data,freq] = importCSV1(filename,f_mocap,varargin)

filename=[filename '.csv'];
% delimiter = ',';
delimiter = '\t';
startRow = 6;
fileID = fopen(filename,'r');

a=textscan(fileID, '%[^\n\r]', startRow-1, 'WhiteSpace', '', 'ReturnOnError', false);
c=textscan(a{1}{4},'%s','Delimiter',delimiter);
d=c{1};
freq=str2double(a{1}{2});

nb_data = numel(d);

formatSpec='';
for i=1:nb_data
    formatSpec = [formatSpec '%f']; %#ok<AGROW>
end

dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'ReturnOnError', false); 

for i=1:(nb_data-2)
    eval(['Data(i).name=''' strrep(d{i+2},' ','') ''';'])
    Data(i).RawData=dataArray{i+2}; %#ok<AGROW>
    if ~strcmp(Data(i).name(1),'F')  % moment in Nm and position in m
        Data(i).RawData=Data(i).RawData/1000;  %#ok<AGROW>
    end
    Data(i).Data=resample(Data(i).RawData,f_mocap,freq); %#ok<AGROW>
end

if nargin > 2
    Firstframe=varargin{1};
    Lastframe=varargin{2};
    for i=1:(nb_data-2)
       Data(i).Data = Data(i).Data(Firstframe:Lastframe); 
    end
end

end
