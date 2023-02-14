close all;
clear all;
clc;

% Pre-processing of data from the Laboratory of 
% Biomechanics of Lisbon 

% Global memory:
global Data file

% Read input data for the biomechanical model
ReadDraftInput('DraftBiomechanicalModel.txt');

% Reads the static data, in order to allow the computation of the 
% segment lengths
file = 'static';
StaticData=ReadProcessData('trial0001_static_frontal.tsv');

%compute the average segment legths
ComputeAverageLength(StaticData);

% Choose motion
file = uigetfile('*.tsv','Choose gait or moutain climber');

%reads the dynamic file for the motion to be studied (gait)
Data = ReadProcessData(file);

%computes the positions and angles of the body
EvaluatePositions(Data);

%evaluates the drivers
EvaluateDrivers(Data);

file = file(1:end-4);
if contains(file, 'mountain_climber')
    file = 'mountain_climber';
else
    file = 'gait';
end

%update the data in the files to be read by the kinematic 
%analysis
WritesModelInput(['BiomechanicalModel_',file,...
    '.txt']);