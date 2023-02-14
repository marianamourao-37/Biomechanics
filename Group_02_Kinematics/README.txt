Biomechanics of Movement 2020/2021 
Project of Kinematic Analysis of Human Movement: Gait and Mountain Climber exercise

Ana Lopes (98587)
Daniel Galhoz (90791)
Mariana Mourão (98473) 
Rita Almeida (90180)

The steps to be able to implement our kinematic analysis code:

1- Open MATLAB

2- Run the Preprocessing.m. script

-Will appear a window to choose the file .tsv to analyse.
	-In this window, there are 3 files (trial0001_static_frontal, trial0002_str2 and trial0010_mountain_climber)
		-Do not select the file regarding the static, since it is not necessary, because it runs automatically in both cases, choose one of the others.
		-Run again the other file.

-After running this script, for each movement, are created 17 files .txt:
    - ”BiomechanicalModel (motion name, either gait or mountain_climber).txt”
    -  ”(motion name, either gait or mountain_climber)(number of driver, 1 to 16).txt”

2- Run the Kinematic_Analysis_interface.m script. 

-Will appear in the command window  a question on which movement to analyse. 
	-Type gait or mountain_climber to select BiomechanicalModel_gait.txt or the BiomechanicalModel_mountain_climber.txt. 
- After selecting the movement, plots regarding the positions, velocities and accelerations of the bodys will appear, as well as plots concerning the joints angles.

Please take into consideration that for each of the steps mentioned, the choice of the aforementioned files will lead to the analysis of the motion selected. 
For that reason, if it is intended to analyse the other movement, please repeat the second step, chossing the other option.

Note: All of the functions used are inside the file named Implementation_Kinematic_Analysis.

