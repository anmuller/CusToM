function [MusculotendonLength,RegressionStructure]=RankinNeptune_Lengthcoeffs(mus_name,axis,joints_names,q)
% Computing of musculotendon length as a function of q and giving
% regression structure for musculotendon length
%
% All coeffs come from
%Rankin, J. W., & Neptune, R. R. (2012).
%Musculotendon lengths and moment arms for a
%three-dimensional upper-extremity model.
%Journal of Biomechanics, 45(9), 1739–1744.
%https://doi.org/10.1016/j.jbiomech.2012.03.010
%
%   INPUT
%   - mus_name : name of the muscle concerned
%   - axis : HAS TO BE REMOVED
%   - joints_names : vector of names of the joints concerned by the
%   musculotendon length
%   - q : vector of coordinates at the current instant
%
%   OUTPUT
%   - MusculotendonLength : value of musculotendon length
%   - RegressionStructure : structure containing musculotendon length
%   equations and coefficients
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

mus_name = mus_name{:};
mus_name = mus_name(2:end);
MusculotendonLength = [];
RegressionStructure = [];

if ~isempty(intersect(mus_name,{'TricepsMed','TricepsLat','TricepsLg','Anconeus','Brachialis','Brachioradialis','PronatorTeres','PronatorQuadratus','SupinatorBrevis','ExtensorCarpiRadialisBrevis','ExtensorCarpiRadialisLongus',...
        'ExtensorCarpiUlnaris','FlexorCarpiRadialis','FlexorCarpiUlnaris','PalmarisLongus','Coracobrachialis','BicepsS',...
        'BicepsL','Deltoid_pos','Deltoid_ant','Deltoid_mid','PECM1','PECM2','PECM3','Lat_1','Lat_2','Lat_3','TMAJ','Infraspinatus',...
        'TMIN','Supraspinatus'}))
    
    
    %% TricepsMedial
    if strcmp(mus_name,'TricepsMed')
        RegressionStructure(1).equation='RRN1';
        RegressionStructure(1).joints={'Elbow flexion(+)/extension(-)'};
        RegressionStructure(1).coeffs=[1.54222E-01  2.07285E-02  8.82432E-03   -8.64625E-03  2.25989E-03 ]';
        
        
        [~,ind] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        if length(ind)==1
            Q  = q(ind,:)';
            coeffs=[1.54222E-01  2.07285E-02  8.82432E-03   -8.64625E-03  2.25989E-03 ]';
            MusculotendonLength = equationRRN1(coeffs,Q);
        end
        
    end
    
    
    %% TricepsLateral
    if strcmp(mus_name,'TricepsLat')
        
        RegressionStructure(1).equation='RRN1';
        RegressionStructure(1).joints={'Elbow flexion(+)/extension(-)'};
        RegressionStructure(1).coeffs=[1.66594E-01  2.07285E-02  8.82427E-03  -8.64619E-03   2.25988E-03 ]';
        
        [~,ind] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        if length(ind)==1
            Q  = q(ind,:)';
            coeffs=[1.66594E-01  2.07285E-02  8.82427E-03  -8.64619E-03   2.25988E-03 ]';
            MusculotendonLength = equationRRN1(coeffs,Q);
        end
    end
    
    
    %% TricepsLong
    if strcmp(mus_name,'TricepsLg')
        warning("Length muscle not implemented");
    end
    
    
    %% Anconeus
    if strcmp(mus_name,'Anconeus')
        RegressionStructure(1).equation='RRN1';
        RegressionStructure(1).joints={'Elbow flexion(+)/extension(-)'};
        RegressionStructure(1).coeffs=[2.15292E-02 7.73490E-03  8.29149E-03  -5.76335E-03   1.25435E-03   ]';
        
        
        [~,ind] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        if length(ind)==1
            Q  = q(ind,:)';
            coeffs=[2.15292E-02 7.73490E-03  8.29149E-03  -5.76335E-03   1.25435E-03   ]';
            MusculotendonLength = equationRRN1(coeffs,Q);
        end
        
    end
    
    
    
    %% Brachialis
    if strcmp(mus_name,'Brachialis')
        RegressionStructure(1).equation='RRN1';
        RegressionStructure(1).joints={'Elbow flexion(+)/extension(-)'};
        RegressionStructure(1).coeffs=[1.46058E-01 -1.20401E-02  3.59539E-03  -5.01862E-03  9.60102E-04 ]';
        
        [~,ind] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        if length(ind)==1
            Q  = q(ind,:)';
            coeffs=[1.46058E-01 -1.20401E-02  3.59539E-03  -5.01862E-03  9.60102E-04 ]';
            MusculotendonLength = equationRRN1(coeffs,Q);
        end
        
    end
    
    
    %% Brachioradialis
    if strcmp(mus_name,'Brachioradialis')
        
        RegressionStructure(1).equation='RRN4';
        RegressionStructure(1).joints={'Elbow flexion(+)/extension(-)','Forearm pronation(+)/supination(-)'};
        RegressionStructure(1).coeffs=[3.31738E-01  -5.43503E-03 -2.68598E-02 1.38252E-03  8.13288E-04   -2.80194E-04  -4.90632E-04  -8.77554E-04  -3.38091E-03  5.46894E-03  9.80002E-04  9.67606E-04     ]';
        
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});
        [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});
        ind2 = [indtemp1,indtemp2];
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[3.31738E-01  -5.43503E-03 -2.68598E-02 1.38252E-03  8.13288E-04   -2.80194E-04  -4.90632E-04  -8.77554E-04  -3.38091E-03  5.46894E-03  9.80002E-04  9.67606E-04     ]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
        
    end
    
    
    %% PronatorTeres
    if strcmp(mus_name,'PronatorTeres')
        
        RegressionStructure(1).equation='RRN2';
        RegressionStructure(1).joints={'Elbow flexion(+)/extension(-)','Forearm pronation(+)/supination(-)'};
        RegressionStructure(1).coeffs=[1.58132E-01  -8.01366E-03  -1.67372E-03 -1.52039E-04  -9.44999E-03   6.50363E-04  6.14738E-04   ]';
        
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});
        [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});
        ind2 = [indtemp1,indtemp2];
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[1.58132E-01  -8.01366E-03  -1.67372E-03 -1.52039E-04  -9.44999E-03   6.50363E-04  6.14738E-04   ]';
            MusculotendonLength = equationRRN2(coeffs,Q);
        end
        
    end
    
    %% PronatorQuadratus
    if strcmp(mus_name,'PronatorQuadratus')
        
        RegressionStructure(1).equation='RRN1';
        RegressionStructure(1).joints={'Forearm pronation(+)/supination(-)'};
        RegressionStructure(1).coeffs=[3.11720E-02  -7.30837E-03  -1.13409E-03  9.37332E-04  2.42941E-04      ]';
        
        [~,ind] = intersect(joints_names,{'Forearm pronation-supination'});
        if length(ind)==1
            Q  = q(ind,:)';
            coeffs=[3.11720E-02  -7.30837E-03  -1.13409E-03  9.37332E-04  2.42941E-04      ]';
            MusculotendonLength = equationRRN1(coeffs,Q);
        end
    end
    %% SupinatorBrevis
    if strcmp(mus_name,'SupinatorBrevis')
        
        
        RegressionStructure(1).equation='RRN1';
        RegressionStructure(1).joints={'Forearm pronation(+)/supination(-)'};
        RegressionStructure(1).coeffs=[6.14041e-2 7.65849E-03  -2.11783E-04  -4.12925E-04   4.86667E-05 ]';
        
        
        [~,ind] = intersect(joints_names,{'Forearm pronation-supination'});
        if length(ind)==1
            Q  = q(ind,:)';
            coeffs=[6.14041e-2 7.65849E-03  -2.11783E-04  -4.12925E-04   4.86667E-05 ]';
            MusculotendonLength = equationRRN1(coeffs,Q);
        end
    end
    
    %% ExtensorCarpiRadialisBrevis
    if strcmp(mus_name,'ExtensorCarpiRadialisBrevis')
        
        RegressionStructure(1).equation='RRN14';
        RegressionStructure(1).joints={'Elbow flexion(+)/extension(-)','Forearm pronation(+)/supination(-)','Wrist deviation ulnar(+)/radial(-)','Wrist flexion(+)/extension(-)'};
        RegressionStructure(1).coeffs=[ 2.86204E-01  -5.96836E-03    1.79326E-03   3.62213E-04   1.56113E-03   -2.89215E-04  1.25293E-03  1.25067E-02  -1.45309E-02  7.28971E-04   2.63316E-02  -4.61942E-03   -3.26159E-04  -1.32954E-04  1.23138E-04   9.03957E-05  -2.38232E-04  1.35556E-06          ]';
        
        
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});
        [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});
        ind2 = [indtemp1,indtemp2];
        [~,indtemp3] = intersect(joints_names,{'Wrist deviation ulnar(+)/radial(-)'});
        [~,indtemp4] = intersect(joints_names,{'Wrist deviation ulnar(-)/radial(+)'});
        ind5 = [indtemp3,indtemp4];
        [~,ind3] = intersect(joints_names,{'Wrist flexion(+)/extension(-)'});
        if ~isempty(ind1) && ~isempty(ind2)&& ~isempty(ind5)&& ~isempty(ind3)
            Q  = q([ind1,ind2,ind5,ind3],:)';
            coeffs=[ 2.86204E-01  -5.96836E-03    1.79326E-03   3.62213E-04   1.56113E-03   -2.89215E-04  1.25293E-03  1.25067E-02  -1.45309E-02  7.28971E-04   2.63316E-02  -4.61942E-03   -3.26159E-04  -1.32954E-04  1.23138E-04   9.03957E-05  -2.38232E-04  1.35556E-06          ]';
            MusculotendonLength = equationRRN14(coeffs,Q);
        end
    end
    
    
    
    %% ExtensorCarpiRadialisLongus
    if strcmp(mus_name,'ExtensorCarpiRadialisLongus')
        
        RegressionStructure(1).equation='RRN14';
        RegressionStructure(1).joints={'Elbow flexion(+)/extension(-)','Forearm pronation(+)/supination(-)','Wrist deviation ulnar(+)/radial(-)','Wrist flexion(+)/extension(-)'};
        RegressionStructure(1).coeffs=[3.34545E-01  -6.65857E-03   -4.04481E-03  -1.27585E-03    2.54394E-03   -3.40076E-06 4.62182E-04   2.08273E-02  -1.62708E-02  4.36571E-03  1.83262E-02   -4.93580E-03  2.42875E-03  -1.07794E-03  -3.66750E-03  7.29403E-04  1.43831E-03  5.68255E-06               ]';
        
        
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});
        [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});
        ind2 = [indtemp1,indtemp2];
        [~,indtemp3] = intersect(joints_names,{'Wrist deviation ulnar(+)/radial(-)'});
        [~,indtemp4] = intersect(joints_names,{'Wrist deviation ulnar(-)/radial(+)'});
        ind5 = [indtemp3,indtemp4];
        [~,ind3] = intersect(joints_names,{'Wrist flexion(+)/extension(-)'});
        if ~isempty(ind1) && ~isempty(ind2)&& ~isempty(ind5)&& ~isempty(ind3)
            Q  = q([ind1,ind2,ind5,ind3],:)';
            coeffs=[3.34545E-01  -6.65857E-03   -4.04481E-03  -1.27585E-03    2.54394E-03   -3.40076E-06 4.62182E-04   2.08273E-02  -1.62708E-02  4.36571E-03  1.83262E-02   -4.93580E-03  2.42875E-03  -1.07794E-03  -3.66750E-03  7.29403E-04  1.43831E-03  5.68255E-06               ]';
            MusculotendonLength = equationRRN14(coeffs,Q);
        end
    end
    
    
    %% ExtensorCarpiUlnaris
    if strcmp(mus_name,'ExtensorCarpiUlnaris')
        RegressionStructure(1).equation='RRN14';
        RegressionStructure(1).joints={'Elbow flexion(+)/extension(-)','Forearm pronation(+)/supination(-)','Wrist deviation ulnar(+)/radial(-)','Wrist flexion(+)/extension(-)'};
        RegressionStructure(1).coeffs=[2.90684E-01  6.89958E-03  5.64787E-04   -8.40770E-04   2.47044E-03  -1.90395E-03  1.65339E-03   -1.84145E-02  1.41618E-03   -1.97683E-03   2.01464E-02  -1.36392E-02   -3.03054E-02  4.04515E-02   -3.35833E-05  3.24259E-04 -1.56576E-03    1.12800E-02            ]';
        
        
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});
        [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});
        ind2 = [indtemp1,indtemp2];
        [~,indtemp3] = intersect(joints_names,{'Wrist deviation ulnar(+)/radial(-)'});
        [~,indtemp4] = intersect(joints_names,{'Wrist deviation ulnar(-)/radial(+)'});
        ind5 = [indtemp3,indtemp4];
        [~,ind3] = intersect(joints_names,{'Wrist flexion(+)/extension(-)'});
        if ~isempty(ind1) && ~isempty(ind2)&& ~isempty(ind5)&& ~isempty(ind3)
            Q  = q([ind1,ind2,ind5,ind3],:)';
            coeffs=[2.90684E-01  6.89958E-03  5.64787E-04   -8.40770E-04   2.47044E-03  -1.90395E-03  1.65339E-03   -1.84145E-02  1.41618E-03   -1.97683E-03   2.01464E-02  -1.36392E-02   -3.03054E-02  4.04515E-02   -3.35833E-05  3.24259E-04 -1.56576E-03    1.12800E-02            ]';
            MusculotendonLength = equationRRN14(coeffs,Q);
        end
    end
    
    
    
    %% FlexorCarpiRadialis
    if strcmp(mus_name,'FlexorCarpiRadialis')
        RegressionStructure(1).equation='RRN14';
        RegressionStructure(1).joints={'Elbow flexion(+)/extension(-)','Forearm pronation(+)/supination(-)','Wrist deviation ulnar(+)/radial(-)','Wrist flexion(+)/extension(-)'};
        RegressionStructure(1).coeffs=[3.12671E-01 -7.51480E-03   -3.45794E-03  6.67550E-04   -2.64652E-03  3.63267E-04   2.93194E-03   6.36807E-03  3.62021E-03  4.32035E-04   -2.96833E-02   -4.87712E-03   3.58229E-03    2.41666E-03   1.24898E-03  -5.26353E-04  6.61266E-04  5.57793E-07     ]';
        
        
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});
        [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});
        ind2 = [indtemp1,indtemp2];
        [~,indtemp3] = intersect(joints_names,{'Wrist deviation ulnar(+)/radial(-)'});
        [~,indtemp4] = intersect(joints_names,{'Wrist deviation ulnar(-)/radial(+)'});
        ind5 = [indtemp3,indtemp4];
        [~,ind3] = intersect(joints_names,{'Wrist flexion(+)/extension(-)'});
        if ~isempty(ind1) && ~isempty(ind2)&& ~isempty(ind5)&& ~isempty(ind3)
            Q  = q([ind1,ind2,ind5,ind3],:)';
            coeffs=[3.12671E-01 -7.51480E-03   -3.45794E-03  6.67550E-04   -2.64652E-03  3.63267E-04   2.93194E-03   6.36807E-03  3.62021E-03  4.32035E-04   -2.96833E-02   -4.87712E-03   3.58229E-03    2.41666E-03   1.24898E-03  -5.26353E-04  6.61266E-04  5.57793E-07     ]';
            MusculotendonLength = equationRRN14(coeffs,Q);
        end
    end
    
    
    %% FlexorCarpiUlnaris
    if strcmp(mus_name,'FlexorCarpiUlnaris')
        RegressionStructure(1).equation='RRN14';
        RegressionStructure(1).joints={'Elbow flexion(+)/extension(-)','Forearm pronation(+)/supination(-)','Wrist deviation ulnar(+)/radial(-)','Wrist flexion(+)/extension(-)'};
        RegressionStructure(1).coeffs=[3.12561E-01  -4.93588E-03  -2.17405E-03   -3.06182E-04  -1.24989E-03   2.42124E-04  2.16695E-03   -2.17438E-02   8.89277E-03  6.86712E-03  -2.87258E-02  -5.64241E-03  2.89023E-04  -6.29547E-04  8.81255E-04  -1.91789E-04  4.63621E-04  -4.25472E-06          ]';
        
        
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});
        [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});
        ind2 = [indtemp1,indtemp2];
        [~,indtemp3] = intersect(joints_names,{'Wrist deviation ulnar(+)/radial(-)'});
        [~,indtemp4] = intersect(joints_names,{'Wrist deviation ulnar(-)/radial(+)'});
        ind5 = [indtemp3,indtemp4];
        [~,ind3] = intersect(joints_names,{'Wrist flexion(+)/extension(-)'});
        if ~isempty(ind1) && ~isempty(ind2)&& ~isempty(ind5)&& ~isempty(ind3)
            Q  = q([ind1,ind2,ind5,ind3],:)';
            coeffs=[3.12561E-01  -4.93588E-03  -2.17405E-03   -3.06182E-04  -1.24989E-03   2.42124E-04  2.16695E-03   -2.17438E-02   8.89277E-03  6.86712E-03  -2.87258E-02  -5.64241E-03  2.89023E-04  -6.29547E-04  8.81255E-04  -1.91789E-04  4.63621E-04  -4.25472E-06          ]';
            MusculotendonLength = equationRRN14(coeffs,Q);
        end
    end
    
    
    
    
    
    %% PalmarisLongus
    if strcmp(mus_name,'PalmarisLongus')
        
        RegressionStructure(1).equation='RRN14';
        RegressionStructure(1).joints={'Elbow flexion(+)/extension(-)','Forearm pronation(+)/supination(-)','Wrist deviation ulnar(+)/radial(-)','Wrist flexion(+)/extension(-)'};
        RegressionStructure(1).coeffs=[3.37628E-01  -4.01010E-03  -6.25346E-03  9.72013E-04  -3.57998E-03   4.21330E-04  3.29094E-03   4.98232E-03  1.17032E-02  -3.91610E-03  -4.57240E-02  -9.74559E-03  1.52482E-02  2.03664E-02    2.24819E-03   -7.83261E-04   8.98050E-04  -6.73138E-06            ]';
        
        
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});
        [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});
        ind2 = [indtemp1,indtemp2];
        [~,indtemp3] = intersect(joints_names,{'Wrist deviation ulnar(+)/radial(-)'});
        [~,indtemp4] = intersect(joints_names,{'Wrist deviation ulnar(-)/radial(+)'});
        ind5 = [indtemp3,indtemp4];
        [~,ind3] = intersect(joints_names,{'Wrist flexion(+)/extension(-)'});
        if ~isempty(ind1) && ~isempty(ind2)&& ~isempty(ind5)&& ~isempty(ind3)
            Q  = q([ind1,ind2,ind5,ind3],:)';
            coeffs=[3.37628E-01  -4.01010E-03  -6.25346E-03  9.72013E-04  -3.57998E-03   4.21330E-04  3.29094E-03   4.98232E-03  1.17032E-02  -3.91610E-03  -4.57240E-02  -9.74559E-03  1.52482E-02  2.03664E-02    2.24819E-03   -7.83261E-04   8.98050E-04  -6.73138E-06            ]';
            MusculotendonLength = equationRRN14(coeffs,Q);
        end
    end
    
    %% Coracobrachialis
    if strcmp(mus_name,'Coracobrachialis')
        warning("Length muscle not implemented");
        
    end
    
    %% Biceps Short
    if strcmp(mus_name,'BicepsS')
        warning("Length muscle not implemented");
        
    end
    
    
    %% Biceps Long
    if strcmp(mus_name,'BicepsL')
        warning("Length muscle not implemented");
        
    end
    
    
    
    %% Posterior deltoid
    if strcmp(mus_name,'Deltoid_pos')
        warning("Length muscle not implemented");
        
    end
    
    %% Anterior deltoid
    if strcmp(mus_name,'Deltoid_ant')
        warning("Length muscle not implemented");
        
    end
    
    %% Middle Deltoid
    if strcmp(mus_name,'Deltoid_mid')
        warning("Length muscle not implemented");
        
    end
    
    
    %% Pectoralis Major 1
    if strcmp(mus_name,'PECM1')
        warning("Length muscle not implemented");
        
    end
    
    
    %% Pectoralis Major 2
    if strcmp(mus_name,'PECM2')
        warning("Length muscle not implemented");
        
    end
    
    
    
    %% Pectoralis Major 3
    if strcmp(mus_name,'PECM3')
        warning("Length muscle not implemented");
        
    end
    
    %% Upper Latissimus Dorsi
    if strcmp(mus_name,'Lat_1')
        warning("Length muscle not implemented");
        
    end
    
    
    %% Middle Latissimus Dorsi
    if strcmp(mus_name,'Lat_2')
        warning("Length muscle not implemented");
        
    end
    
    
    %% Lower Latissimus Dorsi
    if strcmp(mus_name,'Lat_3')
        warning("Length muscle not implemented");
        
    end
    
    
    %% Teres Major
    if strcmp(mus_name,'TMAJ')
        warning("Length muscle not implemented");
        
    end
    
    
    %% Infraspinatus
    if strcmp(mus_name,'Infraspinatus')
        warning("Length muscle not implemented");
        
    end
    
    
    
    %% Teres Minor
    if strcmp(mus_name,'TMIN')
        warning("Length muscle not implemented");
        
    end
    
    
    
    %% Supraspinatus
    if strcmp(mus_name,'Supraspinatus')
        warning("Length muscle not implemented");
        
    end
    
end


end