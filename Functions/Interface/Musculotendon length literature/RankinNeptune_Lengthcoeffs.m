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
    RegressionStructure(1).axe='Elbow flexion(+)/extension(-)';
    RegressionStructure(1).coeffs=[-2.02999e-2  -2.15606e-2  3.56484e-2  -1.78502e-2  2.6245e-3]';

    if strcmp(axis,'Elbow flexion(+)/extension(-)')
        [~,ind] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        if length(ind)==1
            Q  = q(ind,:)';
            coeffs=[-2.02999e-2  -2.15606e-2  3.56484e-2  -1.78502e-2  2.6245e-3]';
            MusculotendonLength = equationRRN1(coeffs,Q);
        end
    end
end


%% TricepsLateral
if strcmp(mus_name,'TricepsLat')
    
    RegressionStructure(1).equation='RRN1';
    RegressionStructure(1).joints={'Elbow flexion(+)/extension(-)'};
    RegressionStructure(1).axe='Elbow flexion(+)/extension(-)';
    RegressionStructure(1).coeffs=[-2.02999e-2  -2.15606e-2  3.56484e-2  -1.78502e-2  2.6245e-3]';

    if strcmp(axis,'Elbow flexion(+)/extension(-)')
        [~,ind] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        if length(ind)==1
            Q  = q(ind,:)';
            coeffs=[-2.02999e-2  -2.15606e-2  3.56484e-2  -1.78502e-2  2.6245e-3]';
            MusculotendonLength = equationRRN1(coeffs,Q);
        end
    end
end


%% TricepsLateral
if strcmp(mus_name,'TricepsLg')
    if strcmp(axis,'Elbow flexion(+)/extension(-)')
        [~,ind] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        if length(ind)==1
            Q  = q(ind,:)';
            coeffs=[  -0.020165080614232  -0.022691141141548   0.038332749164031  -0.020226156396375   0.003321056085587]';
            MusculotendonLength = equationRRN1(coeffs,Q);
        end
    elseif strcmp(axis,'GH axial rotation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[-0.00490136161527447,0.000566098170946260,-0.00886638287222690,-0.00246280571656328,0.00304750248545654,0.00108413515832895,0.00152268352385958,0.00316185753637642,-0.00103546789810122,-0.000273685406282493,-0.00139182596128529,0.00214257044448629,0.00360086689789377,-0.000538051885032412,0.000765018827492523,-0.00157684472420291,0.000229550832337550,-0.000771791384370138,-0.000879358728228524,0.000319104128978911,-0.000371228189625557,-0.000125977190375313,5.23251573842631e-05,-5.66145372629378e-05,-0.000449371996230127,0.00144073415764445,-0.000532052273927462,0.00165260797590302,-0.00214567790657713,-0.000674044990590442]';
            MusculotendonLength = equationRRN13(coeffs,Q);
        end
    end
end


%% Anconeus
if strcmp(mus_name,'Anconeus')
    RegressionStructure(1).equation='RRN1';
    RegressionStructure(1).joints={'Elbow flexion(+)/extension(-)'};
    RegressionStructure(1).axe='Elbow flexion(+)/extension(-)';
    RegressionStructure(1).coeffs=[2.15292E-02 7.73490E-03  8.29149E-03  -5.76335E-03   1.25435E-03   ]';


    if strcmp(axis,'Elbow flexion(+)/extension(-)')
        [~,ind] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        if length(ind)==1
            Q  = q(ind,:)';
            coeffs=[2.15292E-02 7.73490E-03  8.29149E-03  -5.76335E-03   1.25435E-03   ]';
            MusculotendonLength = equationRRN1(coeffs,Q);
        end
    end
end



%% Brachialis
if strcmp(mus_name,'Brachialis')
    RegressionStructure(1).equation='RRN1';
    RegressionStructure(1).joints={'Elbow flexion(+)/extension(-)'};
    RegressionStructure(1).axe='Elbow flexion(+)/extension(-)';
    RegressionStructure(1).coeffs=[9.84873e-3  1.01630e-2  -2.39557e-2  2.90329e-2  -9.24344e-3]';

    if strcmp(axis,'Elbow flexion(+)/extension(-)')
        [~,ind] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        if length(ind)==1
            Q  = q(ind,:)';
            coeffs=[9.84873e-3  1.01630e-2  -2.39557e-2  2.90329e-2  -9.24344e-3]';
            MusculotendonLength = equationRRN1(coeffs,Q);
        end
    end
end


%% Brachioradialis
if strcmp(mus_name,'Brachioradialis')
    
    RegressionStructure(1).equation='RRN4';
    RegressionStructure(1).joints={'Elbow flexion(+)/extension(-)','Forearm pronation(+)/supination(-)'};
    RegressionStructure(1).axe='Elbow flexion(+)/extension(-)';
    RegressionStructure(1).coeffs=[1.18003e-2  2.09993e-2  3.7126e-2  -1.47644e-2  -5.8285e-4  -3.57599e-3  -7.25432e-4  1.40991e-2  -1.25532e-2  -1.47822e-3  3.61034e-3 -2.57318e-4]';
    RegressionStructure(2).equation='RRN4';
    RegressionStructure(2).joints={'Elbow flexion(+)/extension(-)','Forearm pronation(+)/supination(-)'};
    RegressionStructure(2).axe='Forearm pronation(+)/supination(-)'; 
    RegressionStructure(2).coeffs=[-7.81478e-4  6.99447e-4  3.60463e-3  -1.06015e-3  -3.9357e-4  1.44296e-3  -8.94732e-4  -4.05248e-3  -1.00184e-2  -2.83974e-3  3.51570e-3  2.85087e-3]';

    if strcmp(axis,'Elbow flexion(+)/extension(-)')
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});
        [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});
        ind2 = [indtemp1,indtemp2];
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[1.18003e-2  2.09993e-2  3.7126e-2  -1.47644e-2  -5.8285e-4  -3.57599e-3  -7.25432e-4  1.40991e-2  -1.25532e-2  -1.47822e-3  3.61034e-3 -2.57318e-4]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Forearm pronation(+)/supination(-)') || strcmp(axis,'Forearm pronation(-)/supination(+)') 
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});         
        [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});         ind2 = [indtemp1,indtemp2];
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[-7.81478e-4  6.99447e-4  3.60463e-3  -1.06015e-3  -3.9357e-4  1.44296e-3  -8.94732e-4  -4.05248e-3  -1.00184e-2  -2.83974e-3  3.51570e-3  2.85087e-3]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    end
end


%% PronatorTeres
if strcmp(mus_name,'PronatorTeres')   
    
    RegressionStructure(1).equation='RRN3';
    RegressionStructure(1).joints={'Elbow flexion(+)/extension(-)','Forearm pronation(+)/supination(-)'};
    RegressionStructure(1).axe='Elbow flexion(+)/extension(-)';
    RegressionStructure(1).coeffs=[6.55640E-03  1.69232E-02  -3.28333E-02  3.21198E-02   -5.90348E-17   9.60061E-16   3.77736E-16  -1.27742E-02  1.63665E-03   -1.57600E-15  -4.90059E-16      ]';
    RegressionStructure(2).equation='RRN3';
    RegressionStructure(2).joints={'Elbow flexion(+)/extension(-)','Forearm pronation(+)/supination(-)'};
    RegressionStructure(2).axe='Forearm pronation(+)/supination(-)'; 
    RegressionStructure(2).coeffs=[9.47956E-03  -9.28023E-15  3.97126E-14  -6.20788E-14   -2.01126E-03  -2.82774E-03  2.85982E-03  4.00418E-14  -9.11077E-15   1.70446E-03  -2.34187E-03 ]';


    if strcmp(axis,'Elbow flexion(+)/extension(-)')
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});         
        [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});         
        ind2 = [indtemp1,indtemp2];
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[6.55640E-03  1.69232E-02  -3.28333E-02  3.21198E-02   -5.90348E-17   9.60061E-16   3.77736E-16  -1.27742E-02  1.63665E-03   -1.57600E-15  -4.90059E-16      ]';
            MusculotendonLength = equationRRN3(coeffs,Q);
        end
    elseif strcmp(axis,'Forearm pronation(+)/supination(-)') || strcmp(axis,'Forearm pronation(-)/supination(+)') 
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});         [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});         ind2 = [indtemp1,indtemp2];
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[9.47956E-03  -9.28023E-15  3.97126E-14  -6.20788E-14   -2.01126E-03  -2.82774E-03  2.85982E-03  4.00418E-14  -9.11077E-15   1.70446E-03  -2.34187E-03 ]';
            MusculotendonLength = equationRRN3(coeffs,Q);
        end
    end
end

%% PronatorQuadratus
if strcmp(mus_name,'PronatorQuadratus')

    RegressionStructure(1).equation='RRN1';
    RegressionStructure(1).joints={'Forearm pronation(+)/supination(-)'};
    RegressionStructure(1).axe='Forearm pronation(+)/supination(-)'; 
    RegressionStructure(1).coeffs=[7.30854e-3  2.28126e-3  -2.81928e-3  -1.02119e-3  1.74483e-5]';

    if strcmp(axis,'Forearm pronation(+)/supination(-)') || strcmp(axis,'Forearm pronation(-)/supination(+)') 
        [~,ind] = intersect(joints_names,{'Forearm pronation-supination'});
        if length(ind)==1
            Q  = q(ind,:)';
            coeffs=[7.30854e-3  2.28126e-3  -2.81928e-3  -1.02119e-3  1.74483e-5]';
            MusculotendonLength = equationRRN1(coeffs,Q);
        end
    end
end
%% SupinatorBrevis
if strcmp(mus_name,'SupinatorBrevis')
    

    RegressionStructure(1).equation='RRN1';
    RegressionStructure(1).joints={'Forearm pronation(+)/supination(-)'};
    RegressionStructure(1).axe='Forearm pronation(+)/supination(-)'; 
    RegressionStructure(1).coeffs=[-7.67985E-03  4.08098E-04 1.45346E-03  -1.70151E-04  -5.01312E-04]';

    
    if strcmp(axis,'Forearm pronation(+)/supination(-)') || strcmp(axis,'Forearm pronation(-)/supination(+)') 
        [~,ind] = intersect(joints_names,{'Forearm pronation-supination'});
        if length(ind)==1
            Q  = q(ind,:)';
            coeffs=[-7.67985E-03  4.08098E-04 1.45346E-03  -1.70151E-04  -5.01312E-04]';
            MusculotendonLength = equationRRN1(coeffs,Q);
        end
    end
end

%% ExtensorCarpiRadialisBrevis
if strcmp(mus_name,'ExtensorCarpiRadialisBrevis')

    RegressionStructure(1).equation='RRN4';
    RegressionStructure(1).joints={'Elbow flexion(+)/extension(-)','Forearm pronation(+)/supination(-)'};
    RegressionStructure(1).axe='Elbow flexion(+)/extension(-)';
    RegressionStructure(1).coeffs=[5.64642E-03  -1.74387E-03  -3.71495E-03  1.01268E-03  -5.29727E-05  1.84085E-04  1.87014E-05   -3.87485E-04  5.11181E-05  2.50652E-04  4.03295E-05   2.61368E-05]';
    RegressionStructure(2).equation='RRN4';
    RegressionStructure(2).joints={'Elbow flexion(+)/extension(-)','Forearm pronation(+)/supination(-)'};
    RegressionStructure(2).axe='Forearm pronation(+)/supination(-)'; 
    RegressionStructure(2).coeffs=[-1.55243E-03  -5.91013E-05  -2.19213E-04  5.07507E-05  -1.90131E-03   7.41471E-04  3.34035E-04  1.84492E-04  6.68436E-04  1.32696E-04  -1.58205E-04  -1.55084E-04 ]';
    RegressionStructure(3).equation='RRN4';
    RegressionStructure(3).joints={'Wrist deviation ulnar(+)/radial(-)','Wrist flexion(+)/extension(-)'};
    RegressionStructure(3).axe='Wrist deviation ulnar(+)/radial(-)';
    RegressionStructure(3).coeffs=[-1.34815E-02   3.02208E-02   5.78169E-03  -1.64320E-02  2.68623E-03  3.41629E-03  -2.45737E-03   8.20428E-04  -3.08372E-02  -8.27743E-03  3.13227E-02   6.21186E-03]';
    RegressionStructure(4).equation='RRN4';
    RegressionStructure(4).joints={'Wrist deviation ulnar(+)/radial(-)','Wrist flexion(+)/extension(-)'};
    RegressionStructure(4).axe='Wrist flexion(+)/extension(-)';
    RegressionStructure(4).coeffs=[-2.67570E-02  2.69223E-03   3.35291E-03  -1.18284E-02  9.57323E-03   3.02360E-03  -2.78438E-03  2.09357E-03  -1.37559E-02  -6.54620E-03   2.41453E-02     1.01279E-02 ]';

    
    
    if strcmp(axis,'Elbow flexion(+)/extension(-)')
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});         [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});         ind2 = [indtemp1,indtemp2];
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[5.64642E-03  -1.74387E-03  -3.71495E-03  1.01268E-03  -5.29727E-05  1.84085E-04  1.87014E-05   -3.87485E-04  5.11181E-05  2.50652E-04  4.03295E-05   2.61368E-05]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Forearm pronation(+)/supination(-)') || strcmp(axis,'Forearm pronation(-)/supination(+)') 
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});         [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});         ind2 = [indtemp1,indtemp2];
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[-1.55243E-03  -5.91013E-05  -2.19213E-04  5.07507E-05  -1.90131E-03   7.41471E-04  3.34035E-04  1.84492E-04  6.68436E-04  1.32696E-04  -1.58205E-04  -1.55084E-04 ]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Wrist deviation ulnar(+)/radial(-)') || strcmp(axis,'Wrist deviation ulnar(-)/radial(+)') 
        [~,indtemp1] = intersect(joints_names,{'Wrist deviation ulnar(+)/radial(-)'});        
        [~,indtemp2] = intersect(joints_names,{'Wrist deviation ulnar(-)/radial(+)'});         
        ind1 = [indtemp1,indtemp2];
        [~,ind2] = intersect(joints_names,{'Wrist flexion(+)/extension(-)'});

        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[-1.34815E-02   3.02208E-02   5.78169E-03  -1.64320E-02  2.68623E-03  3.41629E-03  -2.45737E-03   8.20428E-04  -3.08372E-02  -8.27743E-03  3.13227E-02   6.21186E-03]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Wrist flexion(+)/extension(-)')
        [~,indtemp1] = intersect(joints_names,{'Wrist deviation ulnar(+)/radial(-)'});                 [~,indtemp2] = intersect(joints_names,{'Wrist deviation ulnar(-)/radial(+)'});                  ind1 = [indtemp1,indtemp2];
        [~,ind2] = intersect(joints_names,{'Wrist flexion(+)/extension(-)'});
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[-2.67570E-02  2.69223E-03   3.35291E-03  -1.18284E-02  9.57323E-03   3.02360E-03  -2.78438E-03  2.09357E-03  -1.37559E-02  -6.54620E-03   2.41453E-02     1.01279E-02 ]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    end
end



