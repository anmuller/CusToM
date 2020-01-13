function [real_markers]=CompteNaN(real_markers,champ)
% Identification of NaN to do not take into account them for the geometrical calibration
%   
%   INPUT
%   - real_markers: 3D position of experimental markers
%   - champ: real_markers field where we have to identify the NaN 
%   OUTPUT
%   - real_markers: 3D position of experimental markers with identifying NaN
 %________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
newfield = [champ '_NaN'];
 for i=1:numel(real_markers)
     real_markers(i).(newfield) = isnan(real_markers(i).(champ));
     real_markers(i).([newfield '_detail']) = find(real_markers(i).(newfield)(:,1)==1);
 end
 
end
