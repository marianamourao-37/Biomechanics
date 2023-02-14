function ReadInput(ModelName) 
%this function reads the draft of the biomechanical model 

% global memory data 

global NBodies NRevolute NGround NDriver NFplates NCoord ...
    NConst Body JntRevolute JntDriver FPlate tstart tstep ...
    tend NSteps NR_MaxIter tol grav tspan fs alpha beta ...
    TotalBodyMass file cycles num_cycles half_cycles half_mean initial_cycle

% reads the input file 
H = dlmread(ModelName);
file=ModelName(20:end-4);

% store the general dimensions of the system
NBodies = H(1,1);
NRevolute = H(1,2);
NGround = H(1,3);
NDriver = H(1,4);
NFplates = H(1,5);

% Defines the total number of coordinates and the number of constraints 
NCoord = 3*NBodies;
NConst = 2*NRevolute + NGround + NDriver;

line = 1;

% stores the data for the rigid body information 
for i = 1:NBodies 
    line = line +1;
    
    % read the positions and velocities 
    Body(i).r = H(line, 2:3)';
    Body(i).theta = H(line, 4);
    Body(i).PCoM=H(line,5);
    Body(i).Length=H(line,6);
    Body(i).rd = H(line, 7:8)';
    Body(i).thetad = H(line, 9);
    
    %read the mass and moment of inertia 
    Body(i).mass = H(line, 10);
    Body(i).inertia = H(line, 11);
    
    ctheta = cos(Body(i).theta);
    stheta = sin(Body(i).theta);
    Body(i).A = [ctheta -stheta
                 stheta ctheta];
    Body(i).B = [-stheta -ctheta
                  ctheta -stheta];  
end 

% stores the data for the revolute joints 
for k = 1:NRevolute 
    line = line +1;
    JntRevolute(k).i = H(line, 2);
    JntRevolute(k).j = H(line, 3);
    JntRevolute(k).spi = H(line, 4:5)';
    JntRevolute(k).spj = H(line, 6:7)';
    
end 

% stores the data for the driver joints 
for k = 1:NDriver
    line = line +1; 
    JntDriver(k).type = H(line, 2);
    JntDriver(k).i = H(line, 3);
    JntDriver(k).coordi = H(line, 4);
    JntDriver(k).j = H(line, 5);
    JntDriver(k).coordj = H(line, 6);
    JntDriver(k).filename = H(line, 7);
    
    % reads the data and builds the splines 
    DriverData = dlmread([file,num2str(JntDriver(k).filename), '.txt']);
    
    %create the local arrays
    t1=DriverData(:,1);
    z=unwrap(DriverData(:,2));
    
    % builds the spline structure 
    JntDriver(k).spline = spline(t1,z); % theta_ij(t)
    
    Nsplines = JntDriver(k).spline.pieces;
    
    % Initialize arrays of coefficients for spline segments
    % derivatives
    coefs_d = zeros(Nsplines,3);
    coefs_dd = zeros(Nsplines,2);
    
    % Calculate spline 1st derivative and build v for each driver
    for o = 1:Nsplines
        coefs_d(o,:) = polyder(JntDriver(k).spline.coefs(o,:));
    end
    
    JntDriver(k).splined = mkpp(t1,coefs_d); % theta_ij(t) dot
    
    %calculate spline 2nd derivative
    for o = 1:Nsplines
        coefs_dd(o,:) = polyder(JntDriver(k).splined.coefs(o,:));
    end
    JntDriver(k).splinedd = mkpp(t1,coefs_dd);
    
    % Filtering of the Interpolated Data 
    fs = 1/(t1(2)-t1(1));
    JntDriver(k).splined = FilterCoordinates(ppval(JntDriver(k).splined,t1),fs);
    JntDriver(k).splined = spline(t1,JntDriver(k).splined);
    JntDriver(k).splinedd = FilterCoordinates(ppval(JntDriver(k).splinedd,t1),fs);
    JntDriver(k).splinedd = spline(t1,JntDriver(k).splinedd);
    
end 

% stores the data for the force plates 
for k = 1:NFplates
    line = line + 1;
    if ~(strcmp(file,'mountain_climber') && k == 2)
        FPlate(k).i = H(line, 2);
        FPlate(k).j = H(line, 3);
        FPlate(k).spi = H(line ,4:5)';
        FPlate(k).spj = H(line, 6:7)';
        FPlate(k).filename = H(line, 8);

        % reads the data and builds the splines
        ForceData = dlmread([file, 'FPlates_', num2str(FPlate(k).filename), '.txt']);

        FPlate(k).Data = ForceData;

        % builds the spline structure 
        FPlate(k).spline = [spline(ForceData(:,1),ForceData(:,2));
            spline(ForceData(:,1), ForceData(:,3));
            spline(ForceData(:,1), ForceData(:,4)); % spline of copx 
            spline(ForceData(:,1), ForceData(:,5))]; % spline of copy 
    end
end 

line = line + 1;

% reads time information 
tstart = H(line, 1);
tstep = H(line, 2);
tend = H(line, 3);
TotalBodyMass = H(line, 4);
NSteps = round((tend-tstart)/tstep)+1;

if strcmp(file,'mountain_climber')
    cycles_file = dlmread('Cycles_MountainClimber.txt');
    
    line = 1;
    nframe_initial = cycles_file(line,1);
    num_cycles = cycles_file(line,2);
    
    cycles(1).complete = [1];
    half_cycles = zeros(num_cycles,1);
    
    line = line +1;
    half_cycles(1,1) = cycles_file(line,1) - nframe_initial;
    
    line = line + 1;
    
    for i = 1:num_cycles
        if i == 1
            cycles(i).complete(end+1) = cycles_file(line,i)-...
                nframe_initial;
        else 
            cycles(i).complete = [cycles_file(line,i-1)+1, ...
                cycles_file(line,i)] - nframe_initial;
            half_cycles(i,1) = cycles_file(line-1,i) - (cycles_file(line,i-1)+1);
        end
    end
    
    initial_cycle = 2;
    
    half_mean = round(mean(half_cycles(initial_cycle:end)));

end

alpha = 5;
beta = 5;

%defines analysis conditions 
tol = 1e-6;
grav = [0; -9.81];
tspan = tstart:tstep:tend; 
NR_MaxIter = 12;
fs = 1/tstep;
 
% end of function 
end  