%% ExtensorCarpiRadialisLongus
if strcmp(mus_name,'ExtensorCarpiRadialisLongus')
    
    RegressionStructure(1).equation='RRN4';
    RegressionStructure(1).joints={'Elbow flexion(+)/extension(-)','Forearm pronation(+)/supination(-)'};
    RegressionStructure(1).axe='Elbow flexion(+)/extension(-)';
    RegressionStructure(1).coeffs=[6.784195E-03  4.25933E-03   1.08103E-02   -3.02892E-03  5.08279E-03  -3.08828E-04   -9.16923E-04   -4.83760E-03   2.49206E-03  -1.02552E-03   -4.91622E-04  4.50855E-04 ]';
    RegressionStructure(2).equation='RRN4';
    RegressionStructure(2).joints={'Elbow flexion(+)/extension(-)','Forearm pronation(+)/supination(-)'};
    RegressionStructure(2).axe='Forearm pronation(+)/supination(-)'; 
    RegressionStructure(2).coeffs=[-2.36211E-03  2.93937E-03  -6.69053E-05  -1.39155E-04  -1.06309E-03  1.00099E-03  -5.83203E-04  -2.37355E-04  -2.73083E-03  -1.15824E-03   6.79267E-04   1.00675E-03 ]';
    RegressionStructure(3).equation='RRN4';
    RegressionStructure(3).joints={'Wrist deviation ulnar(+)/radial(-)','Wrist flexion(+)/extension(-)'};
    RegressionStructure(3).axe='Wrist deviation ulnar(+)/radial(-)';
    RegressionStructure(3).coeffs=[-2.14012E-02  3.26927E-02  -1.13902E-02  -1.82031E-03  1.35811E-02  1.72010E-03  -2.39317E-03  -1.89705E-02  -1.02368E-02   -1.48189E-03  1.29229E-02  8.20184E-03  ]';
    RegressionStructure(4).equation='RRN4';
    RegressionStructure(4).joints={'Wrist deviation ulnar(+)/radial(-)','Wrist flexion(+)/extension(-)'};
    RegressionStructure(4).axe='Wrist flexion(+)/extension(-)';
    RegressionStructure(4).coeffs=[-1.98904E-02 1.410779E-02   -5.64345E-03  -4.25499E-03  1.09667E-02   -4.96348E-03  -7.54046E-05  1.60476E-03   -5.13726E-03  -7.44317E-03   4.86065E-03   8.54788E-03 ]';

    
    if strcmp(axis,'Elbow flexion(+)/extension(-)')
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});         [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});         ind2 = [indtemp1,indtemp2];
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[6.784195E-03  4.25933E-03   1.08103E-02   -3.02892E-03  5.08279E-03  -3.08828E-04   -9.16923E-04   -4.83760E-03   2.49206E-03  -1.02552E-03   -4.91622E-04  4.50855E-04 ]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Forearm pronation(+)/supination(-)') || strcmp(axis,'Forearm pronation(-)/supination(+)') 
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});         [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});         ind2 = [indtemp1,indtemp2];
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[-2.36211E-03  2.93937E-03  -6.69053E-05  -1.39155E-04  -1.06309E-03  1.00099E-03  -5.83203E-04  -2.37355E-04  -2.73083E-03  -1.15824E-03   6.79267E-04   1.00675E-03 ]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Wrist deviation ulnar(+)/radial(-)') || strcmp(axis,'Wrist deviation ulnar(-)/radial(+)') 
        [~,indtemp1] = intersect(joints_names,{'Wrist deviation ulnar(+)/radial(-)'});                 [~,indtemp2] = intersect(joints_names,{'Wrist deviation ulnar(-)/radial(+)'});                  ind1 = [indtemp1,indtemp2];
        [~,ind2] = intersect(joints_names,{'Wrist flexion(+)/extension(-)'});
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[-2.14012E-02  3.26927E-02  -1.13902E-02  -1.82031E-03  1.35811E-02  1.72010E-03  -2.39317E-03  -1.89705E-02  -1.02368E-02   -1.48189E-03  1.29229E-02  8.20184E-03  ]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Wrist flexion(+)/extension(-)')
        [~,indtemp1] = intersect(joints_names,{'Wrist deviation ulnar(+)/radial(-)'});                 [~,indtemp2] = intersect(joints_names,{'Wrist deviation ulnar(-)/radial(+)'});                  ind1 = [indtemp1,indtemp2];
        [~,ind2] = intersect(joints_names,{'Wrist flexion(+)/extension(-)'});
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[-1.98904E-02 1.410779E-02   -5.64345E-03  -4.25499E-03  1.09667E-02   -4.96348E-03  -7.54046E-05  1.60476E-03   -5.13726E-03  -7.44317E-03   4.86065E-03   8.54788E-03 ]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    end
end


%% ExtensorCarpiElbow flexion(+)/extension(-)ris
if strcmp(mus_name,'ExtensorCarpiElbow flexion(+)/extension(-)ris')
    
    RegressionStructure(1).equation='RRN1';
    RegressionStructure(1).joints={'Elbow flexion(+)/extension(-)'};
    RegressionStructure(1).axe='Elbow flexion(+)/extension(-)';
    RegressionStructure(1).coeffs=[-6.48E-03 -2.13E-03  4.01E-03   -7.28E-04    1.56E-05 ]';
    RegressionStructure(2).equation='RRN4';
    RegressionStructure(2).joints={'Elbow flexion(+)/extension(-)','Forearm pronation(+)/supination(-)'};
    RegressionStructure(2).axe='Forearm pronation(+)/supination(-)'; 
    RegressionStructure(2).coeffs=[ -6.83927E-04  4.81841E-10  -1.44939E-09  6.78194E-10  -2.61266E-03  3.40180E-04   4.37423E-04  1.38498E-09  -4.84425E-09  1.21106E-09   2.26670E-09  2.79839E-09 ]';
    RegressionStructure(3).equation='RRN4';
    RegressionStructure(3).joints={'Wrist deviation ulnar(+)/radial(-)','Wrist flexion(+)/extension(-)'};
    RegressionStructure(3).axe='Wrist deviation ulnar(+)/radial(-)';
    RegressionStructure(3).coeffs=[2.54110E-02  -1.11073E-02  -2.08457E-02  1.15763E-02  -1.49666E-02  -1.18817E-02  1.27967E-02  -2.35572E-02   2.55822E-02  1.27644E-03  6.66190E-02   -8.41382E-03      ]';
    RegressionStructure(4).equation='RRN4';
    RegressionStructure(4).joints={'Wrist deviation ulnar(+)/radial(-)','Wrist flexion(+)/extension(-)'};
    RegressionStructure(4).axe='Wrist flexion(+)/extension(-)';
    RegressionStructure(4).coeffs=[-1.09221E-02   -1.73542E-02   -4.94780E-03  2.78397E-02  -7.07319E-03    1.96901E-02  9.79676E-03  -3.75544E-02   -9.52318E-03   2.45856E-02  -5.24763E-02  6.69292E-02    ]';

    
    if strcmp(axis,'Elbow flexion(+)/extension(-)')
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});         
        [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});         
        ind2 = [indtemp1,indtemp2];
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[-6.48E-03 -2.13E-03  4.01E-03   -7.28E-04    1.56E-05 ]';
            MusculotendonLength = equationRRN1(coeffs,Q);
        end
    elseif strcmp(axis,'Forearm pronation(+)/supination(-)') || strcmp(axis,'Forearm pronation(-)/supination(+)') 
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});         [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});         ind2 = [indtemp1,indtemp2];
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[ -6.83927E-04  4.81841E-10  -1.44939E-09  6.78194E-10  -2.61266E-03  3.40180E-04   4.37423E-04  1.38498E-09  -4.84425E-09  1.21106E-09   2.26670E-09  2.79839E-09 ]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Wrist deviation ulnar(+)/radial(-)') || strcmp(axis,'Wrist deviation ulnar(-)/radial(+)') 
        [~,indtemp1] = intersect(joints_names,{'Wrist deviation ulnar(+)/radial(-)'});                 [~,indtemp2] = intersect(joints_names,{'Wrist deviation ulnar(-)/radial(+)'});                  ind1 = [indtemp1,indtemp2];
        [~,ind2] = intersect(joints_names,{'Wrist flexion(+)/extension(-)'});
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[2.54110E-02  -1.11073E-02  -2.08457E-02  1.15763E-02  -1.49666E-02  -1.18817E-02  1.27967E-02  -2.35572E-02   2.55822E-02  1.27644E-03  6.66190E-02   -8.41382E-03      ]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Wrist flexion(+)/extension(-)')
        [~,indtemp1] = intersect(joints_names,{'Wrist deviation ulnar(+)/radial(-)'});                 [~,indtemp2] = intersect(joints_names,{'Wrist deviation ulnar(-)/radial(+)'});                  ind1 = [indtemp1,indtemp2];
        [~,ind2] = intersect(joints_names,{'Wrist flexion(+)/extension(-)'});
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[-1.09221E-02   -1.73542E-02   -4.94780E-03  2.78397E-02  -7.07319E-03    1.96901E-02  9.79676E-03  -3.75544E-02   -9.52318E-03   2.45856E-02  -5.24763E-02  6.69292E-02    ]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    end
end



%% FlexorCarpiRadialis
if strcmp(mus_name,'FlexorCarpiRadialis')

    RegressionStructure(1).equation='RRN4';
    RegressionStructure(1).joints={'Elbow flexion(+)/extension(-)','Forearm pronation(+)/supination(-)'};
    RegressionStructure(1).axe='Elbow flexion(+)/extension(-)';
    RegressionStructure(1).coeffs=[7.67790E-03  4.48052E-03  2.16460E-03   -1.82752E-03   -2.32672E-03   -2.30373E-04   1.51697E-04   5.65668E-03  -5.31170E-03  4.61653E-05   1.79044E-03  -1.33508E-04  ]';
    RegressionStructure(2).equation='RRN4';
    RegressionStructure(2).joints={'Elbow flexion(+)/extension(-)','Forearm pronation(+)/supination(-)'};
    RegressionStructure(2).axe='Forearm pronation(+)/supination(-)'; 
    RegressionStructure(2).coeffs=[2.67438E-03  -1.36880E-03  6.91513E-04  -6.98935E-05    -4.90337E-03   -1.23667E-03   7.01458E-04  1.72866E-04    -7.68966E-04   1.90012E-04   2.54791E-04  1.57488E-04          ]';
    RegressionStructure(3).equation='RRN4';
    RegressionStructure(3).joints={'Wrist deviation ulnar(+)/radial(-)','Wrist flexion(+)/extension(-)'};
    RegressionStructure(3).axe='Wrist deviation ulnar(+)/radial(-)';
    RegressionStructure(3).coeffs=[-8.03093E-03   -1.34897E-03   -3.33381E-03   4.95872E-03   2.86237E-03   7.19412E-03   8.91592E-03   -4.12701E-02  5.23716E-02   -2.44844E-02    -1.58656E-02    -2.30728E-02          ]';
    RegressionStructure(4).equation='RRN4';
    RegressionStructure(4).joints={'Wrist deviation ulnar(+)/radial(-)','Wrist flexion(+)/extension(-)'};
    RegressionStructure(4).axe='Wrist flexion(+)/extension(-)';
    RegressionStructure(4).coeffs=[3.05783E-02   4.97620E-03  -3.02582E-02  1.87421E-02   1.05117E-02  -1.52883E-02  -1.37820E-02  7.51537E-03  -3.89462E-02  1.89374E-02  2.99607E-02  2.18283E-02            ]';

    
    if strcmp(axis,'Elbow flexion(+)/extension(-)')
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});         [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});         ind2 = [indtemp1,indtemp2];
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[7.67790E-03  4.48052E-03  2.16460E-03   -1.82752E-03   -2.32672E-03   -2.30373E-04   1.51697E-04   5.65668E-03  -5.31170E-03  4.61653E-05   1.79044E-03  -1.33508E-04  ]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Forearm pronation(+)/supination(-)') || strcmp(axis,'Forearm pronation(-)/supination(+)') 
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});         [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});         ind2 = [indtemp1,indtemp2];
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[2.67438E-03  -1.36880E-03  6.91513E-04  -6.98935E-05    -4.90337E-03   -1.23667E-03   7.01458E-04  1.72866E-04    -7.68966E-04   1.90012E-04   2.54791E-04  1.57488E-04          ]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Wrist deviation ulnar(+)/radial(-)') || strcmp(axis,'Wrist deviation ulnar(-)/radial(+)') 
        [~,indtemp1] = intersect(joints_names,{'Wrist deviation ulnar(+)/radial(-)'});                 [~,indtemp2] = intersect(joints_names,{'Wrist deviation ulnar(-)/radial(+)'});                  ind1 = [indtemp1,indtemp2];
        [~,ind2] = intersect(joints_names,{'Wrist flexion(+)/extension(-)'});
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[-8.03093E-03   -1.34897E-03   -3.33381E-03   4.95872E-03   2.86237E-03   7.19412E-03   8.91592E-03   -4.12701E-02  5.23716E-02   -2.44844E-02    -1.58656E-02    -2.30728E-02          ]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Wrist flexion(+)/extension(-)')
        [~,indtemp1] = intersect(joints_names,{'Wrist deviation ulnar(+)/radial(-)'});                 [~,indtemp2] = intersect(joints_names,{'Wrist deviation ulnar(-)/radial(+)'});                  ind1 = [indtemp1,indtemp2];
        [~,ind2] = intersect(joints_names,{'Wrist flexion(+)/extension(-)'});
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[3.05783E-02   4.97620E-03  -3.02582E-02  1.87421E-02   1.05117E-02  -1.52883E-02  -1.37820E-02  7.51537E-03  -3.89462E-02  1.89374E-02  2.99607E-02  2.18283E-02            ]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    end
end


