function [yd, lambda, Jac] = FuncEval(t, y)

%memory access to data 
global NCoord Flag

% Tranfer positions and velocities to body 
[q, qd] = y2q(y); 

% build the mass matrix 
M = BuildMassMatrix();

% build Jacobian matrix, Phi, Phid, etc 
% initialize flag 
Flag.Position = 1;
Flag.Jacobian = 1;
Flag.Velocity = 1;
Flag.Acceleration = 1;
[Phi, Jac, niu, gamma] = Kinem_FuncEval(q,t);

% build the force vector 
g = MakeForceVector(t);

% build and solve equations of motion 
x = SolveEquations(qd, M, Phi, Jac, niu, ...
    gamma, g);

% form the acceleration and lambda vectors 
qdd = x(1:NCoord);
lambda = x(NCoord +1:end);

%Form vector yd
yd = [qd;qdd];

% end of function 
end 
