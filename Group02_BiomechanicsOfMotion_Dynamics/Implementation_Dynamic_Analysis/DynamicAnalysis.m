close all;
clear all;
clc;

%define global variables 
global tspan

%input file 
file_name = uigetfile('*.txt','Select the dynamic model file (gait or moutain climber)');

%reads input data 
ReadInput(file_name);

% correct initial conditions 
[q0, qd0] = CorrectInitialConditions();

%forms the initial y vector 
y0 = [q0; qd0];

% call matlab function to integrate equations 
[t, y] = ode45(@FuncEval, tspan, y0);

%report Results 
[q, qd, qddd, lambda] = ReportResults(t, y); 