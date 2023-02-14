function g = MakeForceVector(t) 

%gravity force 
g = ForceGravity();

% external forces from the force plates 
g = ForcePlates(g, t);

% end of function 
end 