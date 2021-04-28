function MomentsArm=RankinNeptune(mus_name,axis,joints_names,q)

% All coeffs non explained come from
%Rankin, J. W., & Neptune, R. R. (2012).
%Musculotendon lengths and moment arms for a
%three-dimensional upper-extremity model.
%Journal of Biomechanics, 45(9), 1739–1744.
%https://doi.org/10.1016/j.jbiomech.2012.03.010

mus_name = mus_name{:};
mus_name = mus_name(2:end);
MomentsArm = [];

%% TricepsMedial
if strcmp(mus_name,'TricepsMed')
    if strcmp(axis,'Ulna')
        [~,ind] = intersect(joints_names, 'Ulna');
        if length(ind)==1
            Q  = q(ind,:)';
            coeffs=[-2.02999e-2  -2.15606e-2  3.56484e-2  -1.78502e-2  2.6245e-3]';
            MomentsArm = equationRRN1(coeffs,Q);
        end
    end
end


%% TricepsLateral
if strcmp(mus_name,'TricepsLat')
    if strcmp(axis,'Ulna')
        [~,ind] = intersect(joints_names, 'Ulna');
        if length(ind)==1
            Q  = q(ind,:)';
            coeffs=[-2.02999e-2  -2.15606e-2  3.56484e-2  -1.78502e-2  2.6245e-3]';
            MomentsArm = equationRRN1(coeffs,Q);
        end
    end
end


%% Anconeus
if strcmp(mus_name,'Anconeus')
    if strcmp(axis,'Ulna')
        [~,ind] = intersect(joints_names, 'Ulna');
        if length(ind)==1
            Q  = q(ind,:)';
            coeffs=[-8.19456E-03  -1.27179E-02   8.20591E-03   2.90914E-03  -2.29252E-03 ]';
            MomentsArm = equationRRN1(coeffs,Q);
        end
    end
end



%% Brachialis
if strcmp(mus_name,'Brachialis')
    if strcmp(axis,'Ulna')
        [~,ind] = intersect(joints_names, 'Ulna');
        if length(ind)==1
            Q  = q(ind,:)';
            coeffs=[9.84873e-3  1.01630e-2  -2.39557e-2  2.90329e-2  -9.24344e-3]';
            MomentsArm = equationRRN1(coeffs,Q);
        end
    end
end


%% Brachioradialis
if strcmp(mus_name,'Brachioradialis')
    if strcmp(axis,'Radius_J1')
        [~,ind] = intersect(joints_names,{'Radius_J1','Radius'},'stable');
        if length(ind)==2
            Q  = q(ind,:)';
            coeffs=[1.18003e-2  2.09993e-2  3.7126e-2  -1.47644e-2  -5.8285e-4  -3.57599e-3  -7.25432e-4  1.40991e-2  -1.25532e-2  -1.47822e-3  3.61034e-3 -2.57318e-4]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Radius')
        [~,ind] = intersect(joints_names,{'Radius_J1','Radius'},'stable');
        if length(ind)==2
            Q  = q(ind,:)';
            coeffs=[-7.81478e-4  6.99447e-4  3.60463e-3  -1.06015e-3  -3.9357e-4  1.44296e-3  -8.94732e-4  -4.05248e-3  -1.00184e-2  -2.83974e-3  3.51570e-3  2.85087e-3]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    end
end


%% PronatorTeres
if strcmp(mus_name,'PronatorTeres')
    if strcmp(axis,'Radius_J1')
        [~,ind] = intersect(joints_names,{'Radius_J1','Radius'},'stable');
        if length(ind)==2
            Q  = q(ind,:)';
            coeffs=[6.55640E-03  1.69232E-02  -3.28333E-02  3.21198E-02   -5.90348E-17   9.60061E-16   3.77736E-16  -1.27742E-02  1.63665E-03   -1.57600E-15  -4.90059E-16      ]';
            MomentsArm = equationRRN3(coeffs,Q);
        end
    elseif strcmp(axis,'Radius')
        [~,ind] = intersect(joints_names,{'Radius_J1','Radius'},'stable');
        if length(ind)==2
            Q  = q(ind,:)';
            coeffs=[9.47956E-03  -9.28023E-15  3.97126E-14  -6.20788E-14   -2.01126E-03  -2.82774E-03  2.85982E-03  4.00418E-14  -9.11077E-15   1.70446E-03  -2.34187E-03 ]';
            MomentsArm = equationRRN3(coeffs,Q);
        end
    end
