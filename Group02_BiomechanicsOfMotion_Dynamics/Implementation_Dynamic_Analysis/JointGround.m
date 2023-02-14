
function [Phi,Jac,niu,gamma]=JointGround(Phi,Jac,niu,gamma,k,time)
%
%access global memory
global Flag Body Jnt Nline
%
%update the line numbers for pointer
i1=Nline;
i2=i1+2;   %because the ground joit involves 3 equations
%
%initialize variables
i=Jnt.Ground(k).i;
rP0=Jnt.Ground(k).rP0;
theta0=Jnt.Ground(k).theta0;
%
%assemble position constraint equations
if Flag.Position==1
    Phi(i1:i2,1)=[Body(i).r-rP0; Body(i).theta-theta0];
end
%
%Assemble the jacobian matrix
if Flag.Jacobian==1
    j1=3*(i-1)+1;
    j2=j1+2;
    Jac(i1:i2,j1:j2)=eye(3);
end
%
%assemble the r.h.s. of velocity equation
if Flag.Velocity==1
  %niu(l:l2,1)=zeros(3,1);
end
%assemble the r.h.s. of acceleration equation
if Flag.Acceleration==1
    %gamma(l:l2,1)=zeros(3,1);
end  
%update the constraint number
Nline=Nline+3;
%
%finish the ground joint contribution
end