%% FlexorCarpiElbow flexion(+)/extension(-)ris
if strcmp(mus_name,'FlexorCarpiElbow flexion(+)/extension(-)ris')

    RegressionStructure(1).equation='RRN4';
    RegressionStructure(1).joints={'Elbow flexion(+)/extension(-)','Forearm pronation(+)/supination(-)'};
    RegressionStructure(1).axe='Elbow flexion(+)/extension(-)';
    RegressionStructure(1).coeffs=[5.51173E-03  -4.01108E-03  1.40164E-02   -5.18068E-03   -2.01298E-04  2.70126E-04   4.21473E-04  -3.28234E-03  3.92531E-03  -3.40615E-04   -1.13142E-03   -2.69541E-04             ]';
    RegressionStructure(2).equation='RRN4';
    RegressionStructure(2).joints={'Elbow flexion(+)/extension(-)','Forearm pronation(+)/supination(-)'};
    RegressionStructure(2).axe='Forearm pronation(+)/supination(-)'; 
    RegressionStructure(2).coeffs=[1.11146E-03   1.97726E-04   -1.27326E-03  5.20819E-04  -3.74902E-03  -9.92194E-04   4.27625E-04   5.64019E-04   -6.85108E-04  2.54066E-04   1.42679E-04   7.91794E-05   ]';
    RegressionStructure(3).equation='RRN4';
    RegressionStructure(3).joints={'Wrist deviation ulnar(+)/radial(-)','Wrist flexion(+)/extension(-)'};
    RegressionStructure(3).axe='Wrist deviation ulnar(+)/radial(-)';
    RegressionStructure(3).coeffs=[2.17266E-02  -1.74158E-02  -2.51289E-02  1.59383E-02  -4.81507E-03  -9.42592E-04  1.86899E-03   -1.88998E-02    1.01198E-02  -2.38388E-03   -7.70851E-03  1.77299E-03         ]';
    RegressionStructure(4).equation='RRN4';
    RegressionStructure(4).joints={'Wrist deviation ulnar(+)/radial(-)','Wrist flexion(+)/extension(-)'};
    RegressionStructure(4).axe='Wrist flexion(+)/extension(-)';
    RegressionStructure(4).coeffs=[2.97122E-02   -5.00567E-03    -6.41658E-03  1.50843E-04   1.16523E-02  -2.43971E-03  3.28030E-04  -4.07005E-03   5.00416E-03   4.94657E-03  -8.17776E-03   4.91559E-03       ]';

    
    if strcmp(axis,'Elbow flexion(+)/extension(-)')
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});         [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});         ind2 = [indtemp1,indtemp2];
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[5.51173E-03  -4.01108E-03  1.40164E-02   -5.18068E-03   -2.01298E-04  2.70126E-04   4.21473E-04  -3.28234E-03  3.92531E-03  -3.40615E-04   -1.13142E-03   -2.69541E-04             ]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Forearm pronation(+)/supination(-)') || strcmp(axis,'Forearm pronation(-)/supination(+)') 
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});         [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});         ind2 = [indtemp1,indtemp2];
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[1.11146E-03   1.97726E-04   -1.27326E-03  5.20819E-04  -3.74902E-03  -9.92194E-04   4.27625E-04   5.64019E-04   -6.85108E-04  2.54066E-04   1.42679E-04   7.91794E-05   ]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Wrist deviation ulnar(+)/radial(-)') || strcmp(axis,'Wrist deviation ulnar(-)/radial(+)') 
        [~,indtemp1] = intersect(joints_names,{'Wrist deviation ulnar(+)/radial(-)'});                 [~,indtemp2] = intersect(joints_names,{'Wrist deviation ulnar(-)/radial(+)'});                  ind1 = [indtemp1,indtemp2];
        [~,ind2] = intersect(joints_names,{'Wrist flexion(+)/extension(-)'});
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[2.17266E-02  -1.74158E-02  -2.51289E-02  1.59383E-02  -4.81507E-03  -9.42592E-04  1.86899E-03   -1.88998E-02    1.01198E-02  -2.38388E-03   -7.70851E-03  1.77299E-03         ]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Wrist flexion(+)/extension(-)')
        [~,indtemp1] = intersect(joints_names,{'Wrist deviation ulnar(+)/radial(-)'});                 [~,indtemp2] = intersect(joints_names,{'Wrist deviation ulnar(-)/radial(+)'});                  ind1 = [indtemp1,indtemp2];
        [~,ind2] = intersect(joints_names,{'Wrist flexion(+)/extension(-)'});
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[2.97122E-02   -5.00567E-03    -6.41658E-03  1.50843E-04   1.16523E-02  -2.43971E-03  3.28030E-04  -4.07005E-03   5.00416E-03   4.94657E-03  -8.17776E-03   4.91559E-03       ]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    end
end





%% PalmarisLongus
if strcmp(mus_name,'PalmarisLongus')

    RegressionStructure(1).equation='RRN4';
    RegressionStructure(1).joints={'Elbow flexion(+)/extension(-)','Forearm pronation(+)/supination(-)'};
    RegressionStructure(1).axe='Elbow flexion(+)/extension(-)';
    RegressionStructure(1).coeffs=[3.75789E-03  1.11963E-02  1.07860E-04   -1.43591E-03  -2.23585E-03  3.23306E-04  6.49814E-06  1.27466E-03 4.03585E-04   -5.81201E-04  -1.49607E-04  5.43361E-05     ]';
    RegressionStructure(2).equation='RRN4';
    RegressionStructure(2).joints={'Elbow flexion(+)/extension(-)','Forearm pronation(+)/supination(-)'};
    RegressionStructure(2).axe='Forearm pronation(+)/supination(-)'; 
    RegressionStructure(2).coeffs=[3.66899E-03  -2.53706E-03  1.13466E-03   -1.44441E-04   -5.65003E-03  -1.69339E-03  7.87399E-04   7.18247E-04  -1.89115E-03  5.10777E-04   6.23193E-04   2.34536E-04   ]';
    RegressionStructure(3).equation='RRN4';
    RegressionStructure(3).joints={'Wrist deviation ulnar(+)/radial(-)','Wrist flexion(+)/extension(-)'};
    RegressionStructure(3).axe='Wrist deviation ulnar(+)/radial(-)';
    RegressionStructure(3).coeffs=[-2.97675E-03  -2.71776E-02   8.61377E-03   7.16362E-03   -7.62851E-05  -8.28526E-03    -1.34914E-02  -5.24356E-02  6.23784E-02   1.60804E-02  -2.30912E-02    4.53652E-02 ]';
    RegressionStructure(4).equation='RRN4';
    RegressionStructure(4).joints={'Wrist deviation ulnar(+)/radial(-)','Wrist flexion(+)/extension(-)'};
    RegressionStructure(4).axe='Wrist flexion(+)/extension(-)';
    RegressionStructure(4).coeffs=[4.79301E-02   -6.89603E-03  -9.91209E-03   1.46616E-02  2.24075E-02  -5.30622E-02   -8.62529E-02  -3.72153E-02   2.30734E-02  -4.21861E-04  1.17943E-02   5.25951E-02           ]';

    
    
    if strcmp(axis,'Elbow flexion(+)/extension(-)')
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});         [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});         ind2 = [indtemp1,indtemp2];
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[3.75789E-03  1.11963E-02  1.07860E-04   -1.43591E-03  -2.23585E-03  3.23306E-04  6.49814E-06  1.27466E-03 4.03585E-04   -5.81201E-04  -1.49607E-04  5.43361E-05     ]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Forearm pronation(+)/supination(-)') || strcmp(axis,'Forearm pronation(-)/supination(+)') 
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});         [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});         ind2 = [indtemp1,indtemp2];
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[3.66899E-03  -2.53706E-03  1.13466E-03   -1.44441E-04   -5.65003E-03  -1.69339E-03  7.87399E-04   7.18247E-04  -1.89115E-03  5.10777E-04   6.23193E-04   2.34536E-04   ]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Wrist deviation ulnar(+)/radial(-)') || strcmp(axis,'Wrist deviation ulnar(-)/radial(+)') 
        [~,indtemp1] = intersect(joints_names,{'Wrist deviation ulnar(+)/radial(-)'});                 [~,indtemp2] = intersect(joints_names,{'Wrist deviation ulnar(-)/radial(+)'});                  ind1 = [indtemp1,indtemp2];
        [~,ind2] = intersect(joints_names,{'Wrist flexion(+)/extension(-)'});
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[-2.97675E-03  -2.71776E-02   8.61377E-03   7.16362E-03   -7.62851E-05  -8.28526E-03    -1.34914E-02  -5.24356E-02  6.23784E-02   1.60804E-02  -2.30912E-02    4.53652E-02 ]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Wrist flexion(+)/extension(-)')
        [~,indtemp1] = intersect(joints_names,{'Wrist deviation ulnar(+)/radial(-)'});                 [~,indtemp2] = intersect(joints_names,{'Wrist deviation ulnar(-)/radial(+)'});                  ind1 = [indtemp1,indtemp2];
        [~,ind2] = intersect(joints_names,{'Wrist flexion(+)/extension(-)'});
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[4.79301E-02   -6.89603E-03  -9.91209E-03   1.46616E-02  2.24075E-02  -5.30622E-02   -8.62529E-02  -3.72153E-02   2.30734E-02  -4.21861E-04  1.17943E-02   5.25951E-02           ]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    end
end

%% Coracobrachialis
if strcmp(mus_name,'Coracobrachialis')
    if strcmp(axis,'GH plane of elevation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[-1.15865363697200e-05,0.00140339223313259,0.0183179833429557,-6.46454628978421e-06,-5.98257343110201e-05,0.00807488879127630,0.000212701034322458,-0.00166275927328543,-0.00619068062595787,-7.59727291380613e-05,0.0239744883978296,-0.000599724502365368,0.00117990053885911,0.000373372435731342,-0.00780488027565551,-0.000311064760228213,-0.0100079524217660,-0.000394586726462386,0.000248894616902110,0.000156763099865480]';
            MusculotendonLength = equationRRN5(coeffs,Q);
        end
    elseif strcmp(axis,'Negative GH elevation angle')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[-0.0285919577064330,0.0182086966547685,-0.0320067029386777,0.00114310909370626,0.0123743968772033,0.0286634756573278,-0.000470897856807733,-0.00258237968254196,-0.00439242034544115,-3.18711167457609e-05,0.0163508964379904,0.00129528673267203,-0.00167921031141566,-0.000812522241032555,-0.0101944512336338,0.000211642286182295,-0.0187163713848721,3.02343774088605e-05,0.000127426092134105,0.000787769959266373]';
            MusculotendonLength = equationRRN5(coeffs,Q);
        end
    elseif strcmp(axis,'GH axial rotation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[0.00157519254881346,-5.41862828424924e-05,0.00107399419355916,-0.00136306498199723,-0.000307324964547279,-0.000798450687857989,-0.000831303655678573,-9.08337449429920e-05,5.83923669356124e-06,0.000316772797013986,0.00126580680721034,0.000524483352797224,-0.000924179311953307,0.000184546477079433,0.000257799961268352,0.000255375448446123,-0.000382917661719064,0.000768746980211306,-0.000288723840537743,-7.07140741717053e-05]';
            MusculotendonLength = equationRRN5(coeffs,Q);
        end
    end
end

%% Biceps Short
if strcmp(mus_name,'BicepsS')
    if strcmp(axis,'GH plane of elevation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[-0.000248428663834059,0.000164002283819384,0.0133529912200126,4.01027280024895e-05,0.000407520581889503,0.00660901440153051,0.000404879727179977,0.000313604290171473,-0.00509255972648633,-0.000167453961074369,0.0278488320471487,-0.00106856417598031,0.00685032216704394,0.00239907449886456,-0.00665017342078105,-0.000548048761731458,-0.0171215482801469,-0.00414245582473631,0.00102434236949806,0.000752194980613206,-0.00249931262556152,-0.000853294714624891,0.00281926491492293,0.000551981128081027,-0.000141064997447401,-0.000631259447588333,0.000677878827815637]';
            MusculotendonLength = equationRRN6(coeffs,Q);
        end
    elseif strcmp(axis,'Negative GH elevation angle')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[-0.0297413857743431,0.0120217693339594,-0.0306518839019532,0.000747830174847685,0.0132658728815233,0.0382514236224357,-0.000354276520001598,-0.00201600730904811,-0.0103699527771312,-0.000143188535671828,0.0218010943481805,0.00668489847539932,0.000306778825595137,-0.00627603390484238,-0.0137633658352923,0.000226469562244415,-0.0337838044878360,-0.00396112208374536,0.000901021664941630,0.00115936636090745,-0.000331449557816031,7.28638740333769e-05,0.0117762850726194,0.00112406334806102,-0.000682028309263476,0.000104307070712434,0.00182844612944158]';
            MusculotendonLength = equationRRN6(coeffs,Q);
        end
    elseif strcmp(axis,'GH axial rotation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[0.00421372975769216,0.00132479311140787,-0.00652360135035131,-0.00225227525609336,-0.00313823371589950,0.000538658356048545,0.00192173964710165,0.00722323629630867,-0.00166647694422093,-0.000113179848459099,0.000325960114303425,-0.00437717913248256,0.00425664421087765,5.49884140016813e-05,0.000323634941972235,-0.000695557454079626,0.000998932164343572,0.000914084300285640,-0.00154584069319785,-0.000646116861632924,-0.000595993250427194,0.000810688184138797]';            MusculotendonLength = equationRRN12(coeffs,Q);
        end
    elseif strcmp(axis,'Elbow flexion(+)/extension(-)')
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});         [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});         ind2 = [indtemp1,indtemp2];
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[0.0131992652574655,0.0155636304531376,0.0107795530883361,-0.00469843205207038,-0.00529051575169456,-0.00505571643420409,0.00331525088521545,-0.00377731058456298,0.00314355218963127,0.00257332824003313,8.44726632101766e-05,-0.00239365531967115]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Forearm pronation(+)/supination(-)') || strcmp(axis,'Forearm pronation(-)/supination(+)') 
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});         [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});         ind2 = [indtemp1,indtemp2];
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[-0.00452487946598804,-0.00426386762906045,-0.00226558455865923,0.00102730215576759,0.00286226480209397,0.00245048084591499,-0.00226223589393806,-0.0107586845973667,0.000363319760195604,0.00236012685751211,0.000754596082544890,0.00637298055303510]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    end
end


