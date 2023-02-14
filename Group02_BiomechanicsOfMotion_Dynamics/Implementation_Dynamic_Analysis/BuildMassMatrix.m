% Function to Build mass matrix 

function M = BuildMassMatrix()

global NCoord Body NBodies

% Create auxiliary vector with matrix diagonal 
aux = zeros(NCoord,1);

for i = 1:NBodies
    i1 = 3*i-2;
    i2=i1+1;
    i3 = i2 + 1;
    aux(i1:i3,1)=[Body(i).mass Body(i).mass Body(i).inertia];
end

M = diag(aux); % transforms diagonal into a full matrix 

% Finish BuildMassMatrix
end 
