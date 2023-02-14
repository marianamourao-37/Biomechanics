function g = ForceGravity()

% memory access to data 
global NBodies NCoord Body grav 

% initialize force vector 
g = zeros(NCoord, 1);

% add the gravity force for each body 
for i = 1:NBodies 
    i1 = 3*(i-1)+1;
    i2 = i1+1;
    
    g(i1:i2)=Body(i).mass*grav;
end

%end of function 
end 