end

%% PronatorQuadratus
if strcmp(mus_name,'PronatorQuadratus')
    if strcmp(axis,'Radius')
        [~,ind] = intersect(joints_names, 'Radius');
        if length(ind)==1
            Q  = q(ind,:)';
            coeffs=[7.30854e-3  2.28126e-3  -2.81928e-3  -1.02119e-3  1.74483e-5]';
            MomentsArm = equationRRN1(coeffs,Q);
        end
    end
end
%% SupinatorBrevis
if strcmp(mus_name,'SupinatorBrevis')
    if strcmp(axis,'Radius')
        [~,ind] = intersect(joints_names, 'Radius');
        if length(ind)==1
            Q  = q(ind,:)';
            coeffs=[-7.67985E-03  4.08098E-04 1.45346E-03  -1.70151E-04  -5.01312E-04]';
            MomentsArm = equationRRN1(coeffs,Q);
        end
    end
end

%% ExtensorCarpiRadialisBrevis
if strcmp(mus_name,'ExtensorCarpiRadialisBrevis')
    if strcmp(axis,'Radius_J1')
        [~,ind] = intersect(joints_names,{'Radius_J1','Radius'},'stable');
        if length(ind)==2
            Q  = q(ind,:)';
            coeffs=[5.64642E-03  -1.74387E-03  -3.71495E-03  1.01268E-03  -5.29727E-05  1.84085E-04  1.87014E-05   -3.87485E-04  5.11181E-05  2.50652E-04  4.03295E-05   2.61368E-05]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Radius')
        [~,ind] = intersect(joints_names,{'Radius_J1','Radius'},'stable');
        if length(ind)==2
            Q  = q(ind,:)';
            coeffs=[-1.55243E-03  -5.91013E-05  -2.19213E-04  5.07507E-05  -1.90131E-03   7.41471E-04  3.34035E-04  1.84492E-04  6.68436E-04  1.32696E-04  -1.58205E-04  -1.55084E-04 ]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Hand')
        [~,ind] = intersect(joints_names,{'Hand','Wrist_J1'},'stable');
        if length(ind)==2
            Q  = q(ind,:)';
            coeffs=[-1.34815E-02   3.02208E-02   5.78169E-03  -1.64320E-02  2.68623E-03  3.41629E-03  -2.45737E-03   8.20428E-04  -3.08372E-02  -8.27743E-03  3.13227E-02   6.21186E-03]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Wrist_J1')
        [~,ind] = intersect(joints_names,{'Hand','Wrist_J1'},'stable');
        if length(ind)==2
            Q  = q(ind,:)';
            coeffs=[-2.67570E-02  2.69223E-03   3.35291E-03  -1.18284E-02  9.57323E-03   3.02360E-03  -2.78438E-03  2.09357E-03  -1.37559E-02  -6.54620E-03   2.41453E-02     1.01279E-02 ]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    end
end



%% ExtensorCarpiRadialisLongus
if strcmp(mus_name,'ExtensorCarpiRadialisLongus')
    if strcmp(axis,'Radius_J1')
        [~,ind] = intersect(joints_names,{'Radius_J1','Radius'},'stable');
        if length(ind)==2
            Q  = q(ind,:)';
            coeffs=[6.784195E-03  4.25933E-03   1.08103E-02   -3.02892E-03  5.08279E-03  -3.08828E-04   -9.16923E-04   -4.83760E-03   2.49206E-03  -1.02552E-03   -4.91622E-04  4.50855E-04 ]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Radius')
        [~,ind] = intersect(joints_names,{'Radius_J1','Radius'},'stable');
        if length(ind)==2
            Q  = q(ind,:)';
            coeffs=[-2.36211E-03  2.93937E-03  -6.69053E-05  -1.39155E-04  -1.06309E-03  1.00099E-03  -5.83203E-04  -2.37355E-04  -2.73083E-03  -1.15824E-03   6.79267E-04   1.00675E-03 ]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Hand')
        [~,ind] = intersect(joints_names,{'Hand','Wrist_J1'},'stable');
        if length(ind)==2
            Q  = q(ind,:)';
            coeffs=[-2.14012E-02  3.26927E-02  -1.13902E-02  -1.82031E-03  1.35811E-02  1.72010E-03  -2.39317E-03  -1.89705E-02  -1.02368E-02   -1.48189E-03  1.29229E-02  8.20184E-03  ]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Wrist_J1')
        [~,ind] = intersect(joints_names,{'Hand','Wrist_J1'},'stable');
        if length(ind)==2
            Q  = q(ind,:)';
            coeffs=[-1.98904E-02 1.410779E-02   -5.64345E-03  -4.25499E-03  1.09667E-02   -4.96348E-03  -7.54046E-05  1.60476E-03   -5.13726E-03  -7.44317E-03   4.86065E-03   8.54788E-03 ]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    end
