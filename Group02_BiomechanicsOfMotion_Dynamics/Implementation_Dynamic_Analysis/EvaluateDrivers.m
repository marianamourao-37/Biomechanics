function EvaluateDrivers()
%This function defines the variation of the degrees of freedom that drive
%the system

%Global memory data
global NDriver Body JntDriver Data

%Number of frames to evaluate
NFrames=size(Data.Coordinates,1);

% Time frame
Time = 0:1/Data.fs:(NFrames-1)/Data.fs;

for i= 1 : NDriver
    
    % Allocates memory for the dof
    Dof = zeros(NFrames, 1);
    
    % Goes through all frames
    for j = 1 : NFrames
        
        if (JntDriver(i).type == 1)
            %Body to drive
            Bodyi = JntDriver(i).i;
            
            % The type 1 driver is a trajectory driver that guides the
            % position or orientation of the body
            if (JntDriver(i).coordi == 1)
                Dof(j) = Body(Bodyi).r(j,1);
            elseif (JntDriver(i).coordi == 2)
                Dof(j) = Body(Bodyi).r(j,2);
            else 
                Dof(j) = Body(Bodyi).theta(j);
            end
        elseif (JntDriver(i).type == 3)
            
            %Body i and j
            Bodyi = JntDriver(i).i;
            Bodyj = JntDriver(i).j;
            
            %Updates the dof, according to the definition of the driver
            Dof(j) = Body(Bodyj).theta(j)-Body(Bodyi).theta(j);
        end 
        
        %End of the loop that goes through all frames
    end 
    
    %Update the result 
    JntDriver(i).Data= [Time', Dof];

    % End of the loop that goes through all bodies   
end 
%End of function
end
            