function [q, qd, qdd, lambda] = ReportResults(t, y)

%define gloval variables 
global NBodies NRevolute NCoord Body NSteps NDriver FPlate ...
    NFplates TotalBodyMass file num_cycles cycles diff_cycles ...
    climber_cycle initial_cycle half_cycles 

% goes through all time steps and computes the qdd and lambda 
for i = 1:length(t)
    [yd(i,:),lambda(:,i),Jac(:,:,i)] = FuncEval(t(i),y(i,:)');
end

%Obtain q values
q = y(:,1:NCoord)';
qd = y(:,NCoord+1:end)';
qdd = yd(:,NCoord+1:end)';

if strcmp(file,'gait')
    % Remove the first 10 steps and last 10 steps of gait cycle
    q = q(:,11:end-10); 
    qd = qd(:,11:end-10);
    qdd = qdd(:,11:end-10);
    t = t(11:end-10);
    Jac = Jac(:,:,11:end-10);
    lambda = lambda(:,11:end-10);
    NSteps = NSteps - 20;  
else
    climber_cycle = input('Do you want to overlap mountain climber cycles?(Yes/No)','s');
end

for i=1:NBodies
    x= 3*(i-1)+1;
    z= 3*(i-1)+2;
    theta=3*i;
    for k=1:NSteps
        pProx(:,k)=[q(x,k)+cos(q(theta,k))*(1-Body(i).PCoM)*Body(i).Length;...
            q(z,k)+sin(q(theta,k))*(1-Body(i).PCoM)*Body(i).Length];
        pDist(:,k)=[q(x,k)-cos(q(theta,k))*(Body(i).PCoM)*Body(i).Length;...
            q(z,k)-sin(q(theta,k))*Body(i).PCoM*Body(i).Length];
    end
    Body(i).pProx=pProx;
    Body(i).pDist=pDist;
end

r=1:NSteps;
Animate(r);

for i = 1:num_cycles
    % equally spaced vector countaning the frames to be acessed 
    r1 = round(linspace(cycles(i).complete(1),half_cycles(i)+cycles(i).complete(1),15)); 
    title = [num2str(i), 'º repetition Stick Diagram - Right Limb'];
    Plot_Positions(r1,title);
    
    r2 = round(linspace(cycles(i).complete(1)+half_cycles(i)+1,cycles(i).complete(2),15)); 
    title = [num2str(i), 'º repetition Stick Diagram - Left Limb'];
    Plot_Positions(r2,title);    
end

%set time as percentage
time = ((t-t(1))/(t(end)-t(1)))*100;
bodyweight = 9.87*ones(1,NSteps);

for k=1:NFplates
    if strcmp(file,'gait')
        fplate(k).Data = FPlate(k).Data(11:end-10,:);
    elseif ~(strcmp(file,'mountain_climber') && k == 2)
        fplate(k).Data = FPlate(k).Data;
    end
end

if strcmp(climber_cycle,'Yes')      
    diff_cycles = zeros(length(num_cycles));

    legend_name = ["1ºrepetition", "2ºrepetition", "3ºrepetition", ...
        "4ºrepetition", "5ºrepetition", "6ºrepetition"];
    legend_name = legend_name(initial_cycle:end);
    
    for i = initial_cycle:num_cycles 
        diff_cycles(i) = diff(cycles(i).complete);
    end

    [~, index_maxdiff] = max(diff_cycles);

    end_time = diff_cycles(index_maxdiff);
    time_MC = ((0.0:end_time)/(end_time))*100;
end

PlotGroundReaction(time, fplate, bodyweight);

if strcmp(file,'mountain_climber') && strcmp(climber_cycle,'Yes')  
    PlotGroundReaction_MC(time_MC, fplate,legend_name);
end

% Get g for each revolute joint (refers to 2 lambdas)
for i = 1:NRevolute
    k = 2*i-1;
    % For each instant in time
    for p = 1:length(lambda)
        gRev(:,p,i) = -Jac(k:k+1,:,p)'*lambda(k:k+1,p)./TotalBodyMass; 
    end
end

% Get g for each driver (refers to 1 lambda)
for i = 1:NDriver
    k = i + (NRevolute*2);
    for p = 1:length(lambda)
        gDriver(:,p,i) = -Jac(k,:,p)'*lambda(k,p)./TotalBodyMass;
    end
end

body_joints = [1 2; 1 3; 3 4; 1 5; 5 6; 1 7; 7 8; 8 9; 9 10; 1 11; 11 12; 12 13; 13 14];

joints_driver = ['Neck,Right shoulder,Right elbow,Left shoulder,Left elbow,Right hip,Right knee,Right ankle,Right toes,Left hip,Left knee,Left ankle,Left toes'];
joints_driver = string(strsplit(joints_driver,','));

PlotMomentsForce(time, gDriver, body_joints, joints_driver);
PlotJointPower(t, time, gDriver, body_joints, joints_driver);

% Drivers
if strcmp(file,'mountain_climber') && strcmp(climber_cycle,'Yes') 
    PlotMomentsForce_MC(time_MC, gDriver, body_joints, joints_driver,legend_name);
    PlotJointPower_MC(t,time_MC, gDriver, body_joints, joints_driver,legend_name);
end

%finish function 
end 