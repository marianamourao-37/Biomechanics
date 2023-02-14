%Function to read Input data
function [q,qd,qdd]=ReadInput()
%
%acess global memory
global NBodies Body NRevolute  NGround ...
    NDriver NConstraints JntRevolute JntDriver NR_Tolerance ...
    NR_MaxIter Tstart Tend Tstep NCoordinates ...
    NTstep Interpolation file 

%ask the user about the motion to be studied
file=input('gait or mountain_climber?','s');

%Read the content of an input file
H=dlmread(['BiomechanicalModel_',file,'.txt']);

%store the model general dimensions
NBodies=H(1,1);
NRevolute=H(1,2);
NGround=H(1,3);
NDriver=H(1,4);

line = 1; % initializes the line of the input file to be accessed

% store the data for the rigid bodies information.
% initial configuration of the system for each body at the 
% first time step, regarding the position of the center of 
% mass (x,z) and the orientaion of the local reference frame
for i=1:NBodies
    line=line+1; % increments the line of the input file to be accessed
    Body(i).r=H(line,2:3)';
    Body(i).theta=H(line,4);
    Body(i).PCoM = H(line,5);
    Body(i).Length = H(line,6);
end

%initializes data for revolute joints
for k=1:NRevolute
    line=line+1; % increments the line of the input file to be accessed
    % Bodies i and j, connected by the revolute joint 
    JntRevolute(k).i= H(line,2);
    JntRevolute(k).j= H(line,3);
    
%     the absolute position of the local coordinates of the 
%     revolute joint with respect to the center of mass of 
%     the body i and j 
    JntRevolute(k).spPi= H(line,4:5)';
    JntRevolute(k).spPj= H(line,6:7)';
end

%initializes data for the driver joints
for k=1:NDriver
    line=line+1; % increments the line of the input file to be accessed
    JntDriver(k).type= H(line,2); % type of driver
    
    % bodies that define the driver  
    JntDriver(k).i= H(line,3); % body driven 
    JntDriver(k).j= H(line,5)'; 
    
    % number of the coordinate driven (1-x, 2-z or 3-theta)
    JntDriver(k).coordi=H(line,4); 
    JntDriver(k).coordj=H(line,6);  

end

%Interpolation of position, velocity and accelaration as a
%continuous function of time
for i=1:NDriver 
    name = sprintf('%d.txt',i);
    %read the input file
    D = dlmread([file,name]);
    
    %create the local arrays
    t1=D(:,1);
    z=unwrap(D(:,2));
    
    % Create the spline interpolation for the complete domain, 
    % retrieving a structure with spline segments coefficients
    Interpolation(i).p=spline(t1,z); % theta_ij(t)

    Nsplines=Interpolation(i).p.pieces;
    
    % Initialize arrays of coefficients for spline segments
    % derivatives
    coefs_d=zeros(Nsplines,3);
    coefs_dd=zeros(Nsplines,2);

    % Calculate spline 1st derivative
    for k=1:Nsplines
        coefs_d(k,:)=polyder(Interpolation(i).p.coefs(k,:));
    end
    Interpolation(i).v=mkpp(t1,coefs_d); % theta_ij(t) dot
    
    %calculate spline 2nd derivative
    for k=1:Nsplines
        coefs_dd(k,:)=polyder(Interpolation(i).v.coefs(k,:));
    end
    
    Interpolation(i).a=mkpp(t1,coefs_dd); % theta_ij(t) double dot
end

% Filtering of the Interpolated Data 
for i=1:NDriver
    fs = 1/(t1(2)-t1(1));
    Interpolation(i).v=FilterCoordinates(ppval(Interpolation(i).v,t1),fs);
    Interpolation(i).v = spline(t1,Interpolation(i).v);
    Interpolation(i).a=FilterCoordinates(ppval(Interpolation(i).a,t1),fs);
    Interpolation(i).a = spline(t1,Interpolation(i).a);
end

%store data for the analysis period and stepping
line=line+1; % increments the line of the input file to be accessed
Tstart=H(line,1);
Tstep=H(line,2);
Tend=H(line,3);
NTstep = round((Tend-Tstart)/Tstep)+1;

%store the information for the the numerical methods
NR_Tolerance = 10^-6;
NR_MaxIter = 12;

%general dimensions of the model
NCoordinates=3*NBodies;
NConstraints = 2*NRevolute+NDriver;

%create the memory space for kinematics
q=zeros(NCoordinates,NTstep+1);
qd=zeros(NCoordinates,NTstep+1);
qdd=zeros(NCoordinates,NTstep+1);

end