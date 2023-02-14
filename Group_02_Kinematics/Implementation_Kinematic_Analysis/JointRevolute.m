function [Phi,Jac,niu,gamma]=JointRevolute(Phi,Jac,niu,gamma,k)
%function to add the revolute kinematic joint information

%access global memory
global Flag Body JntRevolute Nline

%update the line number for pointer
i1=Nline;
i2=i1+1;
%
%initialize variables
i=JntRevolute(k).i;
j=JntRevolute(k).j;
spPi = JntRevolute(k).spPi;
spPj = JntRevolute(k).spPj;

%assemble position constraint equations
if Flag.Position==1
    Phi(i1:i2)=Body(i).r+Body(i).A*spPi - ...
                 (Body(j).r+Body(j).A*spPj);
end

%Assemble the jacobian matrix
if Flag.Jacobian==1
    j1=3*(i-1)+1;
    j2=j1+2;
    j3=3*(j-1)+1;
    j4=j3+2;
    
    Jac(i1:i2,j1:j2)=[eye(2),Body(i).B*spPi];
    Jac(i1:i2,j3:j4)=[-eye(2), -Body(j).B*spPj];
end

%assemble the r.h.s. of velocity equation
if Flag.Velocity==1
  niu(i1:i2,1)=0;
end

%assemble the r.h.s. of acceleration equation
if Flag.Acceleration==1
    gamma(i1:i2,1)=Body(i).A*spPi*Body(i).thetad^2 -...
                    Body(j).A*spPj*Body(j).thetad^2;
end  

%update the constraint number
Nline=Nline+2;

%finish the revolute joint contribution
end