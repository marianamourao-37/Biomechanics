function [Phi,Jac,niu,gamma]=JointDriver(Phi,Jac,niu,gamma,k, time)

%access global memory
global Flag Nline JntDriver Body

%define local variables
i = JntDriver(k).i;
type = JntDriver(k).type;

l1=Nline; % all drivers are just one equation

%Information for each driver type 
if(type==1) % simple driver, which considers a uniform accelerated system
    coordi = JntDriver(k).coordi; % driven coordinate (x, z or theta)
    z = ppval(JntDriver(k).spline,time); % position 
elseif(type==3) %for the angle between two vectors of two different bodies
    j = JntDriver(k).j;
end

% Assemble Position Constraint Equations 
if (Flag.Position == 1)
    if (type == 1)  % for the simple driver      
        if (coordi == 1)
            Phi(l1,1) = Body(i).r(1,1) - z;
        elseif(coordi == 2)
            Phi(l1,1) = Body(i).r(2,1) - z;
        elseif (coordi == 3)
            Phi(l1,1) = Body(i).theta - z;
        end
    elseif (type == 3) 
        Phi(l1,1) = Body(j).theta - (Body(i).theta + ppval(JntDriver(k).spline, time));
    end  
end

%Assemble the Jacobian Matrix
if (Flag.Jacobian==1)
    if (type == 1)  
        c1 = 3*(i-1) + coordi;
        Jac(l1,c1) = 1;
    elseif (type == 3)
        c1 = 3*(i-1) + 3;
        Jac(l1,c1) = -1;
        c1 = 3*(j-1) + 3;
        Jac(l1,c1) = 1;
    end   
end

%Assemble the r.h.s. of velocities equations
if(Flag.Velocity==1)
    niu(l1,1)=ppval(JntDriver(k).splined,time);
end

%Assemble the r.h.s. of acceleration equations
if (Flag.Acceleration==1)
    gamma(l1,1)=ppval(JntDriver(k).splinedd,time);
end

%update the constraint number
Nline=Nline+1;

%finish fucntion
end



    
    