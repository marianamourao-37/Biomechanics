function x = SolveEquations(qd, M, Phi, Jac, niu, gamma, g)

% access global variables 
global NConst alpha beta 

% form left hand side matrix 
Null = zeros(NConst, NConst);
H = [M Jac'; Jac Null]; 

% form the right hand side vector 
b = [g; gamma - 2*alpha*(Jac*qd-niu)-beta^2*Phi];

% solve the equations 
x = H\b;

% end of function 
end 
