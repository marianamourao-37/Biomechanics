function q = Body2q()

%acess global memory
global Body NBodies 

% initial configuration of the system for each body at the first time step 
q = zeros(3*NBodies,1);
for i=1:NBodies
    n=3*i-2;
    
    % position of the center of mass (x,z)
    q(n:n+1,1)=Body(i).r;
    
    % orientaion of the local reference frame
    q(n+2,1)=Body(i).theta;
end
