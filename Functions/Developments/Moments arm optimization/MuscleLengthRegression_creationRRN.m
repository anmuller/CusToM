function MuscleLengthRegression=MuscleLengthRegression_creationRRN()

% All coeffs non explained come from 
%Rankin, J. W., & Neptune, R. R. (2012). 
%Musculotendon lengths and moment arms for a
%three-dimensional upper-extremity model. 
%Journal of Biomechanics, 45(9), 1739–1744.
%https://doi.org/10.1016/j.jbiomech.2012.03.010

k=0;

k=k+1;
%% TricepsMedial
MuscleLengthRegression(k).name='TricepsMed';
MuscleLengthRegression(k).regression(1).equation='RRN1';
MuscleLengthRegression(k).regression(1).joints={'Ulna'};
MuscleLengthRegression(k).regression(1).coeffs=[1.54222E-01  2.07285E-02  8.82432E-03   -8.64625E-03  2.25989E-03 ]';

k=k+1;
%% TricepsLateral
MuscleLengthRegression(k).name='TricepsLat';
MuscleLengthRegression(k).regression(1).equation='RRN1';
MuscleLengthRegression(k).regression(1).joints={'Ulna'};
MuscleLengthRegression(k).regression(1).coeffs=[1.66594E-01  2.07285E-02  8.82427E-03  -8.64619E-03   2.25988E-03 ]';

k=k+1;
%% Anconeus
MuscleLengthRegression(k).name='Anconeus';
MuscleLengthRegression(k).regression(1).equation='RRN1';
MuscleLengthRegression(k).regression(1).joints={'Ulna'};
MuscleLengthRegression(k).regression(1).coeffs=[2.15292E-02 7.73490E-03  8.29149E-03  -5.76335E-03   1.25435E-03   ]';


k=k+1;
%% Brachialis
MuscleLengthRegression(k).name='Brachialis';
MuscleLengthRegression(k).regression(1).equation='RRN1';
MuscleLengthRegression(k).regression(1).joints={'Radius_J1'};
MuscleLengthRegression(k).regression(1).coeffs=[1.46058E-01 -1.20401E-02  3.59539E-03  -5.01862E-03  9.60102E-04 ]';

k=k+1;
%% Brachioradialis
MuscleLengthRegression(k).name='Brachioradialis';
MuscleLengthRegression(k).regression(1).equation='RRN4';
MuscleLengthRegression(k).regression(1).joints={'Radius_J1','Radius'};
MuscleLengthRegression(k).regression(1).coeffs=[3.31738E-01  -5.43503E-03 -2.68598E-02 1.38252E-03  8.13288E-04   -2.80194E-04  -4.90632E-04  -8.77554E-04  -3.38091E-03  5.46894E-03  9.80002E-04  9.67606E-04     ]';


k=k+1;
%% PronatorTeres
MuscleLengthRegression(k).name='PronatorTeres';
MuscleLengthRegression(k).regression(1).equation='RRN2';
MuscleLengthRegression(k).regression(1).joints={'Radius_J1','Radius'};
MuscleLengthRegression(k).regression(1).coeffs=[1.58132E-01  -8.01366E-03  -1.67372E-03 -1.52039E-04  -9.44999E-03   6.50363E-04  6.14738E-04   ]';


k=k+1;
%% PronatorQuadrus
MuscleLengthRegression(k).name='PronatorQuadrus';
MuscleLengthRegression(k).regression(1).equation='RRN1';
MuscleLengthRegression(k).regression(1).joints={'Radius'};
MuscleLengthRegression(k).regression(1).coeffs=[3.11720E-02  -7.30837E-03  -1.13409E-03  9.37332E-04  2.42941E-04      ]';

k=k+1;
%% SupinatorBrevis
MuscleLengthRegression(k).name='SupinatorBrevis';
MuscleLengthRegression(k).regression(1).equation='RRN1';
MuscleLengthRegression(k).regression(1).joints={'Radius'};
MuscleLengthRegression(k).regression(1).coeffs=[2.42941E-04  7.65849E-03  -2.11783E-04  -4.12925E-04   4.86667E-05 ]';


