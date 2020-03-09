function [OsteoArticularJoint]= XSens_Toe(OsteoArticularJoint,tree,Signe,Mass,AttachmentPoint,pose)
% Addition of a toe model
%
%   INPUT
%   - OsteoArticularModel: osteo-articular model of an already existing
%   model (see the Documentation for the structure)
%   - tree: data extracted from a MVNX file
%   - Signe : right or left ('R' or 'L')
%   - Mass: mass of the solids
%   - AttachmentPoint: name of the attachment point of the model on the
%   already existing model (character string)
%   - name of the pose use to generate the osteo-articular model
%   OUTPUT
%   - OsteoArticularModel: new osteo-articular model (see the Documentation
%   for the structure) 
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

points = tree.subject.segments.segment;

list_solid={'Toe_J1' 'Toe_J2' 'Toe'};

%% Right or left
if Signe == 'R'
    SigneC = 'Right';
elseif Signe == 'L'
    SigneC = 'Left';
end

%% Solids number incrementation

s=size(OsteoArticularJoint,2)+1;  %#ok<NASGU> % number of the 1st solid
for i=1:size(list_solid,2)      % numerotation of each solid
    if i==1
        eval(strcat('s_',list_solid{i},'=s;'))
    else
        eval(strcat('s_',list_solid{i},'=s_',list_solid{i-1},'+1;'))
    end
end

% find the number of the mother from the attachment point name
if ~numel(AttachmentPoint)
    s_mother=0;
    pos_attachment_pt=[0 0 0]';
else
    test=0;
    for i=1:numel(OsteoArticularJoint)
        for j=1:size(OsteoArticularJoint(i).anat_position,1)
            if strcmp(AttachmentPoint,OsteoArticularJoint(i).anat_position{j,1})
               s_mother=i;
               pos_attachment_pt=OsteoArticularJoint(i).anat_position{j,2}+OsteoArticularJoint(s_mother).c;
               test=1;
               break
            end
        end
        if i==numel(OsteoArticularJoint) && test==0
            error([AttachmentPoint ' is no existent'])        
        end       
    end
    if OsteoArticularJoint(s_mother).child == 0      % if the mother has no child
        OsteoArticularJoint(s_mother).child = eval(['s_' list_solid{1}]);    % the child of this mother is this solid
    else
        [OsteoArticularJoint]=sister_actualize(OsteoArticularJoint,OsteoArticularJoint(s_mother).child,eval(['s_' list_solid{1}]));
    end
end

%% Segment orientation

[~,p] = intersect({points.label},[SigneC list_solid{end}]);
[~,num_npose] = intersect({tree.subject.frames.frame.type},pose);
quat = tree.subject.frames.frame(num_npose).orientation(1,(p-1)*4+1:p*4);
rotm = quat2rotm(quat);

%% Definition of the anatomical positions 

[~,~,num_solid]=intersect([SigneC 'Toe'],{points.label});
anatomicalpoints = points(num_solid).points.point;
Toe_position_set = cell(numel(anatomicalpoints),2);
FieldNames = fieldnames(anatomicalpoints);
Pos_points = eval(['{anatomicalpoints.' FieldNames{2} '};']);
for i = 1:numel(anatomicalpoints) % 4
    Toe_position_set(i,:) = {[SigneC 'Toe_' anatomicalpoints(i).label], rotm' * Pos_points{i}'};
end
Toe_position_set = [Toe_position_set; ...
    {[SigneC 'ToePrediction1'], Toe_position_set{2,2}}; ...
    ];
Toe_position_set = [Toe_position_set; ...
    {[SigneC 'ToePrediction2'], [Toe_position_set{end,2}(1);...
        (- OsteoArticularJoint(end).anat_position{2,2}(2) + OsteoArticularJoint(end).anat_position{4,2}(2));...
        Toe_position_set{2,2}(3)]}; ...
    {[SigneC 'ToePrediction3'], [((- OsteoArticularJoint(end).anat_position{2,2}(1) + OsteoArticularJoint(end).anat_position{4,2}(1)) + 5*Toe_position_set{end,2}(1))/6;...
        (- OsteoArticularJoint(end).anat_position{2,2}(2) + OsteoArticularJoint(end).anat_position{5,2}(2));...
        Toe_position_set{2,2}(3)]}; ...
    {[SigneC 'ToePrediction4'], [(3*(- OsteoArticularJoint(end).anat_position{2,2}(1) + OsteoArticularJoint(end).anat_position{4,2}(1)) + Toe_position_set{end,2}(1))/4;...
        (- OsteoArticularJoint(end).anat_position{2,2}(2) + OsteoArticularJoint(end).anat_position{4,2}(2));...
        Toe_position_set{2,2}(3)]}; ...
    {[SigneC 'ToePrediction5'], [(3*(- OsteoArticularJoint(end).anat_position{2,2}(1) + OsteoArticularJoint(end).anat_position{4,2}(1)) + Toe_position_set{end,2}(1))/4;...
        (- OsteoArticularJoint(end).anat_position{2,2}(2) + OsteoArticularJoint(end).anat_position{5,2}(2));...
        Toe_position_set{2,2}(3)]}; ...
    ];
