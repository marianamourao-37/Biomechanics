% Pre-processing data from the Laboratory of Biomechanics of Lisbon  

close all;
clear all;
clc;

global Data file 

% Reads input data for the biomechanical model 
ReadProcessingFile('DraftBiomechanicalModel.txt');

% Reads the static data 
file = 'static';
StaticData = ReadProcessData('trial0001_static_frontal.tsv');

% Compute the average segment lengths 
ComputeAverageLength(StaticData); 

% Compute total body mass from ground reaction forces and updates the mass
% and inertia of the bodies 
ComputeBodyProperties();

% Choose motion
disp('Please choose gait or moutain climber file regarding the position coordinates');
file_name = uigetfile('*.tsv','Choose gait or moutain climber');

if contains(file_name(1:end-4), 'mountain_climber')
    file = 'mountain_climber';
else
    file = 'gait';
end

% Raeds the gait data 
Data = ReadProcessData(file_name);

if strcmp(file,'mountain_climber')
    ComputeCycles_MC();
end

% Computes the positions and angles of the body 
EvaluatePositions();

% Evaluates the drivers
EvaluateDrivers();

% Process the ground reaction forces
ReadGRF(); 

% Updates the data in the files to be read by the kinematic analysis 
WritesModelInput(['BiomechanicalModel_',file,...
    '.txt']);