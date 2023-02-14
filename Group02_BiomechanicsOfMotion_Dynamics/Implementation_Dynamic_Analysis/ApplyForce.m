function g = ApplyForce(i,g,f,sp)
%generic function to evaluate the external force applied on a body 
i1 = 3*(i-1)+1;
i2 = i1+1;
i3 = i2 + 1;

% add force to the force vector 
g(i1:i2,1) = g(i1:i2,1) + f;

% add transport moment to force gector 
g(i3,1) = g(i3,1) + sp(1,1)*f(2,1) - sp(2,1) * f(1,1);

% end function
end 