end


%% ExtensorCarpiUlnaris
if strcmp(mus_name,'ExtensorCarpiUlnaris')
    if strcmp(axis,'Radius_J1')
        [~,ind] = intersect(joints_names,{'Radius_J1','Radius'},'stable');
        if length(ind)==2
            Q  = q(ind,:)';
            coeffs=[-6.48E-03 -2.13E-03  4.01E-03   -7.28E-04    1.56E-05 ]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Radius')
        [~,ind] = intersect(joints_names,{'Radius_J1','Radius'},'stable');
        if length(ind)==2
            Q  = q(ind,:)';
            coeffs=[ -6.83927E-04  4.81841E-10  -1.44939E-09  6.78194E-10  -2.61266E-03  3.40180E-04   4.37423E-04  1.38498E-09  -4.84425E-09  1.21106E-09   2.26670E-09  2.79839E-09 ]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Hand')
        [~,ind] = intersect(joints_names,{'Hand','Wrist_J1'},'stable');
        if length(ind)==2
            Q  = q(ind,:)';
            coeffs=[2.54110E-02  -1.11073E-02  -2.08457E-02  1.15763E-02  -1.49666E-02  -1.18817E-02  1.27967E-02  -2.35572E-02   2.55822E-02  1.27644E-03  6.66190E-02   -8.41382E-03      ]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Wrist_J1')
        [~,ind] = intersect(joints_names,{'Hand','Wrist_J1'},'stable');
        if length(ind)==2
            Q  = q(ind,:)';
            coeffs=[-1.09221E-02   -1.73542E-02   -4.94780E-03  2.78397E-02  -7.07319E-03    1.96901E-02  9.79676E-03  -3.75544E-02   -9.52318E-03   2.45856E-02  -5.24763E-02  6.69292E-02    ]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    end
end



%% FlexorCarpiRadialis
if strcmp(mus_name,'FlexorCarpiRadialis')
    if strcmp(axis,'Radius_J1')
        [~,ind] = intersect(joints_names,{'Radius_J1','Radius'},'stable');
        if length(ind)==2
            Q  = q(ind,:)';
            coeffs=[7.67790E-03  4.48052E-03  2.16460E-03   -1.82752E-03   -2.32672E-03   -2.30373E-04   1.51697E-04   5.65668E-03  -5.31170E-03  4.61653E-05   1.79044E-03  -1.33508E-04  ]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Radius')
        [~,ind] = intersect(joints_names,{'Radius_J1','Radius'},'stable');
        if length(ind)==2
            Q  = q(ind,:)';
            coeffs=[2.67438E-03  -1.36880E-03  6.91513E-04  -6.98935E-05    -4.90337E-03   -1.23667E-03   7.01458E-04  1.72866E-04    -7.68966E-04   1.90012E-04   2.54791E-04  1.57488E-04          ]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Hand')
        [~,ind] = intersect(joints_names,{'Hand','Wrist_J1'},'stable');
        if length(ind)==2
            Q  = q(ind,:)';
            coeffs=[-8.03093E-03   -1.34897E-03   -3.33381E-03   4.95872E-03   2.86237E-03   7.19412E-03   8.91592E-03   -4.12701E-02  5.23716E-02   -2.44844E-02    -1.58656E-02    -2.30728E-02          ]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Wrist_J1')
        [~,ind] = intersect(joints_names,{'Hand','Wrist_J1'},'stable');
        if length(ind)==2
            Q  = q(ind,:)';
            coeffs=[3.05783E-02   4.97620E-03  -3.02582E-02  1.87421E-02   1.05117E-02  -1.52883E-02  -1.37820E-02  7.51537E-03  -3.89462E-02  1.89374E-02  2.99607E-02  2.18283E-02            ]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    end
