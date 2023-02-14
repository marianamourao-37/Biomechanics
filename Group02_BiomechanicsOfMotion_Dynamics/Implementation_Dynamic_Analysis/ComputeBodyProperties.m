function ComputeBodyProperties()
% This function reads the data from the ground reaction forces, computes
% the total body mass and updates the mass and inertia of all bodies 

% global memory data 
global NBody Body TotalBodyMass

% transforms the data from the local reference frame of the force plates
% to the global reference frame of the laboratory. The output includes the
% magnitude of the forces in x, y and z, and the position of the center of
% pressure in x, y and z. 
[~, fp2, ~] = tsv2mat(0,0,0);

% static position was acqueried in the second force plate 

% For the static position, only the force plate 2 was used and the force is
% saved on the 3rd column
AverageWeight = mean(fp2(:,3));

% defines the total body mass considering a gravitational acceleration of
% 9.8 m/s^2 
TotalBodyMass = AverageWeight/9.8;
disp(['The total body mass is ', num2str(TotalBodyMass), ' kg']);

% goes through all bodies and updates the mass and moment of inertia 
for i = 1:NBody
    % updates the mass 
    Body(i).mass = Body(i).mass * TotalBodyMass;
    
    % updates the moment of inertia 
    Body(i).inertia = Body(i).mass * (Body(i).rg * Body(i).Length)^2;
    
    % end of the loop that goes through all bodies 
end 

% end of function 
end 
    