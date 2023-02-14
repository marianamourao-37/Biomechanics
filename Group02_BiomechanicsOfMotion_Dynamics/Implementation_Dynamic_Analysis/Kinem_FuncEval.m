function [Phi, Jac, niu, gamma] = Kinem_FuncEval(q,time)

% global variables
global NRevolute NDriver NCoord NConst Nline ...
    Body NBodies

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
end

%initialize output 
Nline = 1;
Phi = zeros(NConst, 1); 
Jac = zeros(NConst, NCoord);
niu = zeros(NConst, 1);
gamma = zeros(NConst,1);

% for each revolute joint 
for k = 1: NRevolute 
    [Phi, Jac, niu, gamma] = JointRevolute(Phi, Jac, ...
        niu, gamma,k);
end

% For each driver joint 
for k = 1:NDriver 
    [Phi, Jac, niu, gamma] = JointDriver(Phi, Jac, niu, ...
        gamma, k, time);
end 

%finish function 
end 
        