%% Biceps Long
if strcmp(mus_name,'BicepsL')
    if strcmp(axis,'GH plane of elevation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[8.00830463187116e-06,0.0201848273967996,-6.56639610656646e-06,0.000405406800654362,0.00331565658608709,-0.000252281509270424,-0.000187978326181401,-0.0182229282279879,0.00620056453831911,0.000608542320142084,0.0190648845761144,0.0150586648847140,0.00618645669182767,-0.0122195010421923,-0.000262767541565410,-0.00161525326026160,-0.000215789999097442,0.00338877743474546,-7.15268655709165e-05,-0.000806154058093171,0.00186315437184223,-0.0315116506211882,0.00592312607809968,-0.00244047474614429,-0.0152409680610355,-0.00179363467119655,-0.00443543961524654,-0.00343360430439038,0.00179910857012469,-0.00599458673453016,0.00115869597860509,-0.00757905426330399,0.00362462681091874,-0.0122166616372954,-0.0139859379583094,-0.0192042592672380,0.00399677263845804,0.0384910369638837,0.00221758964726552,0.0295854791571626,0.00847342162244957,0.00757178857809810,0.00313063348349575,-0.00100935175603997,-0.00696925089058256,-0.00374601108967775,0.000355974186643324,0.000508221125835966,-0.00248403897191239,0.00189897931628262,0.00955245717301804,0.0188162804816792,-0.00206277499004073,0.00129744414364592,0.00925128608225653,-0.00844591919918288,-0.0363576410738930,0.0120042815965116,0.00265865117363927,-0.00118337855552354,0.00642373967736263,0.00492507677289557,0.0274316950117316,-0.0250142641992772,-0.00156199098222656,-0.00142643794499968,-0.0165355453313087,-0.00465596206256086,-0.00227556767869917,-0.00453728348474792,0.00440996590879455,0.00475193662376133]';
            MusculotendonLength = equationRRN8(coeffs,Q);
        end
    elseif strcmp(axis,'Negative GH elevation angle')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[0.00535663931318102,-0.00988489897298433,0.0195711184664443,-0.0146005472753858,0.00402089733348120,-0.00819898671316104,-0.00122947208816660,0.0167929814029844,0.00125000421348546,0.00980239615321646,-0.0138080889217257,-0.0206519107809744,-0.00347785759649162,0.00959062250781044,0.00616963862177860,-0.00361276375063749,-0.00863400917014484,-0.0103304763803214,-0.00252767582469874,0.00630756353709417,0.00932702655964557,0.0256836104445982,-0.0147244856899025,-0.00162824769038820,9.39428544253838e-05,-0.00381791506702074,0.00404044118217244,-0.0173898153858075,0.00956427587434181,0.0266476394696343,0.0116936864726123,0.0193162212355582,-0.0266108085573109,0.0165964949451612,0.0422663235664100,0.0169522373198597,-0.00157022237605476,-0.0423532731009165,0.000810788418872441,-0.0347985560085969,-0.0288931915661851,-0.00792845904144842,-0.00708741624475103,0.0348805929261478,-0.00244844021502150,0.00772201914545898,0.000874814202150895,-0.00311438892564380,-0.00181911787234529,-0.00520967873886632,0.00249063617250189,-0.0199976309372278,-0.000444406686862337,0.00332098578027122,-0.0131275682371049,-0.00108149260019746,0.0351350251549660,-0.0420116065391240,-0.00258897587350656,-5.53715523448259e-05,-0.00396499127570153,0.00317302860261694,-0.0386956955061248,0.0466515594037600,0.00209786192743721,0.00181825026730840,0.0223775879060873,0.00887878314477113,-0.00477423441053936,0.00430799803886760,-0.00355279130599959,-0.000706920043045772]';
            MusculotendonLength = equationRRN8(coeffs,Q);
        end
    elseif strcmp(axis,'GH axial rotation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[0.00584729729275396,-0.0143592147632773,5.13679598161776e-05,0.0133995103952314,-0.00120110119499541,0.000275446702476314,-0.00166812300131742,0.00902710844893774,-0.000602069948030762,-0.000155715557604856,-0.0156108381768998,-0.0136877825865483,-0.00398726047388010,0.00678943165504465,0.00112332911710857,0.0115245429130297,0.00182976701015139,0.00687314894887432,-0.000414717340046529,-0.00818994711831603,0.0129486979058932,-0.00578588834090186,0.000536123137553668,0.00211265954337615,-0.00503251388471379,-0.00378118452681277,-0.00180404890279833,0.0178954859492521,-0.00387005691767687,-0.00241754309391243,-0.0130013152538539,-0.00140414427465470,0.00531632599816181,0.00284416097900302,-0.0554065192501743,0.00381811595652727,-0.00191254964082556,0.0531127315685282,-0.00530632294321659,0.00323551229993424,-0.0189823638246616,-0.000667421931395214,0.000531877485062590,-0.00148519653321115,0.0112965387593054,-0.00455101066152932,-0.000653292226501181,0.00459322390950451,-0.00834559003470383,0.000240096823826016,-0.00125423423447306,0.00959350124934255,0.00104143886405207,0.00184050863823045,-0.00165835326311024,0.00247180694983874,-0.0389909627881090,0.0519148932292464,0.000829110402232633,0.00339458043335953,-0.000569021292665814,-0.00179959286207334,0.0394960101744545,-0.0497721144932439,-0.000702925441713946,0.000457946698815703,-0.00263397129201605,0.00104088397863075,-0.00132527360089216,0.0196541265650767,-0.00161258780273723,-0.00721436732515284]';
            MusculotendonLength = equationRRN8(coeffs,Q);
        end
    elseif strcmp(axis,'Elbow flexion(+)/extension(-)')
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});         [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});         ind2 = [indtemp1,indtemp2];
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[0.0131992652574655,0.0155636304531376,0.0107795530883361,-0.00469843205207038,-0.00529051575169456,-0.00505571643420409,0.00331525088521545,-0.00377731058456298,0.00314355218963127,0.00257332824003313,8.44726632101766e-05,-0.00239365531967115]';
            MusculotendonLength = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Forearm pronation(+)/supination(-)') || strcmp(axis,'Forearm pronation(-)/supination(+)') 
        [~,ind1] = intersect(joints_names,{'Elbow flexion(+)/extension(-)'});
        [~,indtemp1] = intersect(joints_names,{'Forearm pronation(+)/supination(-)'});         [~,indtemp2] = intersect(joints_names,{'Forearm pronation(-)/supination(+)'});         ind2 = [indtemp1,indtemp2];
        if ~isempty(ind1) && ~isempty(ind2)
            Q  = q([ind1,ind2],:)';
            coeffs=[-0.00452487946598804,-0.00426386762906045,-0.00226558455865923,0.00102730215576759,0.00286226480209397,0.00245048084591499,-0.00226223589393806,-0.0107586845973667,0.000363319760195604,0.00236012685751211,0.000754596082544890,0.00637298055303510]';
           MusculotendonLength = equationRRN4(coeffs,Q);
        end
    end
end



