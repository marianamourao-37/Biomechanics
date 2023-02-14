function ReadProcessingFile(ModelName) 
% This function reads the draft of the biomechanical model 

%Global memory data 
global NBody NRevolute NGround NDriver NFplates Body JntRevolute ...
    JntDriver FPlate 

% read the input file
H = dlmread(ModelName);

% Store the general dimensions of the system
NBody = H(1,1);
NRevolute = H(1,2);
NGround = H(1,3);
NDriver = H(1,4);
NFplates = H(1,5);

line = 1;

for i = 1:NBody
    line = line + 1;
    Body(i).pi = H(line,2);
    Body(i).pj = H(line, 3);
    Body(i).PCoM = H(line,4);
    Body(i).mass = H(line, 5);
    Body(i).rg = H(line, 6); % radius of gyration 
end 

% stores the data for the revolute joints 
for k = 1:NRevolute 
    line = line + 1;
    JntRevolute(k).i = H(line, 2);
    JntRevolute(k).j = H(line, 3);
    JntRevolute(k).spi = H(line, 4:5)';
    JntRevolute(k).spj = H(line, 6:7)';
end

% stores the data for the driver joints
for k = 1: NDriver 
    line = line + 1;
    JntDriver(k).type = H(line, 2);
    JntDriver(k).i = H(line, 3);
    JntDriver(k).coordi = H(line, 4);
    JntDriver(k).j = H(line, 5);
    JntDriver(k).coordj = H(line, 6);
    JntDriver(k).filename = H(line, 7);
end

% stores the data for the force plates 
for k = 1: NFplates
    line = line + 1;
    % bodies involved in the force plates and the local point that 
    % defines the transition between the foot and toes 
    FPlate(k).i = H(line, 2);
    FPlate(k).j = H(line, 3);
    FPlate(k).spi = H(line, 4:5)';
    FPlate(k).spj = H(line, 6:7)';
    FPlate(k).filename = H(line, 8);
end 

% end of funtion 
end 