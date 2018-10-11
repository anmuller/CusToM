## CusToM: a Matlab toolbox for musculoskeletal simulation

tags:
  - Motion analysis
  - Subject-specific
  - Kinematics
  - Dynamics
  - Muscle forces
  - Ground reaction forces prediction
  
# Authors:
  - Antoine Muller (1)
  - Charles Pontonnier (1,2)
  - Pierre Puchaud (1,2)      
  - Georges Dumont (1)
	
affiliations:
 - (1) Univ Rennes, CNRS, Inria, IRISA - UMR 6074, F-35000 Rennes, France
 - (2) Ecoles de Saint-Cyr Coëtquidan, 56380 Guer, France
   
date: 2 July 2018

# Summary

Customizable Toolbox for Musculoskeletal simulation (CusToM) is a MATLAB toolbox aimed at performing inverse dynamics based musculoskeletal analyzes [@Erdemir2007]. This type of analysis is essential to access mechanical quantities of human motion in different fields such as clinics, ergonomics and sports. CusToM exhibits several features. It can generate a personalized musculoskeletal model, and can solve from motion capture data inverse kinematics, external forces estimation, inverse dynamics and muscle forces estimation problems as in various musculoskeletal simulation software [@Damsgaard2006] [@Delp2007].

According to user choices, the musculoskeletal model generation is achieved thanks to libraries containing pre-registered models [@Muller2015b]. These models consist of body parts osteoarticular models, set of markers or set of muscles to be combined together. From an anthropometric based model, the geometric, inertial and muscular parameters are calibrated to fit the size and mass of the subject to be analyzed [@Muller2015a] [@Muller2017] [@Muller2017c]. Then, from motion capture data (extracted from a c3d file thanks to [@Barre2014]), the inverse kinematics step computes joint coordinates trajectories against time [@Lu1999]. Then, joint torques are computed thanks to an inverse dynamics step [@featherstone2008]. To this end, external forces applied to the subject have to be known. They may be directly extracted from experimental data (as platform forces) or be estimated from motion data by using the equations of motion in an optimization scheme [@Fluit2014]. Last, muscle forces are estimated. It consists in finding a repartition of muscle forces respecting the joint torques and representing the central nervous system strategy [@Crowninshield1978] [@Muller2017a] [@Muller2018].

For a large set of musculoskeletal models and motion data, CusToM can easily performs all of the analyzes described above. CusToM has been created as a modular tool to let the user being as free and autonomous as possible. The osteoarticular models, set of markers and set of muscles are defined as bricks customizable and adaptable with each other. The design or the modification of a musculoskeletal model is simplified thanks to this modularity. Following the same idea, some methods are defined as adaptable bricks. Testing new cost functions in the optimization schemes, changing performance criteria or creating alternative motion analysis methods can be done in a relatively easy way.

A user interface has been developed to facilitate the data management and the model definition during a given study.

# Installation instructions

CusToM was implemented and tested with the Matlab 2018a version and requires the Symbolic Matlab Toolbox, the Optimization Toolbox and the Parallel Computing Toolbox.

After downloading the main folder named CusToM and placing it in a relevant location on the computer, the installation only consists in adding the folder ...\CusToM\Functions and its subfolders to the Matlab path.

# Data processing examples

Two examples extracted from research works are available in the current release. The first one consists in estimating the lower limbs muscle forces during a cycling motion. The second one consists in predicting the ground reaction forces on a range of motion.

The first example contains an inverse kinematics step, an inverse dynamics step and a muscle forces estimation step. The markers set used is that called M2S in CusToM. External forces applied on each foot were measured with two mobile platforms located on pedals. The subject size is 184 cm and the subject weight is 70 kg. The parameters used for the model generation can be seen by running the GenerateParameters function and by loading the existing ModelParameters (thanks to the Load parameters button). In the same manner, the parameters used for the analysis processing can be seen by running the Analysis function and by loading the existing AnalysisParameters (thanks to the Load parameters button). The analysis can also be directly processed by running the function Main.

The second example contains an inverse kinematics step, a ground reaction forces prediction step and an inverse dynamics step. The subject size is 180 cm and the subject weight us 77.5 kg. The parameters used for model generation can be seen by running the GenerateParameters function and by loading the existing ModelParameters (thanks to the Load parameters button). In the same manner, the parameters used for the analysis processing can be seen by running the Analysis function and by loading the existing AnalysisParameters (thanks to the Load parameters button). The analysis can also be directly processed by running the function Main.

# Acknowledgements

We acknowledge contributions from Diane Haering, Félix Demore, Marvin Chauwin, Claire Livet, Lancelot Barthe and Amaury Dalla Monta.