Toe_position_set = [Toe_position_set; ...
    {[SigneC 'ToePrediction6'], [(3*(- OsteoArticularJoint(end).anat_position{2,2}(1) + OsteoArticularJoint(end).anat_position{4,2}(1)) + Toe_position_set{end-4,2}(1))/4;...
        (2*Toe_position_set{end-1,2}(2) + Toe_position_set{end,2}(2))/3;...
        Toe_position_set{2,2}(3)]}; ...
    {[SigneC 'ToePrediction7'], [(3*(- OsteoArticularJoint(end).anat_position{2,2}(1) + OsteoArticularJoint(end).anat_position{4,2}(1)) + Toe_position_set{end-4,2}(1))/4;...
        (Toe_position_set{end-1,2}(2) + 2*Toe_position_set{end,2}(2))/3;...
        Toe_position_set{2,2}(3)]}; ...
    ];

%% Inertial parameters

Mass_Toe = 0;
Mass_Foot = 0.0137 * Mass;
LFoot = norm(OsteoArticularJoint(end).anat_position{2,2} - OsteoArticularJoint(end).anat_position{3,2}); % Foot length
LToe = norm(Toe_position_set{2,2}); % Toe length
[I_Foot]=rgyration2inertia([25.7 24.5 12.4 0 0 0], Mass_Foot, [0 0 0], LFoot + LToe, Signe);  
I_Toe = zeros(6,1);
% center of mass position
DistFromOrigin = 44.15 * (LFoot + LToe) / 100; % m
c_Foot = OsteoArticularJoint(end).anat_position{3,2} + (1 - (LFoot - DistFromOrigin) / LFoot) * (OsteoArticularJoint(end).anat_position{2,2}-OsteoArticularJoint(end).anat_position{3,2});
c_Toe = zeros(3,1);

% Change parameters of the Foot solid
OsteoArticularJoint(end).m = Mass_Foot;
OsteoArticularJoint(end).I = [I_Foot(1) I_Foot(4) I_Foot(5); I_Foot(4) I_Foot(2) I_Foot(6); I_Foot(5) I_Foot(6) I_Foot(3)];
OsteoArticularJoint(end).c = c_Foot;
for i = 1:size(OsteoArticularJoint(end).anat_position,1)
    OsteoArticularJoint(end).anat_position{i,2} = OsteoArticularJoint(end).anat_position{i,2} - c_Foot;
end

%% Osteo-articular model generation

num_solid=0;
%% Toe
    % Toe_J1
    num_solid=num_solid+1;        % solid number
    name=list_solid{num_solid}; % solid name
    eval(['incr_solid=s_' name ';'])  % solid number in the model
    OsteoArticularJoint(incr_solid).name=[SigneC name];   
    OsteoArticularJoint(incr_solid).sister=0;                
    OsteoArticularJoint(incr_solid).child=s_Toe_J2;                   
    OsteoArticularJoint(incr_solid).mother=s_mother;           
    OsteoArticularJoint(incr_solid).a=[0 1 0]';
    OsteoArticularJoint(incr_solid).joint=1;
    OsteoArticularJoint(incr_solid).ActiveJoint=1;
    OsteoArticularJoint(incr_solid).m=0;                 
    OsteoArticularJoint(incr_solid).b=pos_attachment_pt;  
    OsteoArticularJoint(incr_solid).I=zeros(3,3);
    OsteoArticularJoint(incr_solid).c=[0 0 0]';
    OsteoArticularJoint(incr_solid).Visual=0;
    
    % Toe_J2
    num_solid=num_solid+1;        % solid number
    name=list_solid{num_solid}; % solid name
    eval(['incr_solid=s_' name ';'])  % solid number in the model
    OsteoArticularJoint(incr_solid).name=[SigneC name];   
    OsteoArticularJoint(incr_solid).sister=0;                
    OsteoArticularJoint(incr_solid).child=s_Toe;                   
    OsteoArticularJoint(incr_solid).mother=s_Toe_J1;           
    OsteoArticularJoint(incr_solid).a=[1 0 0]';
    OsteoArticularJoint(incr_solid).joint=1;
    OsteoArticularJoint(incr_solid).ActiveJoint=1;
    OsteoArticularJoint(incr_solid).m=0;                 
    OsteoArticularJoint(incr_solid).b=[0 0 0]';  
    OsteoArticularJoint(incr_solid).I=zeros(3,3);
    OsteoArticularJoint(incr_solid).c=[0 0 0]';
    OsteoArticularJoint(incr_solid).Visual=0;
    
    % Toe
    num_solid=num_solid+1;        % solid number
    name=list_solid{num_solid}; % solid name
    eval(['incr_solid=s_' name ';'])  % solid number in the model
    OsteoArticularJoint(incr_solid).name=[SigneC name];
    OsteoArticularJoint(incr_solid).sister=0;    
    OsteoArticularJoint(incr_solid).child=0;
    OsteoArticularJoint(incr_solid).mother=s_Toe_J2;
    OsteoArticularJoint(incr_solid).a=[0 0 1]';
    OsteoArticularJoint(incr_solid).joint=1;
    OsteoArticularJoint(incr_solid).ActiveJoint=1;
    OsteoArticularJoint(incr_solid).m=Mass_Toe;
    OsteoArticularJoint(incr_solid).b=[0 0 0]';
    OsteoArticularJoint(incr_solid).I=[I_Toe(1) I_Toe(4) I_Toe(5); I_Toe(4) I_Toe(2) I_Toe(6); I_Toe(5) I_Toe(6) I_Toe(3)];
    OsteoArticularJoint(incr_solid).c= c_Toe;
    OsteoArticularJoint(incr_solid).anat_position=Toe_position_set;
    OsteoArticularJoint(incr_solid).Visual=1;
    
end