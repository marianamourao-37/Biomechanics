function ReadDraftInput(file_name)
% Function that reads the draft of the Biomechanical Model,
% with name of the file specified by file_name, being in the 
% same directory as the program. The file has a similar 
% structure as that of the input file of the kinematics code
% to be written. 

%Global Memory data
global Body NBodies NRevolute NGround ...
    NDriver JntRevolute JntDriver

%Read the content of input file
H=dlmread(file_name);

%store general dimensions of the system
NBodies=H(1,1);
NRevolute=H(1,2);
NGround=H(1,3);
NDriver=H(1,4);

% initializes the line of the input file to be accessed
line=1;

%store the data for the rigid bodies information
for i=1:NBodies
    line=line+1; % increments the line of the input file to be accessed
    Body(i).pi=H(line,2); % proximal point 
    Body(i).pj=H(line,3); % distal point
    Body(i).PCoM=H(line,4); % csi position of the center 
                            % of mass normalized by the segment 
                            % length, with respect to the 
                            % proximal point (anthropometry data)
   % Note: to define the position of the center of mass (CoM) it's 
   % needed the csi and eta axis, but the anthropometry data 
   % considers that the CoM is aligned with the proximal and 
   % distal point, so the eta component of the local reference 
   % frame is considered 0.
end

%store the data for revolute joints
for k=1:NRevolute
    line=line+1; % increments the line of the input file to be accessed
    % bodies connected by the revolute joint:
    JntRevolute(k).i = H(line,2); 
    JntRevolute(k).j = H(line,3); 
    
    % local coordinates of the revolute joint 
    % with respect to the CoM of the body i and j, 
    % normalized by the length of the segment 
    % (anthropometry tables):
    JntRevolute(k).spPi= H(line,4:5)'; 
    JntRevolute(k).spPj= H(line,6:7)'; 
end

%store the data for the drivers
for k=1:NDriver
    line=line+1; % increments the line of the input file to be accessed
    JntDriver(k).type= H(line,2); % type of driver 
    
    % bodies that define the driver  
    JntDriver(k).i= H(line,3); 
    JntDriver(k).j= H(line,5); 
    
    % number of the coordinate driven (1-x, 2-z or 3-theta)
    JntDriver(k).coordi=H(line,4);  
    JntDriver(k).coordj=H(line,6); 
    
    % name of the file, in which is going to be stored the 
    % variation of the degree of freedom that is being guided
    % (2nd column) with time (first column)
    JntDriver(k).filename=H(line,7); 
end

%End of function
end