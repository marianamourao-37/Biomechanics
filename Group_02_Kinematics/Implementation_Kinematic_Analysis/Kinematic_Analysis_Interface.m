close all;
clear all;
clc

%Define Global variables
global Tstart Tend Tstep 

% Input data
[q,qd,qdd] = ReadInput();

% Initialize q
q(:,1) = Body2q();

%time step counter initialization
k=1;
t = Tstart:Tstep:Tend;

%For each time step perform kinematic analysis
for time=t
    
    % update time step counter
    k=k+1;
    
    % Take the previous q as a good estimation for the q of the 
    % current time step 
    q_i = q(:,k-1); 

    % Perform the position analysis (q)
    q(:,k)=PositionAnalysis(q_i,time);
    
    % Perform the velocity analysis (q dot)
    qd(:,k)=VelocityAnalysis(q(:,k),time);
    
    % Perform the acceleration analysis (q double dot)
    qdd(:,k)=AccelerationAnalysis(q(:,k),qd(:,k),time);
    
end

%Report results
[cadence,stride,velocity] = ReportResults(q,qd,qdd,t);

% Terminate program

