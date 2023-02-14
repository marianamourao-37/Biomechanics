function q=PositionAnalysis(q,time)
%Build the function to perform the position analysis using Newton Raphson

%global variables
global NR_Tolerance NR_MaxIter Flag 

%Initialize local parameters
i=0; % iteration counter
error=10.0*NR_Tolerance;  %estimated error at the start of Newton Raphson analysis

%set the flags to evaluate constraints and jacobian matrix
Flag.Position=1;
Flag.Jacobian=1;
Flag.Velocity=0;
Flag.Acceleration=0;

% start the Newton Raphson iterative process, 
% imposing a limit of iterations for preventing 
% the entrance on a infinite loop
while (error>NR_Tolerance && i<=NR_MaxIter)
    i=i+1;
    
    %evaluate the constraints equations and jacobian matrix
    [Phi,Jac,~,~]=FunctEval(q,[],time); 
    
    %evaluate the position correction
    Deltaq=Jac\Phi;
    
    %correct the positions
    q=q-Deltaq;
    
    %evaluate the error
    error=max(abs(Deltaq));
end

%Finish the position analysis
end

    