end


%% FlexorCarpiUlnaris
if strcmp(mus_name,'FlexorCarpiUlnaris')
    if strcmp(axis,'Radius_J1')
        [~,ind] = intersect(joints_names,{'Radius_J1','Radius'},'stable');
        if length(ind)==2
            Q  = q(ind,:)';
            coeffs=[5.51173E-03  -4.01108E-03  1.40164E-02   -5.18068E-03   -2.01298E-04  2.70126E-04   4.21473E-04  -3.28234E-03  3.92531E-03  -3.40615E-04   -1.13142E-03   -2.69541E-04             ]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Radius')
        [~,ind] = intersect(joints_names,{'Radius_J1','Radius'},'stable');
        Q  = q(ind,:)';
        coeffs=[1.11146E-03   1.97726E-04   -1.27326E-03  5.20819E-04  -3.74902E-03  -9.92194E-04   4.27625E-04   5.64019E-04   -6.85108E-04  2.54066E-04   1.42679E-04   7.91794E-05   ]';
        MomentsArm = equationRRN4(coeffs,Q);
    elseif strcmp(axis,'Hand')
        [~,ind] = intersect(joints_names,{'Hand','Wrist_J1'},'stable');
        if length(ind)==2
            
            Q  = q(ind,:)';
            coeffs=[2.17266E-02  -1.74158E-02  -2.51289E-02  1.59383E-02  -4.81507E-03  -9.42592E-04  1.86899E-03   -1.88998E-02    1.01198E-02  -2.38388E-03   -7.70851E-03  1.77299E-03         ]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Wrist_J1')
        [~,ind] = intersect(joints_names,{'Hand','Wrist_J1'},'stable');
        if length(ind)==2
            
            Q  = q(ind,:)';
            coeffs=[2.97122E-02   -5.00567E-03    -6.41658E-03  1.50843E-04   1.16523E-02  -2.43971E-03  3.28030E-04  -4.07005E-03   5.00416E-03   4.94657E-03  -8.17776E-03   4.91559E-03       ]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    end
end





%% PalmarisLongus
if strcmp(mus_name,'PalmarisLongus')
    if strcmp(axis,'Radius_J1')
        [~,ind] = intersect(joints_names,{'Radius_J1','Radius'},'stable');
        if length(ind)==2
            
            Q  = q(ind,:)';
            coeffs=[3.75789E-03  1.11963E-02  1.07860E-04   -1.43591E-03  -2.23585E-03  3.23306E-04  6.49814E-06  1.27466E-03 4.03585E-04   -5.81201E-04  -1.49607E-04  5.43361E-05     ]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Radius')
        [~,ind] = intersect(joints_names,{'Radius_J1','Radius'},'stable');
        if length(ind)==2
            
            Q  = q(ind,:)';
            coeffs=[3.66899E-03  -2.53706E-03  1.13466E-03   -1.44441E-04   -5.65003E-03  -1.69339E-03  7.87399E-04   7.18247E-04  -1.89115E-03  5.10777E-04   6.23193E-04   2.34536E-04   ]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Hand')
        [~,ind] = intersect(joints_names,{'Hand','Wrist_J1'},'stable');
        if length(ind)==2
            
            Q  = q(ind,:)';
            coeffs=[-2.97675E-03  -2.71776E-02   8.61377E-03   7.16362E-03   -7.62851E-05  -8.28526E-03    -1.34914E-02  -5.24356E-02  6.23784E-02   1.60804E-02  -2.30912E-02    4.53652E-02 ]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    elseif strcmp(axis,'Wrist_J1')
        if length(ind)==2
            
            [~,ind] = intersect(joints_names,{'Hand','Wrist_J1'},'stable');
            Q  = q(ind,:)';
            coeffs=[4.79301E-02   -6.89603E-03  -9.91209E-03   1.46616E-02  2.24075E-02  -5.30622E-02   -8.62529E-02  -3.72153E-02   2.30734E-02  -4.21861E-04  1.17943E-02   5.25951E-02           ]';
            MomentsArm = equationRRN4(coeffs,Q);
        end
    end
end

end