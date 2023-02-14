function WritesModelInput(ModelName)
% Function that writes the updated data for the biomechanical model 

%Global memory data
global file Data Body JntRevolute JntDriver NRevolute ...
    NDriver NBodies NGround 

%Open file 
fid = fopen(ModelName,'w');

% Store the general dimensions of the system
fprintf(fid,'%d %d %d %d\r\n', NBodies, NRevolute, NGround, NDriver);

% Store the data for the rigid body information.
% initial configuration of the system for each body at the 
% first time step, regarding the position of the center of 
% mass (x,z) and the orientaion of the local reference frame
for i=1:NBodies
    fprintf(fid,'%d %f %f %f %f %f\r\n', i, ...
    Body(i).r(1,1),Body(i).r(1,2),Body(i).theta(1), ...
    Body(i).PCoM,Body(i).Length);
end

% Store the data for the revolute joints
for k=1:NRevolute
    % Bodies i and j, connected by the revolute joint 
    i=JntRevolute(k).i;
    j=JntRevolute(k).j;
    
%     the absolute position of the local coordinates of the 
%     revolute joint with respect to the center of mass of 
%     the body i and j 
    fprintf(fid,'%d %d %d %f %f %f %f\r\n',k, i, j,...
        JntRevolute(k).spPi(1)*Body(i).Length,...
        JntRevolute(k).spPi(2)*Body(i).Length,...
        JntRevolute(k).spPj(1)*Body(j).Length,...
        JntRevolute(k).spPj(2)*Body(j).Length);
end

% Store the data for the driver joints
for k=1:NDriver
    fprintf(fid,'%d %d %d %d %d %d %d\r\n',k, JntDriver(k).type, ...
        JntDriver(k).i,JntDriver(k).coordi,JntDriver(k).j,...
        JntDriver(k).coordj,JntDriver(k).filename);
    
    dlmwrite([file,num2str(JntDriver(k).filename),'.txt'],...
        JntDriver(k).Data,'delimiter',' ','newline','pc');
end

fprintf(fid,'%f %f %f', 0.0,Data.Tstep,Data.Tend);

%end function
end