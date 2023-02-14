function ReadGRF()
% this function reads and filters the data from the force plates 

% access global memory 
global FPlate file Data

SamplingFrequency = Data.fs;

% transforms the data from the local reference frame of the force plates
% to the global reference frame of the laboratory. The output includes the
% magnitude of the forces in x, y and z, and the position of the center of
% pressure in x, y and z. 
[fp1, fp2, fp3] = tsv2mat(0,0,0);

% time frame 
Time = 0:1/SamplingFrequency:(size(fp1,1)-1)/SamplingFrequency;
       
% saves the data into a struture 
RawData(1).fp = fp1;
RawData(2).fp = fp2;
RawData(3).fp = fp3;

% goes through all forces and processes the results 
for i = 1:3 
    if ~(strcmp(file,'mountain_climber') && i == 2)
        % saves only the data relevant for the 2D analysis. the data eliminated
        % for the positions is eliminated here as well 
        FPData = [RawData(i).fp(:,1), RawData(i).fp(:,3),...
            RawData(i).fp(:,4)*1e-3, RawData(i).fp(:,6)*1e-3]; 
        % for each force plate, it saves: the component x, z of the force;
        % the center of pressure x and z, transfromando-se mm em em metros 

        % filters the data 
        FilteredFPData = FilterForcePlateData(FPData, SamplingFrequency,i);
        
    if strcmp(file,'mountain_climber')
        indexes = Data.indexes_rh(1):Data.indexes_lh(end);
        %saves the data in an output structure 
        FPlate(i).Data = [Time(indexes)', FilteredFPData(indexes,:)];
    else
        FPlate(i).Data = [Time', FilteredFPData];
    end
        % end of the loop that goes through all force plates 
    end
end 

% end of function 
end 
    