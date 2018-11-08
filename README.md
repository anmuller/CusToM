## CusToM: a Matlab toolbox for musculoskeletal simulation

**CusToM Status:** [![status](http://joss.theoj.org/papers/4b412d584fbfa911edfae882146e2cd3/status.svg)](http://joss.theoj.org/papers/4b412d584fbfa911edfae882146e2cd3)

**License:** [![License](https://img.shields.io/badge/License-3_Clause_BSD-orange.svg)](https://github.com/anmuller/CusToM/blob/master/LICENSE)


# Table of contents
- [Authors](#Authors)
- [Summary](#Summary)  
- [Installation instructions](#Installationinstructions)
- [Data processing examples](#Dataprocessingexamples)
- [Citing CusToM](#Cite)
- [Contributing](#Contributing)  
- [Code of conduct](#CodeOfConduct)  
- [License](#License)
- [Acknowledgements](#Acknowledgements)  

Tags:
  - Motion analysis
  - Subject-specific
  - Kinematics
  - Dynamics
  - Muscle forces
  - Ground reaction forces prediction
  
# Authors <a name="Authors"></a>
  - Antoine Muller (1)
  - Charles Pontonnier (1,2)
  - Pierre Puchaud (1,2,3)      
  - Georges Dumont (1)
	
## Affiliations:
 - (1) Univ Rennes, CNRS, Inria, IRISA - UMR 6074, F-35000 Rennes, France
 - (2) Centre de Recherche des Ecoles de Saint-Cyr Coëtquidan, 56380 Guer, France
 - (3) Univ Rennes, M2S - EA 1274, 35170 Bruz, France
   
date: 2 July 2018

# Summary <a name="Summary"></a>

Customizable Toolbox for Musculoskeletal simulation (CusToM) is a MATLAB toolbox aimed 
at performing inverse dynamics based musculoskeletal analyzes [@Erdemir2007]. This type 
of analysis is essential to access mechanical quantities of human motion in different 
fields such as clinics, ergonomics and sports. CusToM exhibits several features. It 
can generate a personalized musculoskeletal model, and can solve from motion capture 
data inverse kinematics, external forces estimation, inverse dynamics and muscle forces
 estimation problems as in various musculoskeletal simulation software [@Damsgaard2006]
 [@Delp2007].

According to user choices, the musculoskeletal model generation is achieved thanks to 
libraries containing pre-registered models [@Muller2015b]. These models consist of body
parts osteoarticular models, set of markers or set of muscles to be combined together.
From an anthropometric based model, the geometric, inertial and muscular parameters are 
calibrated to fit the size and mass of the subject to be analyzed [@Muller2015a] 
[@Muller2017] [@Muller2017c]. Then, from motion capture data (extracted from a 
c3d file thanks to [@Barre2014]), the inverse kinematics step computes joint 
coordinates trajectories against time [@Lu1999]. Then, joint torques are computed 
thanks to an inverse dynamics step [@featherstone2008]. To this end, external forces 
applied to the subject have to be known. They may be directly extracted from 
experimental data (as platform forces) or be estimated from motion data by using 
the equations of motion in an optimization scheme [@Fluit2014]. Last, muscle forces 
are estimated. It consists in finding a repartition of muscle forces respecting the 
joint torques and representing the central nervous system strategy 
[@Crowninshield1978] [@Muller2017a] [@Muller2018].

For a large set of musculoskeletal models and motion data, CusToM can easily performs all of the analyzes described above. CusToM has been created as a modular tool to let the user being as free and autonomous as possible. The osteoarticular models, set of markers and set of muscles are defined as bricks customizable and adaptable with each other. The design or the modification of a musculoskeletal model is simplified thanks to this modularity. Following the same idea, some methods are defined as adaptable bricks. Testing new cost functions in the optimization schemes, changing performance criteria or creating alternative motion analysis methods can be done in a relatively easy way.

A user interface has been developed to facilitate the data management and the model definition during a given study.

![Alt Text](https://github.com/anmuller/CusToM/blob/master/Paper/Pipeline.png)

# Installation instructions <a name="Installationinstructions"></a>

You need to create a copy on a local directory on your machine to use CusToM. Obtain a copy by downloading and unzipping the latest zip file or clone CusToM instead e.g. using: git clone https://github.com/anmuller/CusToM. You can place the CusToM folder anywhere on your machine.

After downloading the main folder and placing it in a relevant location, the installation only consists in running the Installation file. It checks if you have a compatible version of Matlab, if the needed toolboxes are installed. The function will also add the Functions folder of CusToM to your current path.
 
CusToM was implemented and tested with the Matlab 2018a version.  Here is a list of toolboxes which appear to be used in CusToM:
* Symbolic Matlab Toolbox
* Optimization Toolbox
* Parallel Computing Toolbox.

# Data processing examples <a name="Dataprocessingexamples"></a>

Three tutorials extracted from research works are available in the current release. The first one consists in [predicting the ground reaction forces on a sidestep motion](#Tuto1). The second tutorials consists in [analyzing the kinematics of a pick-and-place task realized in a Virtual Reality Environment](#Tuto2) (holding a Head-Mounted-Display). The third tutorial consists in [estimating the lower limbs muscle forces during a cycling motion](#Tuto3). The tutorials are also illustrated by videos available in the repository. You can either follow
the instructions below or the videos to run these examples.

Examples are both detailed in the [CusToM Documentation](https://github.com/anmuller/CusToM/blob/master/Docs/CusToMDocumentation.pdf) and in [Youtube Videos](https://www.youtube.com/channel/UCfV7B4SIHa5Oc9SdvznjKRg).

### 1. External forces prediction on a side-step motion <a name="Tuto1"></a>

![alt text](https://github.com/anmuller/CusToM/blob/master/Examples/Tuto1.gif)

The first example is a side-step motion. It is extracted from a database currently being developed for population characterization. The objective of the tutorial is to compare measured and predicted external forces.

<a href="http://www.youtube.com/watch?v=K9a6GFHPhdQ" target="_blank"><img src="https://img.youtube.com/vi/K9a6GFHPhdQ/0.jpg" 
alt="Tutorial#1" width="240" height="180" border="10" /></a>

### 2. Kinematics analysis of a pick-and-place motion realized in virtual environment <a name="Tuto2"></a>

![alt text](https://github.com/anmuller/CusToM/blob/master/Examples/Tuto2.gif)

The second example is a pick-and-place motion realized in a virtual environment with an haptic device. The task is similar to the ones analyzed in. Here since no direct measurement of the external forces was made, the study focused only on kinematics features.

<a href="http://www.youtube.com/watch?v=p_9Gokhz7I4" target="_blank"><img src="https://img.youtube.com/vi/p_9Gokhz7I4/0.jpg" 
alt="Tutorial#2" width="240" height="180" border="10" /></a>

### 3. Lower limbs muscle forces estimation on a cycling motion <a name="Tuto3"></a>

![alt text](https://github.com/anmuller/CusToM/blob/master/Examples/Tuto3.gif)

This third example consisted in linking the symmetry, the performance and the health during a cycling motion. The muscular symmetry is analyzed by the motion analysis containing an inverse kinematics step, an inverse dynamics step and a muscle forces estimation step. The markers set used is that called Marker_set2 in CusToM. External forces applied on each foot were measured with two mobile platforms located on pedals.

<a href="http://www.youtube.com/watch?v=foL7PEI8P9o" target="_blank"><img src="https://img.youtube.com/vi/foL7PEI8P9o/0.jpg" 
alt="Tutorial#3" width="240" height="180" border="10" /></a>

# Citing CusToM <a name="Cite"></a>

Cite the Journal of Open Source Software paper: [![Under_Review](https://img.shields.io/badge/JOSS-Under_Review-yellow.svg)](10.21105/joss.00927)

Muller, A., Pontonnier, C., Puchaud, P., Dumont, G., (2018). CusToM : _a Matlab toolbox for musculoskeletal simulation_, in review. Journal of Open Source Software.

# Contributing <a name="Contributing"></a>

See [CONTRIBUTING](CONTRIBUTING.md)    

# Code of Conduct <a name="CodeOfConduct"></a>

See [CODE_OF_CONDUCT](CODE_OF_CONDUCT.md)

# License <a name="License"></a>

CusToM is provided under: [![License](https://img.shields.io/badge/License-3_Clause_BSD-orange.svg)](https://github.com/anmuller/CusToM/blob/master/LICENSE). The [license](https://github.com/anmuller/CusToM/blob/master/LICENSE) file is found on the GitHub repository.

# Acknowledgements <a name="Acknowledgements"></a>

We acknowledge contributions from Diane Haering, Félix Demore, Marvin Chauwin, Claire Livet, Lancelot Barthe and Amaury Dalla Monta.