%% Posterior deltoid 
if strcmp(mus_name,'Deltoid_pos')
    if strcmp(axis,'GH plane of elevation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[-8.44348675531956e-05,-0.0445601102576130,-0.00113464026335216,0.000141167292797509,-0.0124410329915486,-0.000244601920981815,8.00491841584643e-05,0.0174495034202025,0.00174331653373807,-1.66150319305373e-05,0.0127871885116710,-0.00218036422589227,0.000793153310703325,0.00183189615496638,-0.0181545915799782,0.0221619585287569,0.0228445422659538,0.000561175010469857,-0.000813345478802113,-0.000691350489000619,0.0512190625605798,-0.0328081746163050,-0.0127694141523163,-0.00114843770015431,5.68946310085462e-05,0.000243279465734130,-0.0134916423777709,-0.00173315433277577,-0.000281952617124283,0.00128517327658848,-0.0281382865371539,0.0133320385478029,0.00289002380412631,-0.000432666000542283,-0.000104983704165568,-7.67113127137833e-05,-0.00573361304948454,0.00128082283427204,0.00721978478276311,0.000211949557197108,0.000105909326851097,6.92695605267269e-05]';
            MusculotendonLength = equationRRN7(coeffs,Q);
        end
    elseif strcmp(axis,'Negative GH elevation angle')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[0.0175211273113008,0.0140882619469978,-0.0459343204776543,-0.00185324237218158,-0.0393621018631241,0.00104357552425917,0.000551443530004102,0.0155464730493862,0.00572658951694853,-1.06761150059189e-05,-0.0269727302707328,0.000611262810725002,0.00312189526366679,-0.00532453844981156,0.0908023763198815,0.000743550142701341,-0.00362024130209795,0.00132073758999413,0.00266671330086883,-0.000638887980633906,-0.0654677507119101,0.00702736134215702,0.0192540802571370,0.00131715552471154,-0.00141902280096204,0.000156492620400050,0.0648323593490089,-0.00838828670115863,-0.000733851917345073,-0.00272397795432591,0.0291199062983172,-0.00556542935634373,0.000554670298182453,-0.00102652527094842,-4.93094733605584e-05,-6.19292716352247e-05,-0.0556893674811458,0.00506499013619783,-0.0799558288983095,-0.00150808075535311,0.00440181653461943,0.000313634563763366,-0.00244821999795913,0.000316761349416727,2.27848850176962e-05,0.0503535300473095,0.00277643127861991,-0.00265302286209952,0.00318238343276890,-0.00281100000749710,-0.000575989098663811,0.00376192017831620,-0.00286577282955730,0.00206571482056149]';
            MusculotendonLength = equationRRN9(coeffs,Q);
        end
    elseif strcmp(axis,'GH axial rotation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[-0.00840598641920741,-0.00175542685732710,0.000274222895984323,0.00205015801498356,0.000115954890040867,-1.81861856605365e-05,0.000988333831492828,0.000927693697516971,-0.000173380278879225,-0.000646767259757188,0.00245751878903950,0.000595383071214689,-0.00129325277729697,-0.000573003852691094,0.000514248525533991,0.00164453356054944,0.000465487892148116,-0.000812029184619263,0.00191614214127572,0.00137852003481733,-0.00395618216865354,-0.000392362081118149,-5.92702484446060e-06,0.000464233353714543,-0.00328948119062842,-0.000830660938842060,0.000979911271291461,-0.00187461536435731,0.000779975702079646,-0.000839510224469727,0.00143307109614292,-0.000874988075645888,-0.000489693243633057,0.000208549204066981,0.00148033528124790,0.000263615115209282,0.000564534620318428,0.000885210949161403,0.000373913183822788,-0.000230081648792364,0.000378254924787706,-0.000180473144595983]';
            MusculotendonLength = equationRRN7(coeffs,Q);
        end
    end
end

%% Anterior deltoid 
if strcmp(mus_name,'Deltoid_ant')
    if strcmp(axis,'GH plane of elevation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[1.10588707909607e-05,0.0499096788246167,4.08170232958270e-05,-2.73330107730070e-05,-0.0113600350400074,-8.64084194031989e-05,8.86982403459995e-05,-0.00505664815301723,-0.000260178447822644,-4.07439091912396e-05,0.00652321827360393,0.00243346023679405,-3.02559584127148e-05,0.00141296001668502,0.00644691175849261,0.00531951059155044,-0.0232644527223515,-0.000291787659179414,-0.00345626942581843,-0.000458045684011571,-0.00305119589040994,-0.0164427661934489,-0.00383240569873498,-0.000716025702829186,0.000819406653094840,0.00136149397808988,0.0117287302005003,0.00781462553794460,0.000186839472472558,0.00539623052293607,-0.00156854723013266,0.0732754000634833,-0.00254290939021023,0.000635363484239774,0.000366323486634549,-0.00123875518397456,0.000352114662980126,-0.00601460404146621,0.0111635083110748,0.000762028914424177,-0.00617031960932210,0.000179146406524884,0.000706570884872423,0.000220649541699541,-2.65653024821869e-05,-0.0118471174591850,0.000697224422165741,0.00375419325275794,-0.00615660787009157,0.00433471314710161,-2.18508482690595e-06,-0.00635906304890371,0.00381499608155785,-0.00276577919826687,0.000343987350830969,-0.00165076426822477,0.00173702669567939,0.0540189557971273,-0.201099999008921,0.00391259532016335,-0.000380945532770654,5.27735197107205e-05,0.000321755425289974,-0.150179790119254,0.00753403472777451,0.166120646147343,-0.00607869536680190,-0.0667587059788882,-0.00658079724697920,0.310070107302414,-0.00120759018480050,-0.248034379561135,0.00100104773046344,0.0799259123026061,0.00106122788943260]';
            MusculotendonLength = equationRRN11(coeffs,Q);
        end
    elseif strcmp(axis,'Negative GH elevation angle')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[-0.0155128178967086,0.00598455818025519,0.0496009093887653,-0.000459669901136907,0.0239295198193654,0.00238932038267767,0.00101729893418399,-0.0115106810221497,-0.00708623348119344,-2.80262677515674e-05,-0.0245261573232794,-0.00378405500788113,0.00199506217068983,0.00693758022614204,-0.0174342086334270,0.000303299612650199,0.0115301640216072,0.000803391901192292,0.00101680365923353,0.000640127249145865,0.0951064733047210,-0.0314591566300342,0.0124104860843373,-2.00230845054691e-05,-0.00186621357613421,-0.00187786499351279,-0.00848331125423817,-0.0148397930574540,-0.000560890438844403,-0.00653585715192971,-0.367748274352859,0.138049949418478,0.00299568099678174,-0.000268576283555573,0.000526582084562643,9.91044654754644e-05,-0.000772035673265291,0.0136085928801185,-0.0165607423011852,-0.00142579042497252,0.0126557457238674,-0.000224598162441503,0.00228495427758760,-0.000579209742459960,-1.19880697301718e-06,0.0138807476139370,-0.00438620305265592,-0.0285207719964913,0.00897954309234033,-0.0109659763247574,-0.00219512682248088,0.00214897748986691,-0.00481175091918233,0.0105503849223785,0.0249118269221551,0.00414058464497157,-0.00164236492014429,0.693267774829356,-0.245142287456417,-0.00683989303103973,-0.000100806882119052,-0.000341611189978687,0.000181725252253357,-0.654938014750513,-0.00781977004369611,0.250183385283804,0.00843393030029685,-0.00697824413636538,0.00652253865046470,0.190871224141146,-0.00156544220640838,-0.0272842071832853,0.000724929888052492,-0.0257864995696612,0.00156271505258565]';
            MusculotendonLength = equationRRN11(coeffs,Q);
        end
    elseif strcmp(axis,'GH axial rotation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[0.00505083810028859,-0.000204220222803012,4.06378856869676e-05,-0.00663562282370859,-0.00258198517526631,0.000168135824122586,-0.00306533271618511,-1.32449871037097e-05,0.000285268575557004,0.00147504890674925,0.000871605214845360,0.00240954412219496,-0.000375488719620820,-0.00255351017755487,0.0120187673799264,-0.00338360683438058,-0.00154851412931553,-2.98491482895066e-05,0.000375908909416997,-0.000779236560922426,-0.0380898023742107,-0.00573232913202099,0.000994743825991550,-3.49752136651611e-05,-0.00354036801181518,0.00373174364004283,0.00366387030476876,0.00430935210213131,-6.68560243572012e-05,-0.00139199400827284,0.149827205682835,0.0320679025497179,-0.000133148764777037,0.000256352624387131,0.00338237965999920,-0.00361209205047657,-0.000822267024617380,-0.00345766638836176,-0.00794241025368986,-0.000601987517607980,7.85899798770525e-05,-2.50452551265055e-05,0.000435295057039093,-0.000192798783197917,7.06721837857350e-05,0.00508671278529081,0.00211831741575625,0.00519230705686109,-0.000570150907754089,0.000472040635979162,-0.00224362443005256,0.000176513846869801,-0.00516273260548466,0.00465730571246438,-0.00294515194349553,0.000966591954547462,0.000792023082005320,-0.368504891142155,-0.0506373863649210,-0.00125210253423540,0.000309025182949405,-0.00117859552610457,0.00112065642554051,0.508733759907140,0.000266557863377472,-0.369929967563587,0.00223886007437626,0.110235687808217,0.00112361302479815,0.0305682262646930,-0.00144834994167536,0.00440076234451997,-0.000470410851903898,-0.00863769783433167,0.000494759993132649]';
            MusculotendonLength = equationRRN11(coeffs,Q);
        end
    end
end

%% Middle Deltoid
if strcmp(mus_name,'Deltoid_mid')
    if strcmp(axis,'GH plane of elevation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[-0.000119506152061510,0.0178493881840195,4.87764602423931e-05,0.000406777558618567,-0.000324347100989325,0.000355799929278548,0.00104289202213942,-0.00369853034589569,0.000707792140592273,-0.00209160347499176,-0.0380112937011203,0.00710092210093649,0.00233431527836135,0.00591580750852954,0.0100149818205443,-0.00479865359576632,-0.0138999145614449,-0.000251896784876385,-0.0415137439458014,-0.00212428832763016,-0.0808407552806123,0.00425893472553345,0.00736165457791354,-0.00412306280010990,-0.0227027112306830,-0.00225465072155978,-0.00474531609445659,0.00161964719906658,0.00106736696970533,-0.00592357366438439,0.417333797543444,-0.0378069568471480,0.00644176379191668,-0.00347408926889952,0.0588177904115841,0.00372599187507452,-0.000290581189060896,0.00783623278164063,-0.00183079027864024,0.00229628604789138,0.000831210438541426,1.15380547139058e-06,0.000289978731332634,-0.000297130801017623,0.000612417150447886,-0.00348957492863238,0.00189931275796885,0.00204763686007329,0.0114305819905194,-0.00301382211886459,-0.0162580028171875,0.0111376247390263,-0.0105016640669903,0.0305722618201967,0.00407539711760592,8.71508221209544e-05,-0.00724295033419825,-0.951644196028243,0.0872584113513601,0.000615912425846225,-0.00142622520048621,-0.0210455305935465,-0.00140649876277473,1.15377938938987,-0.00141855916389979,-0.718784495584279,-0.00136793919019242,0.181173719349815,-0.000576164469018914,-0.107102549427908,0.000675091979420995,0.0682004686830255,0.00112437433263592,-0.0176025131892987,0.000405279130872925]';
            MusculotendonLength = equationRRN11(coeffs,Q);
        end
    elseif strcmp(axis,'Negative GH elevation angle')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[0.0314712798389042,-0.00161496469998131,0.0171436767927153,-0.0215056623073595,0.00218856140251461,-0.0166812031972795,-0.00996174375601600,-0.00261542178255362,-0.00299811511460819,0.0307185802633234,0.00501968851205940,0.00180525722387573,0.00485934388506339,-0.0114814436856987,-0.0114378223720967,-0.00612145816925558,-0.00599317261982302,0.00496873575492148,0.0252492468782623,-0.0379230516466030,-0.0772155065489294,0.236809630417617,-0.0112005046175600,0.00761184291696435,-0.0181864237746498,-0.0206609591842476,0.0242770521354641,-0.0185954554899350,-0.00349583977595546,-0.00136357863342015,0.276280075319610,-1.05303263275553,0.00178293010076473,0.00197451216358245,-0.0186409698028264,0.0542919240955840,-0.00802215492187005,0.00609687960740461,0.00817421898811899,-0.00240077957419300,0.00507689397610442,-0.000508607411271095,0.00100415497174795,-0.000324247141043651,-0.00737813420313703,-0.00357057640637657,-0.00798918871801287,-0.00910546179103590,0.0210362117191880,-0.00124606733388865,-0.000454602918433294,-0.00364900391308834,0.0200972743955959,-2.18394029639079e-05,0.00272743663689059,-0.00134274190235692,-0.0108716129231447,-0.488152936091599,2.35269534929309,0.00425254944247272,-0.00194307753264731,0.0132836218528120,-0.0193659402485905,0.499724100435028,0.000273189180963957,-0.277185894645773,-0.000726327463152237,0.0646707147627825,-0.000252971274062511,-2.86128609765940,-0.000954512076369118,1.79943862975328,0.000365339855151167,-0.458900971929325,0.000289709182631209]';
            MusculotendonLength = equationRRN11(coeffs,Q);
        end
    elseif strcmp(axis,'GH axial rotation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[0.0337654919005524,-0.0285344448449251,0.00268642005667384,0.0272726356408731,0.00919624558733008,-0.000945972405246375,-0.145111431056507,-0.000240590136012507,-0.00149714397765192,0.0371303611415969,0.0119997852584559,0.0269842746307446,-0.0138085961037405,-0.0413439257776653,-0.00123960973833717,-0.144721834092185,0.00970975099271811,0.00468470159085366,0.136135981353084,-0.0381218769765248,-0.355490688964875,1.08567530255229,-0.00354152366042744,0.0147955810606623,-0.334619160724885,0.0897375929023916,-0.00261088571699760,-0.0686384237039679,-0.00480731814248121,0.0259610506933080,1.47625419640699,-3.78572948318308,-0.000120318722916521,0.000798267061647207,0.345006903045339,-0.0410010128953911,-0.00203492424182021,0.00988693643027061,0.0335105429461767,-0.0120323651074349,0.0377507140235520,0.00166484082281452,0.000506626606131104,0.000673253541620698,0.00861590031267059,-0.0260935294768664,-0.0682146517612933,-0.0577103791069288,0.00741845619718357,-0.00775002586031828,0.00388614534826652,-0.0202472067024094,0.0874701145905927,-0.0207332700202342,0.0467526118823147,0.0109377533218916,0.00331203947079552,-3.06626978944440,7.45255338136060,-0.00195883993937533,-6.22787752462515e-05,-0.124818736517772,0.00139883433827160,3.55848752069759,-0.000634958245251738,-2.16874472802357,0.000298620347160480,0.541037865201768,0.000342273026803970,-8.37157340784810,5.82287970826481e-05,4.99787665430369,-0.000217255971506555,-1.22997365397665,-0.000170212280426471]';
            MusculotendonLength = equationRRN11(coeffs,Q);
        end
    end
end


%% Pectoralis Major 1
if strcmp(mus_name,'PECM1')
    if strcmp(axis,'GH plane of elevation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[8.15989902521140e-06,0.000339872647987379,0.0203151107025655,8.59365090673915e-05,-4.54682899450308e-05,-0.00210193160227522,-6.24885776163820e-05,-0.000228072819801544,-0.00132708458255426,-0.000105858702480508,0.0280799227017357,0.00152266973667019,0.00432229117184562,0.00720998565308205,-0.0100089975517733,0.000142766528787804,-0.0114088447558140,-0.000625208901300294,-0.00135776136981933,0.000381242372252630,-0.00223941151629095,-0.00246033329293307,-0.00605194356129192,0.00274113816687701,-0.000388403149340203,-0.00101728508492778,0.00563798206283670,0.00177462910318108,0.000494380018379206,-0.00220798886689130,0.00148880751754088,-0.000465955781405736,0.00125994522308845,-0.000543148027631697,-4.74908032985407e-05,-1.75645123146095e-05,0.00456729873380646,0.00186619041318021,-0.00313178420311095,0.000202118225996078,-0.000182096714289714,6.82680936483523e-05,5.41368192241151e-05,0.000195967123912243,4.10570361870188e-05,-0.00174958693060388,-0.00101675568338058,0.00637489870620735,-0.00403217087156435,-0.00306242144240409,0.00128375478173926,-0.00252399405495926,-0.00185187136426893,0.000504907560301600]';
            MusculotendonLength = equationRRN9(coeffs,Q);
        end
    elseif strcmp(axis,'Negative GH elevation angle')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[0,0.0212000000000000,0.0101000000000000,-0.000250000000000000,0.0145000000000000,0.0183000000000000,0.00305000000000000,-0.00386000000000000,-0.00806000000000000,0.000982000000000000,-0.0123000000000000,0.00604000000000000,-0.00647000000000000,0.000967000000000000,-0.0132000000000000,0.00454000000000000,0.0122000000000000,0.00240000000000000,-0.00206000000000000,-0.00569000000000000,0.00636000000000000,-0.00220000000000000,-0.00958000000000000,-0.00391000000000000,-0.00127000000000000,0.000517000000000000,-0.00363000000000000,-0.00832000000000000,-0.000538000000000000,0.00282000000000000,0.000653000000000000,-0.00149000000000000,0.00185000000000000,0.00255000000000000,0.000319000000000000,0.000385000000000000,-0.0126000000000000,0.00221000000000000,0.00281000000000000,-0.000936000000000000,-0.00132000000000000,-0.000131000000000000,0.000262000000000000,0.000305000000000000,-0.000295000000000000,0.00491000000000000,0.00811000000000000,-0.00160000000000000,0.000102000000000000,-0.00217000000000000,0.00262000000000000,-0.000771000000000000,0.00447000000000000,-0.000179000000000000]';
            MusculotendonLength = equationRRN9(coeffs,Q);
        end
    elseif strcmp(axis,'GH axial rotation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[0.0116943163944434,0.000246847558260870,0.000130159905098905,-0.00970898758241952,1.41630800889111e-05,-0.00420819050733146,-0.00979667714411170,1.57966411501333e-05,0.000717296018430429,0.00326717067089954,0.00377996759673790,-0.000404646427462907,0.00554562461038090,-0.00139434291692763,0.00301607833188582,-0.000532562974980272,0.00156659262690395,-0.00372169958674791,-0.000337117431451012,0.00432153941571249,-0.00188584380364529,0.00140797108076260,0.000913004956183051,0.000590847320669030,-0.000541287387300067,-0.00330220057126562,-0.00125069112608913,0.00374302733969272,0.000204534139011637,0.00104271484462412,-0.00116788088218750,0.000244303976653849,-0.000733254257029962,-0.000383814375549298,0.000634623728204721,3.46165615810540e-05,0.00171558534224275,-0.000481873214501816,-0.00129028811339444,-0.000250506053746718,7.64039016541192e-06,0.000914669475253234,-6.53773122375034e-05,0.000109234742215093,0.000336145245589249,0.00385248623826559,-0.00274832564462368,-0.00839176060558326,0.00218863342172147,0.000580369664307238,0.00384456832350135,0.000550133157959176,-0.00106453756548109,-0.000597585799490025]';
            MusculotendonLength = equationRRN9(coeffs,Q);
        end
    end
end


%% Pectoralis Major 2
if strcmp(mus_name,'PECM2')
    if strcmp(axis,'GH plane of elevation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[-2.02213525593610e-05,0.000372845805161729,0.0284672862515944,0.000138102741428294,1.06943055599323e-05,-0.00818780020961141,0.000319058950799571,-0.000195807342439664,-0.00102187355661471,-0.000463426695846113,0.0312549679422724,0.00142484464791029,0.00754642297538541,0.00186074680943390,-0.0120436876227873,0.000134444801571973,-0.0156040487400639,-0.00376990897535357,-0.00136246164545558,0.00209108128295955,-0.00173378116175776,-0.00236101937585557,-0.00956657470693411,0.00375360154727658,-0.000156035756787825,-0.00152966994359697,0.00662789537506090,0.00436927747817253,-0.000287257920233032,-0.000727264860257296,0.00131763304813846,-0.000566748020045745,0.00383772596370647,-0.000345751205038984,-0.000219997560192427,-0.000377312841979655,0.00357721804530171,0.00127925117496044,-0.00350328754290757,-0.00117865368459457,0.000389506868437673,0.00102579427502415,6.84614631907052e-06,0.000364105420741219,7.92086656830207e-05,-0.00303873360784216,-0.00217980335108120,0.0116311905804655,-0.00500660980787686,-0.00437333063852653,-0.00274263999584745,-0.00152039978587614,-0.000999423738085272,0.000976300405396835]';
            MusculotendonLength = equationRRN9(coeffs,Q);
        end
    elseif strcmp(axis,'Negative GH elevation angle')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[-0.0425356748954372,0.0298220746411063,0.00582441245185329,0.00543921394139865,0.0162051180817737,0.0232520246008990,0.00694824359829740,-0.00513228173648794,-0.0152864724287554,-0.00162136974559083,-0.0298914546508261,0.00930395022510229,-0.0123782331694846,-0.00275393196401316,-0.0175700161931953,0.00231852362664508,0.0239240906597316,0.00690407993938225,0.000485962877660591,-0.0112380152432111,0.0145059728481216,-0.00308047865181448,-0.0153513624272748,-0.00266431960213593,-0.00209111098468164,0.00500187341111106,-0.00717983656954109,-0.0144020677179800,-0.00152842344636163,0.00396690664709701,0.000846145666991050,-0.00171904386396444,0.00246946461746907,0.000608780270767630,3.46804478874000e-05,0.000220679009499585,-0.0257590364054524,0.00159884496829666,0.00881650091651957,0.000814463601887126,-0.000871538772509244,-0.00239188127867638,0.000275987438932211,0.00169959273287887,-0.000344949385601840,0.00496357692466049,0.0136411991568449,0.00100282573757498,-0.000614730406246263,-0.00394718593659799,-0.000202053459373895,0.000739819991391953,0.0113098308417443,0.000423677357571850]';
            MusculotendonLength = equationRRN9(coeffs,Q);
        end
    elseif strcmp(axis,'GH axial rotation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[0.00964171376610719,0.000477546203154415,0.00604543598316240,-0.0152872589667732,-7.16927614315631e-05,-0.00812121411109948,-0.0101478439787005,5.72682453195525e-05,0.00303483851120807,0.00655686854520788,0.00534041364626249,0.000363180669470756,0.0115081654771807,0.00238023984839628,-3.24041483557647e-05,-0.000798541386387183,0.00295774558564017,-0.00652855160487616,-0.00140341429035036,0.000122922649729113,-0.00268323858952612,0.000780043367912801,-0.00158013151300825,0.000386417596489631,-0.000926238281411328,-0.00693196323442384,-0.00105388539958735,0.00619223682952681,0.00111364519238347,0.00592335480392036,-0.00124743099474204,0.000148973157752310,-0.000185980449281470,0.000289979291770251,0.000941868449111643,0.00120558069317094,0.00243120524651183,0.000168224863351482,-0.00329195192572225,-0.00189342510617683,-0.000406713122530648,0.000830132479580857,-9.91670541737668e-05,-0.000193959578927214,-5.10409682528370e-05,0.00535663333920379,-0.00197795744994308,-0.00974523737735204,0.00218779212902133,0.000340243064483664,0.00667658985015215,-0.000935640424110068,-0.00178205969791404,-0.000662149586772739]';
            MusculotendonLength = equationRRN9(coeffs,Q);
        end
    end
end



%% Pectoralis Major 3
if strcmp(mus_name,'PECM3')
    if strcmp(axis,'GH plane of elevation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[-0.000104248210590167,0.000145451249122510,0.0340710551751982,0.000344783591570903,0.000208273630626825,-0.0179479532682273,0.000334395489274972,-0.000179932738938055,0.00274462620467645,-0.000577649547114593,0.0282125657636198,0.000652385053616332,0.0131441477983535,-0.00137118995854614,-0.0168342137021388,-0.000298115343755091,-0.000827502290922856,-0.0102375046782479,-0.000606139392370169,0.000399991838972432,-0.00317880604953884,-0.00225234719017820,-0.0287759199890153,0.00142998010943247,0.000234995721528540,-0.00199161098444512,0.00416086685271901,0.00857329674280529,-0.000538666517863751,0.00676189817396548,0.00144793170079233,-0.000524025975518173,0.0117853267331670,0.00231693701085641,-0.000381366980326757,-0.000549864107472434,0.00202021386532897,0.00114375832076588,-0.00344201177690518,-0.00508305402786363,0.000665358126822699,0.00175986191389733,0.000129445914615992,0.000281903634174313,0.000101213102997278,-0.00448275493959583,-0.000927115478525623,0.0129510002952631,-0.00475417819386783,-0.00269602262176629,-0.00590064011901042,-0.000252253098431369,0.00136057922569217,0.000892705698735436]';
            MusculotendonLength = equationRRN9(coeffs,Q);
        end
    elseif strcmp(axis,'Negative GH elevation angle')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[-0.0388399363511696,0.0338504307230442,-0.0607318895623673,0.0322475526630893,0.0130138885051996,0.105130101498531,0.00949746568891290,-0.00610727800707317,-0.0522052427618135,-0.0118266494055139,-0.0344633997021358,0.0132462289362708,-0.0458415612172455,-0.0108913828568552,0.00296103725325690,0.000144284714038986,-0.00486578014929781,-0.000920907630184879,0.00116398612094159,0.0172993733041293,0.0150778220387315,-0.00297395810144027,0.0243575254994492,0.0298737659723071,-0.00187639655821524,0.0156842646915072,-0.00654276217089865,-0.0500786511363267,-0.000279351105526280,-0.0379468552496394,0.00120550857964819,-0.00183228101595893,-0.0108916145937360,-0.0135770257324086,-0.000202574264564247,-0.00360471859126476,-0.0234517147788438,0.000879379026125870,0.0273318316868037,0.0138716969110116,-0.000228593651060090,-7.12015096622576e-05,0.000336884609156127,0.00497580777451867,0.000772923396739161,0.00569347522090911,0.0101853810352669,0.00765023993362884,-0.000745317827158729,-0.00458558821258947,-0.00493468427967827,0.00120358439540489,0.0105773657079659,0.000581885958865392]';
            MusculotendonLength = equationRRN9(coeffs,Q);
        end
    elseif strcmp(axis,'GH axial rotation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[-0.00165842978510986,0.0301698797203828,-0.0261425346747378,-0.0191450424782205,0.00306772905467900,0.000290765438260992,0.00553768285788809,0.0137991305739798,0.0163280582034645,0.00113334788616434,-0.00163623516855862,-0.00914898470049536,0.0101481509720950,-0.000987370999641383,-0.0235759991677809,-0.00169818164024869,0.000972869689296082,0.00187774470684221,-0.00959231999038291,9.87045447910805e-05,-0.00112051827575232,-0.000262676775854669,-0.000393349086009011,0.00225342523631357,-0.000585811697047738,0.00165296042472246,0.0114608456711549,0.00367814759502907,0.00524369433071781,-0.00402695150096172]';
            MusculotendonLength = equationRRN13(coeffs,Q);
        end
    end
end

%% Upper Latissimus Dorsi
if strcmp(mus_name,'Lat_1')
    if strcmp(axis,'GH plane of elevation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[5.26821942134625e-05,-0.000319132263694915,-0.0349272107026794,0.000166028515178011,-0.000190606652334730,0.00293886746119710,-0.000749573438807460,2.43248492386823e-06,0.00805870039865975,0.000371125261809222,0.00937439677466584,0.00131258360308801,0.00387058801183709,-0.00379628522277015,0.0166314946208137,-0.000135134854638124,0.0213950140260064,-0.00886081831633767,0.000489354810139395,-0.00333432670518155,-0.00243200310688829,-0.00152067254413083,-0.0186323238463139,0.00420730351386699,-0.00191749975352286,0.00222384878326970,-0.000549879189718113,-0.0137188445729762,0.00266426102990731,0.00683307018548652,0.000931976983454328,-0.000768304974366151,0.00284014252570221,-0.000623564482641763,0.000793835849676910,-0.000260963630024623,-0.00865273749775887,0.000775287606034331,0.00420470514012517,-0.00180766478510750,-0.00143669421397917,-0.00122253883934047,0.000220528618673268,-0.00100186976966043,2.18133186746389e-05,0.0105075963510785,-0.00129291148145960,-0.00554598877086207,0.000819842592473881,-0.00367456279634448,0.000397451707996890,0.00167625341569046,0.00502464469117285,0.000165348865542056]';
            MusculotendonLength = equationRRN9(coeffs,Q);
        end
    elseif strcmp(axis,'Negative GH elevation angle')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[0.00198396392622570,-0.0342963789738957,-0.0333967326446138,0.000641131500794717,0.00365065999363295,0.00636195545055193,0.000475709139215354,0.00472566923362214,0.00181018460708578,-0.000305950937965221,0.00355596550482357,0.000994968453756376,-0.00325658090402768,-0.00374108288938678,0.0198189990569394,-0.000615045741689094,0.0258681600614641,0.0127056988520184,-0.00258685075979747,0.00731198554393004,-0.00415594048644105,0.00172861224902495,0.00195080705388677,-0.0128924736536748,0.00337100372588402,-0.00609905098587449,0.00410625910979087,-0.0257910361116290,-0.000567336476695121,-0.0135945280976790,-0.00132604525728322,-0.000518289236319579,-0.00684140708998177,0.00317345552457716,-0.000459236060661997,0.00167228374765677,-0.00335409642805436,0.000558141339442030,0.00598120693485177,0.00571950899057349,0.000868152236429795,0.00328583275521913,0.000100104933356960,0.000257086160074417,-0.000212368571199923,-0.000891270218830136,-0.00692296547072557,0.00842579722666770,0.00186976868684565,0.000316387700319078,-0.00349702689190623,-0.00211899902180546,0.00325993953459739,-0.00122052064997469]';
            MusculotendonLength = equationRRN9(coeffs,Q);
        end
    elseif strcmp(axis,'GH axial rotation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[0.0109637547599419,0.000392912272165260,0.000550568134039330,-0.000187803354506713,0.000149888396861094,3.23813426843551e-05,0.00125373084262652,-3.38089722483904e-05,0.000717400244560897,-9.23680441930234e-05,0.00244621095533982,-0.00159983525169390,-0.000637136021670157,0.00125749453697061,-0.000672046745670013,0.000475267798874229,-0.00520105642518739,0.00716695534529316,-0.00186521637661913,0.00483728295435451,4.13885947409401e-05,0.00133547407329340,0.000972440285792796,-0.00805701663501837,0.00462439166091388,-0.00714597257405296,0.00119207934720589,-0.00271938717693191,-0.00293701724726679,-0.0104415593481616,-0.000264531370443416,0.000479032100444943,0.000403735791965288,0.00267789850834785,-0.00185666602737804,0.00195492168548408,0.00330732640191178,-0.00131549652312530,0.00179474457907753,0.00342919331050279,0.00164440438686829,0.00356647213288434,-0.000103740540141503,-0.000564002722898070,-0.000562341949776773,-0.00376407028925182,0.000724189215469203,0.00917885469157873,-0.00110363388581915,-0.000240092701153098,-0.00209826846806366,-0.00265412663156857,-0.00133778890343118,0.000344057837140329]';
            MusculotendonLength = equationRRN9(coeffs,Q);
        end
    end
end


%% Middle Latissimus Dorsi
if strcmp(mus_name,'Lat_2')
    if strcmp(axis,'GH plane of elevation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[3.77016826223026e-05,-0.000332575018627275,-0.0413186044676983,0.000227705689922973,-0.000132642800391055,0.00554564907711550,-0.000855611681663179,-3.73801096271011e-05,0.0115442267501954,0.000405335717480259,0.00878393149200697,0.00146794190283181,0.00525962944852619,-0.00475840949133041,0.0191584403359295,-0.000202144820427791,0.0269669367687148,-0.0110085100944198,3.85336048184495e-07,-0.00301818177276512,-0.00326752543022056,-0.00163027720186599,-0.0324515896332084,0.00595293319117717,-0.00161072790210634,0.00196276892957744,-0.00127735135110739,-0.0165916076020618,0.00286442327669220,0.00858573586575654,0.000773286943922938,-0.000884695557145338,0.00819782520364296,-0.000814658634668005,0.000834498907412254,-0.000225519138956979,-0.00863676770590664,0.00139186324299653,0.00604078094390536,-0.00289138744476552,-0.00149624002380266,-0.00134116111584431,0.000291080378979080,-0.00221211869718250,2.54582768256856e-05,0.0133359959536454,-0.00170249406819998,-0.00810641635988042,0.00160737223891823,-0.00608293598467273,0.00234750434233718,0.00203905766717527,0.00601840930474197,-0.000348443842777842]';
            MusculotendonLength = equationRRN9(coeffs,Q);
        end
    elseif strcmp(axis,'Negative GH elevation angle')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[0.00185157790939279,-0.0407575704437524,-0.0416323624544077,0.000292202457006311,0.00322618081239423,0.000318042270104870,0.000464747585209645,0.00575813310332270,0.00736070441180168,8.71440635025620e-06,0.00874684966663924,0.00179136914694027,-0.00142366917257691,-0.00378505579989997,0.0238063294191704,-0.000961116961864621,0.0408758347791091,0.0136189644656589,-0.00201336022137664,0.00652136220726493,-0.00731550274940847,0.00190930887469320,-0.0101958588539750,-0.0168029298606333,0.00332161577324553,-0.00646170036255566,0.00653624862435243,-0.0433188660825133,-0.000954061977347182,-0.0134290890328450,-0.000948851199037768,-0.000350032364983239,-0.00507357382121259,0.00499353897927396,-0.000517898240212048,0.00181283380883996,0.00276090778369461,0.000358722965891511,0.0155176733973038,0.00594793308570005,0.00114130535805387,0.00341292787920174,4.52275307290651e-07,-0.000648854257604266,-0.000305676908779430,-0.00220428997966161,-0.00829295902882445,0.0107810321073645,0.000960344798148493,0.00108877103002555,-0.00527282253309974,-0.00252729007971156,-4.72367526419409e-05,-0.00107566026455610]';
            MusculotendonLength = equationRRN9(coeffs,Q);
        end
    elseif strcmp(axis,'GH axial rotation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[0.00997995259700167,0.000438563715926495,0.000374200257338954,-0.000658101565930556,0.000181020507836007,0.000677724978702498,0.000495113161199440,-3.43009887435136e-05,0.000621437455150372,0.000801677044749485,0.00346943283153033,-0.00180843197785874,0.000264618001541566,0.00236485275748269,-0.00148495765160617,0.000519972158292351,-0.00581047217097613,0.00602821863205365,-0.00108385604271542,0.00447789087908069,0.000211546258298102,0.00144390290889228,0.00110125823579783,-0.00834776716730473,0.00374443227680954,-0.00754073386880360,0.00164006676455768,-0.00159888360471166,-0.00316655072647507,-0.00983619353592839,-0.000272014903202849,0.000574376785976143,0.000662635393802358,0.00308375251686406,-0.00163260548300952,0.00202418842046203,0.00376113928151796,-0.00195298858299925,0.00107253221514981,0.00330345604982813,0.00170824106144023,0.00356106260717491,-0.000117922568386321,-0.000666828747503801,-0.000610376501493410,-0.00666326772870248,0.00133924373889464,0.0100340282829304,-0.00172805450924938,0.00187956343064029,-0.00285830181906944,-0.00290401773009067,-0.00184376688987415,0.000848969533741338]';
            MusculotendonLength = equationRRN9(coeffs,Q);
        end
    end
end


%% Lower Latissimus Dorsi
if strcmp(mus_name,'Lat_3')
    if strcmp(axis,'GH plane of elevation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[8.69187376129033e-05,0.000408152998953464,-0.0364388438087557,5.64243501372194e-05,-0.000137986652399374,0.0144343137501205,-0.000993191162180251,-0.000575163456843935,0.00267481631388737,0.000723578445587207,0.00713159712975873,0.00108284683959545,0.00627202139176876,-0.00582063484204248,0.0159048187580626,0.000656065500389249,0.0153586430328634,-0.0163228058885343,-0.00321409807806730,0.000271883863825561,-0.00262525489282026,-0.00108181651543633,-0.0211691334738318,0.00995429822392965,0.000820353959359833,0.00203155232563834,-0.00138387725916505,-0.0157323496938105,0.00155996756589955,0.00731929148877684,0.000220906683036353,-0.000948698442741080,0.00528961677304127,-0.00132767170552915,0.000612854086538616,-0.000299479891197594,-0.00584707106693379,0.00306241982371080,0.00642106566887424,-0.00321735816656879,-0.000905849337085580,-0.00126033682792535,0.000380923411559676,-0.00114716740094691,-6.68264765749212e-05,0.0171103853923027,-0.00341205658448727,-0.0121587613209919,0.00226803426064533,-0.00892809764343699,0.00588953613405538,0.00223533707766905,0.00433148123211335,-0.00172383623251456]';
            MusculotendonLength = equationRRN9(coeffs,Q);
        end
    elseif strcmp(axis,'Negative GH elevation angle')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[-0.000861922501233052,-0.0347716476571854,-0.0668582750420052,0.00177822387369581,0.00359969163001350,0.0337182422711132,0.00738890345030002,0.00453786490322252,-0.00790567166161402,-0.00432860984976174,0.0202074382352701,0.00106212063067194,0.0266119494654316,-0.00477777556528580,0.0113866221967039,-0.00288724768992331,0.0235365956768085,-0.0501803434871824,0.000873735127435793,-0.0225969106543468,-0.00674898661990223,0.00283313989542862,-0.0145964811744601,0.0291978049664034,0.00398559579623480,0.00462862991404520,0.00545542604191076,-0.0281111531162958,-0.00306805213255665,0.0222269726559243,-0.000772827075808937,0.000221263343050995,0.000762020174069904,-0.00542832432025819,-0.000945938940025185,0.000487066663782219,0.00541717550869391,-0.00140697777613446,0.0115314289471068,-0.00727805044159584,0.00191982050092193,-0.00215699932795804,-0.000121198065005625,0.000620484104566553,4.95112663223082e-05,0.00106436023991340,-0.00573857416367731,0.00504017886842382,3.01957492892916e-06,-0.000568522189671609,-0.000184809979961362,-0.00334287432894990,-0.00213152938240197,-0.000194627756481131]';
            MusculotendonLength = equationRRN9(coeffs,Q);
        end
    elseif strcmp(axis,'GH axial rotation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[0.00695403539378460,-0.000162434328872130,0.00420255829353152,-0.000476152796971001,0.000300484290499855,0.00691721285218176,0.00513595030768677,0.000523450276238162,-0.00749338401751368,-0.00335401352708199,0.00732835233807364,-0.00259538825821150,0.0114166526653680,0.00556242379316053,-0.00530936648228376,-0.000846498892588070,-0.0188485195889352,-0.0177203236365851,0.00416533460322880,-0.0138873941753996,0.000192844072014964,0.000982302923616929,0.0127023531128729,0.0119583211527829,-6.05681933023858e-06,0.00121322490959234,0.00115475641203624,0.00588939220508192,-0.00144908958710524,0.00786781166150630,-0.000249156330668700,0.000713570622547995,-0.00238071037385936,-0.00321195406158185,-0.00123259697609213,0.000384764069993924,0.00499046098346828,-0.00404310531999736,-0.00314414968471609,-0.00225544291381063,0.000959329255331498,-2.27651674417504e-05,-0.000233328281186796,0.00134760467271788,7.28724658542342e-05,-0.0148457157674510,0.00393922302119353,0.0126579136088785,-0.00247421838638939,0.00790197936376184,-0.00587689377980246,-0.00280204489515359,-0.00271634860290708,0.00250271765850454]';
            MusculotendonLength = equationRRN9(coeffs,Q);
        end
    end
end


%% Teres Major
if strcmp(mus_name,'TMAJ')
    if strcmp(axis,'GH plane of elevation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[2.93375433354689e-05,-0.000191865066706041,-0.0463855622361676,4.17477106683081e-05,-7.37243254691703e-05,0.00973090356289654,-0.000546744732700919,0.000110559269074319,0.0106880353989038,0.000403712443539519,0.0292635156492053,0.00111297376460561,0.00228749628264625,-0.00238501214765321,0.0212628932568582,0.000176925287148972,0.0165153345967188,-0.0102619706677768,-0.000993582736212221,-0.00312455780175880,-0.00628285462077994,-0.00140959628841551,-0.0332858577177520,0.00777619996519506,0.000158266736234017,0.00275490833615197,-0.000605220658898988,-0.0254287755572114,0.00121857831752597,0.00736524574354203,0.00116252351250889,-0.000581135533229311,0.00918562177422587,-0.00176177491852990,0.000106005438139809,-0.000520517876547186,-0.00176793338723143,0.00142796238672430,0.0103170270601151,-0.00260559264838314,-0.000647825281484240,-0.00124656394327921,8.42229904237998e-05,-0.00204736931913410,-3.79228105851421e-05,0.0101176539265440,-0.00108693821026473,-0.00555920621703688,0.000433031922709932,-0.00429898109917580,0.000621000142037528,0.00180974147353676,0.00231900834874150,-0.000368443435279420]';
            MusculotendonLength = equationRRN9(coeffs,Q);
        end
    elseif strcmp(axis,'Negative GH elevation angle')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[-0.00652596631095819,-0.0460418638298306,-0.0168288879145568,0.000189356945940808,0.0128960651678352,-0.00411142143280324,0.00322642079447091,0.00676640047591435,0.00247949719728421,-0.00298817569298783,0.0188652050656333,-0.00132977233560749,0.00285544620681347,-0.000657106780750152,0.0164341221520438,0.000442440311804777,0.0306431108560279,0.000371982590836169,-0.00125106895432431,-0.00580782017641841,-0.0161708525129818,0.00183382008047821,0.000975375552218426,-0.00590471920574255,0.00306416957319908,0.00244509503844200,0.00362330820273376,-0.0471850070197798,-0.00129685591349248,-0.000360408171775555,-0.000842644147470352,-0.000685104543738805,-0.00939436806012491,0.00235503389568365,-0.000643489162139907,-0.000175799958291886,0.0126979829023613,-0.000418937867523563,0.0174107964028247,0.00187145844397217,0.00100183593702087,-9.77132177448726e-05,0.000121890597127495,0.000914755354539294,0.000272359136763591,-0.00349078525680360,-0.00502396612612641,0.00817950658928632,0.000924591465087954,0.00201229728350337,-0.00378595494512688,-0.00223108434636802,-0.00292217483265703,-0.000397082515656412]';
            MusculotendonLength = equationRRN9(coeffs,Q);
        end
    elseif strcmp(axis,'GH axial rotation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[0.00922398641782583,7.77287620295450e-05,0.00110176087477193,0.000412582438272814,2.41668673342671e-05,0.000103023727933258,0.00658857309586609,9.75474234934783e-05,8.71150976226477e-06,-0.00648443229963024,0.000979373103879565,-0.00207281569545386,0.00439692510961028,0.00225847784988902,-0.000722646840808479,1.02327868226905e-05,-0.00591207367474910,-0.00166726516452482,0.00249471139457201,-0.0107204098852141,2.52538012364377e-05,0.00110373904929383,0.00343183117234884,-0.00324423550468764,-0.000145383667147782,0.00486378349751352,0.00108320769303230,0.000944261785851822,-0.000993176711421793,0.00206425811660133,-0.000441773921060321,0.000444614714390243,-0.000424194673689462,0.00174906391340228,-0.000473628963884691,-0.000745277342627192,0.00296653462826031,-0.00215487374844262,-0.000808206897585641,0.000556336602262997,0.000470497764391028,-0.000378083193164921,-7.48504535296826e-05,-0.000283818472596597,0.000632732023754739,-0.00774046131780937,0.00154784459675834,0.00887938568172524,-0.000902251807918464,0.00302156301952830,-0.00259850116579848,-0.00272124094162900,-0.00123962087526255,0.00105558705069495]';
            MusculotendonLength = equationRRN9(coeffs,Q);
        end
    end
end


%% Infraspinatus
if strcmp(mus_name,'Infraspinatus')
    if strcmp(axis,'GH plane of elevation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[1.16832694582753e-05,0.00365968404499210,0.000495375738419984,-1.47393928584527e-05,0.0122094247555336,-0.000111954827449185,2.19511479813592e-05,-0.00349615019140618,-0.00121306177026785,-5.78160968751522e-05,-0.00858473297269883,0.000594321411233762,-3.67564201103720e-05,0.00574343590301220,-0.00208794655400282,-0.00452881586869953,0.000181122570133783,0.000373581500971701,-1.77893769842121e-07,0.000637919476695467,0.0519195959274454,0.00302937405397696,0.00905856154532471,-0.000356766610451580,-0.00101971128850581,-0.000507968232421009,-0.0207874945968011,0.00392924103187796,0.000875685597502284,-0.00133836810563066,-0.249445027512266,-0.00282364562046349,-0.000768294548641511,-0.00311400249778755,0.00572855325424595,-0.00507236655920488,0.00974483889906396,-0.00278106359013377,-0.00877067769960885,0.00177693392038287,0.000314942229963276,-0.000223508410135070,-0.000164666782290362,0.000594066184501028,2.76101302711362e-06,0.00843498164845087,0.0151745974863797,-0.00172371877114494,-6.99746450008128e-05,0.0137000681343306,0.00396200307890650, -0.00219375171795418,-0.0135156837076856,-0.00530329755514884,0.00534713565368339,-0.0122960909961342,-0.00402043189423244,0.573402023518668,0.0261231067267328,-0.00217911913938786,-0.00153774463476110,-0.00723768840350234,0.00627505346602343,-0.722563102528905,0.00183096409278105,0.469790248587843,0.000875605586530631,-0.123238376940170,2.97845982600792e-05,-0.0591249613674085,0.00287913701849372,0.0548186326730025,0.000654101588813744,-0.0179412889048426,-0.000824197447887410,0.00289652425838629,-0.00203681304182816,-0.00107796743617128,-0.00344359120955552,-0.00767735471677052,0.0146792657618245,-0.00384559379273285,-0.0125099084176676,-0.0104423825431163,-0.000932463398463096,0.00926102187722205,0.00866050864459336,0.00771891541283698]';
           MusculotendonLength = equationRRN10(coeffs,Q);
        end
    elseif strcmp(axis,'Negative GH elevation angle')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[0.00366098634340234,-0.00578424540465382,0.00411644729938133,-0.00115644388035280,0.000610436765514078,-0.00141876295919358,0.00222444427220638,0.00210888224473202,-0.000691720903346591,-0.00137660983363628,0.0204227897107863,0.00897935555216205,-0.000695021484428681,0.00135663166067134,0.00448039044117038,-0.0249592181696897,-0.0110051311501732,0.00133794298243323,-0.0122368437227569,0.000945357279101680,-0.0582318843790463,0.108647843616796,-0.00984133631921241,0.00155084130757084,0.00693736968991296,-0.00210961377165268,0.0100858277698749,0.0163225287927548,-0.00565476384121033,-0.0240092124896581,0.216346230182697,-0.409522376684636,0.00276721292227445,0.00254264918389684,-0.00718472595443624,0.00707013634395262,-0.00517714772353577,-0.00399472557400791,0.00498031113862817,-0.000478236742200314,-0.00544335535172302,0.00253060840934307,-0.000197194544838016,9.96631994244472e-06,0.000211035207933316,0.00251877815357485,0.0114158236216778,-0.0270929382867445,-0.00153209140531852,0.00799493964666364,-0.0170981935472592,0.00361692158257020,-0.00703267687426672,0.0363122392952653,0.0300799197540775,-0.0101179612797638,-0.000360758165009413,-0.508021412944761,0.896719662653183,-0.00218750065090848,-0.00313770017168883,0.00816444027366917,-0.00757703961714398,0.661606231390936,-0.000226779282870640,-0.444831145873193,0.00230522949671066,0.120760325787925,0.00110088066556926,-1.09538360837194,-0.00265670610516782,0.697769249574932,0.00337351758769362,-0.180676613360959,0.00235760390541772,-0.00281495130115243,0.00276647588191442,-0.0135686153316321,-0.00967180860322188,0.0175582750642174,-0.0526302513052163,0.0155858634588831,0.0568531278532265,0.0196927705822872,-0.00258788995307065,-0.0195468686996848,0.00459866800684450,-0.00917113842937877]';
            MusculotendonLength = equationRRN10(coeffs,Q);
        end
    elseif strcmp(axis,'GH axial rotation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[-0.0224359683788039,-0.000573371821251308,6.40644098032916e-05,0.00501529933468531,0.00189586588911560,0.000102258722359168,-0.00442475221916755,-0.00126327933469733,-4.46303972478683e-05,0.00348998474875967,-0.000565399251661681,0.00187750787458482,0.000953230002010457,0.00471124750099121,0.00311944154636103,-0.0119057882534131,-0.00213733506319372,-0.00100886159158386,-0.00277095599235626,-0.00303093145924331,-0.0447091394403029,0.0548905074406314,0.000343825482243279,5.16545872863942e-05,0.000961537558428563,-0.00572269288741327,0.0116852696313247,-0.000265662975382659,-0.000767577987431411,-0.0221305779350800,0.216504477039361,-0.188110346175201,0.000771776783839738,0.00214556985183487,0.0134021441637460,0.0260740657125828,-0.00710757730707208,0.000975813279277927,-0.000956454310173831,0.000923193660804941,-0.000364081963446969,0.00105976333332221,0.000381590999726743,-2.29910261017052e-05,-0.000600935159513307,-0.00155847039849875,0.0193736833369532,0.00379919666735792,0.00393296093170003,0.0229925287943723,-0.0229131083190037,0.000881426674133896,-0.0264677176757940,0.0216068996703312,-0.00648321155566368,-0.0163144775604727,-0.00996113918698125,-0.513067188109883,0.403765398810966,-0.00133629644578433,-0.00188206707545156,-0.0185718773559985,-0.0279324404184263,0.666779543068929,-0.00133487255163815,-0.452172163043643,0.00114407838525543,0.124502384785901,0.000896708794626113,-0.488251767191753,-0.00283869006033484,0.304314166718487,0.00224130231023166,-0.0766746510886097,0.00223038258172911,0.00699339175199898,0.00935787595596940,0.0157909784267009,0.0152908464830909,0.000863260935010119,-0.00928312127021685,-0.00227613060027833,0.0115787496291686,0.0398450188071602,0.0128147691930898,-0.0292905304649849,-0.0255152026724660,0.000816673679922230]';            
            MusculotendonLength = equationRRN10(coeffs,Q);
        end
    end
end



%% Teres Minor
if strcmp(mus_name,'TMIN')
    if strcmp(axis,'GH plane of elevation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[0.000254926662167739,-0.00963372074484049,0.000177045326439156,-0.000394390421048365,0.0117938919921214,-0.000534587502226340,-0.00207882303750947,-0.00124896331981300,6.67459767655241e-05,0.00283479779486030,0.0146693203694532,-0.0115049784782917,0.000286016555033881,0.000837350003749326,-0.00262822675157596,-0.00777646598927876,0.0108655914460758,0.00203035360886972,0.00339531627317838,-0.00375868974472593,-0.0299823721798318,0.0535151661402914,-0.000129737523834329,-0.00123075633719370,0.00994087715002664,0.00908441297751405,-0.0299748099738954,0.0348888386826311,0.000770216929634544,0.000624918862421992,0.0874855973192000,-0.254189755943498,-0.00428546327487798,-0.00353777239571145,-0.0161755698714790,-0.00748124781436891,0.0169720484090740,-0.0320744300680117,0.000696151388312856,0.000891783359719315,-0.0273574297154639,-0.000920892953279032,0.000301044366622174,-0.000235546133507572,-0.000681725686260616,-0.00171796277000063,0.000139934632586559,0.00920478096384179,-0.0106816149942352,0.0229172733373674,0.0115825758145746,0.00367308688967259,0.00253657688318507,-0.0171844246622651,-0.00672460752847251,-0.000569292340280023,0.00483196030656307,-0.0446357985357980,0.816814485683346,0.00722216185648850,-0.00209262535028021,0.00714625595279031,0.00192507899887812,-0.167971210308815,0.0132102260393784,0.247125204538131,-0.00729005361725130,-0.0966340631136729,-0.00974876622452409,-1.34983093527729,0.00295797825249487,1.07190004959236,0.00469286763809330,-0.326418743431987,0.00179168512028928]';
            MusculotendonLength = equationRRN11(coeffs,Q);
        end
    elseif strcmp(axis,'Negative GH elevation angle')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[-0.00717105750412385,-0.00855218390159243,-0.00761242416685737,0.00193190680845244,0.00667257402223082,0.00702836284242798,0.00398685558372434,-0.00355182263303160,0.00108542616926168,-0.00343459682962848,0.0199214662943758,0.00250242873981738,-0.0125411242107136,0.00353299783735430,-0.00187176375736320,0.0168945100165008,0.00434436576171835,0.00261527497016226,-0.0118684000308123,-0.00664686099532215,-0.0279464880217258,-0.182230179558632,-0.00865774457066355,0.00233190381058053,0.00696313940633131,0.0151931706229215,-0.0219880174856963,0.0224920604749635,-0.00249676829307284,0.0309938865641302,0.00828141808205590,0.541995245038694,-0.00362387140408973,-0.00272182005354272,0.00713922401364783,0.00915564046272674,0.0125586664147992,-0.0119320261748271,-0.00191504581142285,0.000955060388081026,-0.00360365110015938,0.000141023385910232,0.00108944906772093,0.000537427955779099,0.000650580895715860,0.0135268545484578,-0.0537981494772297,0.00873541301977455,-0.0150747834903317,-0.0467168387711586,0.0307439887461794,-0.00652447619164483,0.0660683857085811,-0.0266314840239998,-0.00217461164818377,0.0407997684685679,0.00739103525546271,0.388773052633727,-0.724078101032962,-0.00206349667628986,-0.00696309500338642,-0.0163136415098599,-0.0241496109977483,-1.04165885394683,0.00561279537142720,1.02261989004841,0.00353933737826904,-0.353606390780203,-0.000445832289850030,0.361713163866262,0.00212658333725307,0.0718687730595641,0.00870463698902739,-0.0886428518483838,0.00362181453583049,0.00667519780761372,0.00962355260810999,-0.0261519983072784,-0.0256750068139791,-0.00591149876319480,-0.00870476053239938,0.00861393895072329,0.00609969817611895,-0.0492088635179301,-0.00326493627224262,0.0490908645275292,0.0173691682946686,-0.0114030234361456]';           
            MusculotendonLength = equationRRN10(coeffs,Q);
        end
    elseif strcmp(axis,'GH axial rotation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[0.0163011834132406,0.00234497474558845,0.000245057541277188,-0.0102007542829638,0.00384973609159408,-0.000126712654702760,-0.00152988467650187,-0.00256324761399031,-0.000313827292001599,-0.00448121430906282,0.00535344115668803,0.00908814621714905,-0.00110362306946842,0.00756567085485764,-0.00554196549820740,0.00223043541336250,-0.000961678400107792,-0.00139595174049063,-0.00107615704926700,-0.000870596916011535,-6.50540215126754e-06,-0.00554082917198341,0.00253523820012612,-0.000561076899743607,-0.0175921998434282,0.0109778865702347,-0.00885092853518449,-0.00902352056314283,0.00254261425407508,0.0282077707551036,6.53525156384116e-05,0.00156428699780925,-0.000439751570213175,0.000718661160463029,-0.0156097884490688,-0.0136716214655184,0.00853060072539525,0.00460178933937454,-0.00282636258270833,0.00124961040204971,0.00383882408398225,-0.00127969963706311,-0.000526538555314617,0.000105864210960836,0.00117725164461340,0.00464257986262556,-0.0178467484229953,-0.000512263204461185,-0.00892913394067073,-0.0324101388964518,0.0118449998537029,-0.00824218472609883,0.0392623997157649,-0.0108783276319188,0.00277351917892785,0.0154255316150651,0.00345117582432745,-0.000257911528797394,0.000840592867733913,-0.000735186013821900,-0.000194161715874763,0.0281424699909337,0.00363556444969240,6.58819201071469e-05,0.000274435307855446,-6.38062258129235e-05,0.000116472037719329,1.37268675513835e-05,-1.04663499802807e-05,-0.000150327020299823,-0.000279078585351555,0.000241934875124028,4.74839309084467e-05,-0.000128525695661907,4.58037847351057e-05,-0.00868316728363220,0.000681481569475783,-0.0255728952126302,-0.00460993456360227,0.0188590811932395,-0.0129305016486686,0.00498503232984815,0.0125494317644402,-0.0111964023693505,0.00148510205966567,-0.00208385478110564,0.00193415421702335,-0.00336781587889225]';                                       
            MusculotendonLength = equationRRN10(coeffs,Q);
        end
    end
end



%% Supraspinatus
if strcmp(mus_name,'Supraspinatus')
    if strcmp(axis,'GH plane of elevation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[-3.45839403558427e-05,-0.00613076938600820,3.62603936197501e-05,8.61340808739895e-05,9.12543689074705e-05,0.000123205783397406,0.000253729500189494,0.000404555748089998,6.55353156333442e-05,-0.000488750391035587,-0.0154678113285825,0.00610393974157252,-8.56540591851656e-05,-0.00546366969955879,0.0177363699618403,-0.00781469768888790,-0.000668919729650305,0.000184307387402332,-0.000632596742134440,0.000243400632677386,-0.00954051237229438,0.00343039434860978,0.000930428770227508,0.000552968714381482,0.00725164585866459,-0.00435290938938633,0.00141807862446418,0.00484496470573073,-0.000386890534181620,-0.00789376661408023,0.00319228506375219,-0.00161448782591422,0.00284014379681877,-0.000858578042644842,0.00183140138403425,0.00715677093982493,-0.00528518985511019,-0.00161136027228663,-0.00427669657312776,-0.000973033147431012,-0.000840214976866872,0.000352319352740168,0.000380847450001799,-3.49138043645869e-05,0.000139592312152277,-0.00260803901893182,0.0282831097204020,-0.00823503445954353,0.00444522154257066,0.0252139137618701,-0.00492240095457110,0.00819860169701219,-0.0341672362498362,0.00328208159185201,0.00680498439826445,-0.0198716961575826,-0.000293654635655318,0.00316894524515180,0.000620789490723958,0.00188398418084077,0.000275454888589603,-0.00652052377776309,-0.00318401042108186,-0.00174360486224085,-0.000389983860685493,-0.000190734980087703,-0.000374168595426188,0.000247910373875873,-2.19911514295443e-05,-0.000548670982055556,0.000525043168966076,-9.63073601636249e-05,-8.22069783787580e-05,0.000114071647530456,-8.43226954534449e-05,0.00201272457258026,0.000218283416454768,0.0145815946668774,-0.00841580477396651,-0.0105077939592946,-0.0101973216501581,0.00659688188398967,-0.00123943457394033,0.00351011799372300,-0.00278075000267436,0.00152089963621892,0.00814186556044541,-0.000463217244045123]';
            MusculotendonLength = equationRRN10(coeffs,Q);
        end
    elseif strcmp(axis,'Negative GH elevation angle')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[0.0119200738852915,-0.00363545101981512,-0.00685546496939049,0.00398076549006606,0.000749155336704346,-0.00695502837813526,0.00335271418575269,-0.00170108812192945,0.00149968530471807,-0.00472292257121930,0.00487995485055002,0.00204110047156601,0.00560946194805369,-0.0100721442394834,-0.00923692230144554,0.000865554703067316,0.0126241485273579,-0.00398354640621979,0.0108569861604908,0.00207942919044158,0.00781831247740128,-0.00479484422040453,-0.00733806966458405,0.00120414689828228,-0.00813441359675788,0.00418561612992065,-0.00116146465106408,-0.0173545892369973,0.000182015134116475,0.00637084108527619,0.00193277847858253,-0.00457323473174667,-0.00391631566540976,-0.000745621564466562,-0.00290300572211151,0.00426419387550330,-0.000214758678789637,0.00560680329657564,0.00911907984897079,-0.00236271077512880,0.00928680336951358,0.00136889194930321,-0.000365992623257608,-0.000649643893446043,0.000199819017526216,-0.00848842564158204,-0.0111686955503112,0.00834193410805472,-0.00114899851680009,-0.00191163542777301,0.0101337695158059,0.00486366201155287,0.0123580448548264,-0.0186699425253079,-0.00389433132767219,0.00184800887632975,0.00576818536419736,-0.00354855056325936,0.00632226882252789,0.00198844860008277,-0.000857307262759444,0.00254664653711702,-0.00851409998917727,0.00568612883578811,0.000874526000180393,-0.00388910590119662,-0.000230549708292279,0.000984499497949237,-0.000123197817515157,-0.00698191462717701,0.000267472163491655,0.00411437261918984,0.000234271549069091,-0.000820165578916107,-1.90886572972843e-05,-0.000237580125513748,0.00281850710050899,0.00780561516387257,0.00547800912617115,-0.000893975057421694,0.00784379104520092,-3.32997346418721e-05,-0.00835713094590197,8.53952748005341e-05,-0.00357845491984856,-0.00583239073428422,-0.00229082475122002,0.000603550704180816]';
            MusculotendonLength = equationRRN10(coeffs,Q);
        end
    elseif strcmp(axis,'GH axial rotation')
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3)
            Q  = q([ind1,ind2,ind3],:)';
            coeffs=[-0.0177538950751465,0.00306942938145027,-0.000275770651145861,0.00829974205181631,-0.00133162300560220,-0.000170973637476286,0.00780727819053990,-0.000407142781132276,-0.000658014660416736,-0.0101994805023873,-0.00918947713378387,0.00798859528807074,-0.00233149558732585,0.00293641384649365,-0.0125429645077435,-0.00784337598045369,0.00330173658610692,-0.00141215856370939,-0.0153165973316053,0.00809084060091956,0.0550722004996211,-0.0208618446298136,0.00379118099892116,0.000678225176955637,0.00906137926640814,0.00276913013535967,0.000988595295186861,0.0147330939613896,0.00283694846133459,0.0412322431553468,-0.192762824980052,0.0918955900537452,5.75064018042477e-05,0.00186978669444545,-0.0114240340817298,-0.0228577257461640,-0.00189519933094426,-0.00616356116459173,0.000855256464073362,-0.000327192998956438,-0.00267957501854802,-0.00175281455080638,0.000224360864673906,0.000654209093272433,0.00207232498041876,0.00124294230425481,-0.0244056617863685,0.00165550762557146,-0.0108746088178643,-0.0216716143685806,0.0200693483243694,-0.0141725749097422,0.0330688952263064,-0.0259043156405793,-0.00986095531521898,0.0154454483731773,0.00981421977998619,0.409087747496409,-0.206203055636085,-0.00464469669865584,0.000672252647782760,0.0148039036777850,0.0195194522414031,-0.467840629161433,-0.00187962289542798,0.273965843716282,0.00291699422967864,-0.0651927932766276,0.00223895409760411,0.284499736711012,-0.00101552751470511,-0.206137701984522,-0.00123795202142553,0.0594881853705515,-0.000410992236698001,-0.00575165494893988,-0.00489748376164717,-0.00375352727774583,-0.00328086596272582,-0.00644162098677069,-0.000499604542916837,0.000161018848923520,-0.00763584928755725,-0.0231142041840453,-0.00672680230858685,0.0116326650636158,0.0134518533916595,0.00443683809590307]';
            MusculotendonLength = equationRRN10(coeffs,Q);
        end
    end
end

end


end