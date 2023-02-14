function qd=VelocityAnalysis(q,time)
%function to perform the velocity analysis

%global variables
global Flag 

%set up the flags to evaluate jacobian matrix and niu
Flag.Position=0;
Flag.Jacobian=1;
Flag.Velocity=1;
Flag.Acceleration=0;

%form the jacobian matrix and velocity rhs
[~,Jac,niu,~]=Kinem_FuncEval(q,time);

%solve the system of equations to get velocities
qd=Jac\niu;  

%finish the function for velocity analysis
end