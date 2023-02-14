Biomechanics of Movement 2020/2021 
Project of Dynamic Analysis of Human Movement: Gait and Mountain Climber exercise

Ana Lopes (98587)
Daniel Galhoz (90791)
Mariana Mourão (98473) 
Rita Almeida (90180)

The steps to be able to implement our dynamic analysis code:

1- Open MATLAB

2- Run the Preprocessing.m. script
   - It Will appear a window to choose the file .tsv to analyse, and should be selected either 'trial0002_str2.tsv' or 'trial0010_mountain_climber.tsv'. 

3- Run the DynamicAnalysis.m script. 
   - It Will appear a window to choose the file .txt to analyse, and should be selected either 'BiomechanicalModel_gait.txt' or 
     'BiomechanicalModel_mountain_climber.txt'. 

Please take into consideration that for each of the steps mentioned, the choice of the aforementioned files will lead to the analysis of the motion selected. 
For that reason, if it is intended to analyse the other movement, please repeat the second step, chossing the other option.

All of the functions used are inside the folder named Implementation_Dynamic_Analysis.

Note: If it is desired to obtain the bar graph which displays the obtained cut-off frequencies through residual analysis, s used for filtration of the position 
data of each body, for both movements, it is necessary to in advance run the PreProcessing.m function for both movements (step 2). After this, please run 
the bargraphCutOffFrequencies.m script. 


