function qdd=AccelerationAnalysis(q,qd,time)

%global variables
global Flag

%set up the flags to evaluate the acceleration rhs
Flag.Position=0;
Flag.Jacobian=1;
Flag.Velocity=0;
Flag.Acceleration=1;

%form the acceleration rhs
[~,Jac,~,gamma]=FunctEval(q,qd,time);

%solve the system of equations to get velocities
qdd=Jac\gamma; 

%finish the function for acceleration analysis
end