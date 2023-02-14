function [cadence,stride,velocity]=ReportResults(q,qd,qdd,time)

global Body NBodies file NTstep Tend Tstart 

% The kinematic data provided for gait includes
% 10 time steps before the beginning of the gait cycle
% and 10 time steps after.
% These time steps were included to have data for the filtering and spline interpolation
% steps before and after the gait cycle (extremities of the 
% motion), without compromising the data at those points 
% when evaluating the gata cycle

if strcmp(file,'gait')
    % start at position 12, since the first column corresponds to the
    % initial configurition of the system
    q = q(:,12:end-10); 
    qd = qd(:,12:end-10); 
    qdd = qdd(:,12:end-10);
    time = time(11:end-10);
else
    % start at position 2, since the first column corresponds to the
    % initial configurition of the system
    q = q(:,2:end);
    qd = qd(:,2:end);
    qdd = qdd(:,2:end);
end

for i=1:NBodies
    x= 3*(i-1)+1;
    z= 3*(i-1)+2;
    theta=3*i;
    for k=1:NTstep-20
        pProx(:,k)=[q(x,k)+cos(q(theta,k))*(1-Body(i).PCoM)*Body(i).Length;...
            q(z,k)+sin(q(theta,k))*(1-Body(i).PCoM)*Body(i).Length];
        pDist(:,k)=[q(x,k)-cos(q(theta,k))*(Body(i).PCoM)*Body(i).Length;...
            q(z,k)-sin(q(theta,k))*Body(i).PCoM*Body(i).Length];
    end
    Body(i).pProx=pProx;
    Body(i).pDist=pDist;
end

r=1:NTstep-20;
Animate(r);

% Plots sequential positions for given body parts, for a specified 
% time rate 
if strcmp(file, 'gait') % for the gait movement
    tstep = 40*10^(-3); % time rate 
    
    % samples corresponding to the specified time rate 
    nstep = (Tend-Tstart)/tstep+1; 
    
    % equally spaced vector countaning the frames to be acessed 
    r =round(linspace(1,NTstep-20,nstep)); 
    
    bodies = 7:14; % bodies to be analyzed 
    title = 'Gait Stick Diagram';
    Plot_Positions(r,bodies, title);
    
else % for the mountain climber movement
    bodies = 1:NBodies; % bodies to be analyzed 
    
    % for the data acquired at the lab, it's isolated 
    % the 1st half-cycle from the 2nd half-cyle of the 
    % movement, for its first repetition/execution  
    
    % left knee and hip flexion  
    r1 = 335:5:365; 
    
    % left knee and hip extension 
    r2 = 365:5:405; 
    
    title1 = 'Mountain Climber Stick Diagram: Flexion of Left Knee';
    title2 = 'Mountain Climber Stick Diagram: Extension of Left Knee';
    
    Plot_Positions(r1,bodies,title1); 
    Plot_Positions(r2,bodies,title2);
end

Angles(q,time); 
PostProcessResults(q,qd,qdd,time);

if ~strcmp(file,'gait')
    climber_cycle = input('Do you want analyze a one-full mountain climber cycle?(Yes/No)','s');
    if strcmp(climber_cycle,'Yes')
        samples = [335,425];
        climbercycle_angles(q,time,samples);
        climbercycle_pva(q,qd,qdd,time,samples); 
    end
end

%% Metrics of gait movement: cadence, stride and velocity

% Analyzing the results, considering 2 steps per gait 
% cycle (Tend seconds), the cadence can be calculated as 
% follows (steps/min):
cadence = (60*2)/(Tend);

% horizontal initial position of the toes for one complete
% gait cycle 
qi = q(14*3 - 2,1); 

% horizontal final position of the toes for 
% the one complete gait cycle
qf  = q(14*3 - 2,end); 

% distance between two consecutive heel strikes in one 
% complete gait cycle by the same leg
stride = qf - qi; 

velocity = (stride*cadence)/120; %m/s
end