k=k+1;
%% ExtensorCarpiRadialisBrevis
MuscleLengthRegression(k).name='ExtensorCarpiRadialisBrevis';
MuscleLengthRegression(k).regression(1).equation='RRN14';
MuscleLengthRegression(k).regression(1).joints={'Radius_J1','Radius','Hand','Wrist_J1'};
MuscleLengthRegression(k).regression(1).coeffs=[ 2.86204E-01  -5.96836E-03    1.79326E-03   3.62213E-04   1.56113E-03   -2.89215E-04  1.25293E-03  1.25067E-02  -1.45309E-02  7.28971E-04   2.63316E-02  -4.61942E-03   -3.26159E-04  -1.32954E-04  1.23138E-04   9.03957E-05  -2.38232E-04  1.35556E-06          ]';

k=k+1;
%% ExtensorCarpiRadialisLongus
MuscleLengthRegression(k).name='ExtensorCarpiRadialisLongus';
MuscleLengthRegression(k).regression(1).equation='RRN14';
MuscleLengthRegression(k).regression(1).joints={'Radius_J1','Radius','Hand','Wrist_J1'};
MuscleLengthRegression(k).regression(1).coeffs=[3.34545E-01  -6.65857E-03   -4.04481E-03  -1.27585E-03    2.54394E-03   -3.40076E-06 4.62182E-04   2.08273E-02  -1.62708E-02  4.36571E-03  1.83262E-02   -4.93580E-03  2.42875E-03  -1.07794E-03  -3.66750E-03  7.29403E-04  1.43831E-03  5.68255E-06               ]';


k=k+1;
%% ExtensorCarpiUlnaris
MuscleLengthRegression(k).name='ExtensorCarpiUlnaris';
MuscleLengthRegression(k).regression(1).equation='RRN14';
MuscleLengthRegression(k).regression(1).joints={'Radius_J1','Radius','Hand','Wrist_J1'};
MuscleLengthRegression(k).regression(1).coeffs=[2.90684E-01  6.89958E-03  5.64787E-04   -8.40770E-04   2.47044E-03  -1.90395E-03  1.65339E-03   -1.84145E-02  1.41618E-03   -1.97683E-03   2.01464E-02  -1.36392E-02   -3.03054E-02  4.04515E-02   -3.35833E-05  3.24259E-04 -1.56576E-03    1.12800E-02            ]';




k=k+1;
%% FlexorCarpiRadialis
MuscleLengthRegression(k).name='FlexorCarpiRadialis';
MuscleLengthRegression(k).regression(1).equation='RRN14';
MuscleLengthRegression(k).regression(1).joints={'Radius_J1','Radius','Hand','Wrist_J1'};
MuscleLengthRegression(k).regression(1).coeffs=[3.12671E-01 -7.51480E-03   -3.45794E-03  6.67550E-04   -2.64652E-03  3.63267E-04   2.93194E-03   6.36807E-03  3.62021E-03  4.32035E-04   -2.96833E-02   -4.87712E-03   3.58229E-03    2.41666E-03   1.24898E-03  -5.26353E-04  6.61266E-04  5.57793E-07     ]';



k=k+1;
%% FlexorCarpiUlnaris
MuscleLengthRegression(k).name='FlexorCarpiUlnaris';
MuscleLengthRegression(k).regression(1).equation='RRN14';
MuscleLengthRegression(k).regression(1).joints={'Radius_J1','Radius','Hand','Wrist_J1'};
MuscleLengthRegression(k).regression(1).coeffs=[3.12561E-01  -4.93588E-03  -2.17405E-03   -3.06182E-04  -1.24989E-03   2.42124E-04  2.16695E-03   -2.17438E-02   8.89277E-03  6.86712E-03  -2.87258E-02  -5.64241E-03  2.89023E-04  -6.29547E-04  8.81255E-04  -1.91789E-04  4.63621E-04  -4.25472E-06          ]';




k=k+1;
%% PalmarisLongus
MuscleLengthRegression(k).name='PalmarisLongus';
MuscleLengthRegression(k).regression(1).equation='RRN14';
MuscleLengthRegression(k).regression(1).joints={'Radius_J1','Radius','Hand','Wrist_J1'};
MuscleLengthRegression(k).regression(1).coeffs=[3.37628E-01  -4.01010E-03  -6.25346E-03  9.72013E-04  -3.57998E-03   4.21330E-04  3.29094E-03   4.98232E-03  1.17032E-02  -3.91610E-03  -4.57240E-02  -9.74559E-03  1.52482E-02  2.03664E-02    2.24819E-03   -7.83261E-04   8.98050E-04  -6.73138E-06            ]';





end