function [q0, qd0] = CorrectInitialConditions()

% global memory assignment 
global NBodies NCoord Body tstart 

% define initial conditions for the kinematic analysis 
q = zeros(NCoord, 1);
for i = 1:NBodies 
    i1 = 3*(i-1)+1;
    i2 = i1 + 1;
    i3 = i2 + 1;
    
    % position of the center of mass (x,z)
    q(i1:i2,1) = Body(i).r;
    
    % orientaion of the local reference frame
    q(i3, 1) = Body(i).theta;
end 

% position analysis 
q0 = PositionAnalysis(q, tstart);

% Velocity analysis 
qd0 = VelocityAnalysis(q0,tstart); 
    
% end of function 
end 