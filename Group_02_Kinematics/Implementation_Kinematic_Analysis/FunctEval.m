function [Phi,Jac,niu,gamma]=FunctEval(q,qd,time)
% function will replace constraint and jacobian, 
% modeling new positions and velocities every 
% new time step.

%global variables
global Flag Nconstraint Ncoordinates ...
    NBodies Body NRevolute NDriver Nline

%Transfer data to local variables 
for i=1:NBodies
    i1=3*(i-1)+1; 
    i2=i1+1;
    i3=i2+1;
    
    %transfer position data to local storage
    Body(i).r=q(i1:i2,1);
    Body(i).theta=q(i3,1);

    %evaluate the transformation matrices
    cost=cos(Body(i).theta); 
    sint=sin(Body(i).theta); 
    Body(i).A = [cost -sint; sint cost];
    Body(i).B = [-sint -cost; cost -sint];
              
    %transfer data to local storage
    if Flag.Acceleration==1
        Body(i).rd=qd(i1:i2,1);
        Body(i).thetad=qd(i3,1);
    end
end

%initialize vectors and matrices
Phi=zeros(Nconstraint,1);
Jac=zeros(Nconstraint,Ncoordinates);
niu=zeros(Nconstraint,1);
gamma=zeros(Nconstraint,1);

Nline = 1;

%populate vectors and matrix whith constraints

%contribuition by revolute joints
for k=1:NRevolute 
    [Phi,Jac,niu,gamma]=JointRevolute(Phi,Jac,niu,gamma,k);
end

%contribuiton by driving constraints
for k=1:NDriver 
    [Phi,Jac,niu,gamma]=JointDriver(Phi,Jac,niu,gamma,k,time);
end

% finalize function to add constraints
end

