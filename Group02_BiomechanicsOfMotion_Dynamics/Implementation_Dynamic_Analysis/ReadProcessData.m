function LabData = ReadProcessData(File)
% Function that reads tsv files, which stores data regarding 
% the coordinates x,y,z of the bodies in the global reference 
% frame as a discretized function of time.

global file 

%global file 
%% Reads static data
fid = fopen(File);

% Reads the first line 
line = fgetl(fid);

% Line counter 
line_counter = 1;

% first lines give information regarding the acquisition system. 
% Reads the file until finding the tag Marker_Names
while (strcmpi(line(1:7),'Marker_') == 0)
    
    %Takes the sampling frequency from the file 
    if (strcmpi(line(1:8),'FREQUENC')==1)
        LabData.fs = sscanf(line, '%*s %d');
    end
    
    %Reads next line
    line = fgetl(fid);
    
    % Updates the line counter 
    line_counter = line_counter +1;
end

% Closes the file
fclose(fid);

% Reads the rest of the data, extracting the coordinates 
% x,y,z of the bodies in the global reference 
% frame as a discretized function of time
Coordinates = dlmread(File, '', line_counter+1, 2);

% cameras collect data in 3D. 
% Eliminates the third coordinate to project the data onto the 
% sagittal plane 
Coordinates(:,2:3:end)=[];

% Information regarding the time period of acquisition, 
% as well as the discretization of that period (Tstep)
Time = dlmread(File, '', [line_counter+1, 1, line_counter + size(Coordinates,1), 1]);

LabData.Tstep = Time(2) - Time(1);
LabData.Tend = Time(end) - Time(1);
LabData.Time = Time;

%% Filters the data 
% Number of coordinates 
Ncoord = size(Coordinates, 2);

% Allocates memory for the filtered data 
FilteredCoordinates = zeros(size(Coordinates));

CutOffFrequencies = zeros(Ncoord,1);

% Goes through all coordinates 
for i = 1:2:Ncoord  
    % Filtering data through the application of a 
    % Lowpass filter, being widely used to reduce noise 
    % levels in reconstructed trajectories. The method applied
    % for definying the cutoff frequency was the residual 
    % analysis

    [FilteredCoordinates(:,i), CutOffFrequencies(i,1)] = FilterCoordinates(Coordinates(:,i),...
        LabData.fs);
    
    [FilteredCoordinates(:,i+1), CutOffFrequencies(i+1,1)] = FilterCoordinates(Coordinates(:,i+1),...
    LabData.fs);

    % End of the loop that goes through all coordinates 
end

%Organize the data according to the definition of the biomechanical model.

%Definition of the biomechanical model is as follows:
% P1 - Head; P2 - Midpoint between shoulders; P3 - Right elbow;
% P4 - Right wrist; P5 - Left elbow; P6 - Left wrist;
% P7 - Midpoint between hips; P8 - Right knee; P9 - Right ankle;
% P10 - Right metatarsal; P11 - Right hallux; P12 - Left knee;
% P13 - Left ankle; P14 - Left metatarsal; P15 - Left hallux;

%Data from the lab is organized as follows:
% 1 - Head; 2 - Left shoulder; 3 - Left elbow; 
% 4 - Left wrist; 5 - Right shoulder; 6 - Right elbow;
% 7 - Right wrist; 8 - Left hip; 9 - Left knee; 
% 10 - Left ankle; 11 - Left heel; 12 - Left metatarsal_V;
% 13 - Left toe_II; 14 - Right hip; 15 - Right knee; 
% 16 - Right ankle; 17 - Right heel; 18 - Right metatarsal_V;
% 19 - Right toe_II;

LabData.Coordinates = [FilteredCoordinates(:,1:2),... %Head
   (FilteredCoordinates(:,3:4) + FilteredCoordinates(:,9:10))/2,...  %Midpoint between shoulders
    FilteredCoordinates(:,11:12),...   %Right elbow
    FilteredCoordinates(:,13:14),...   %Right wrist
    FilteredCoordinates(:,5:6),...     % Left elbow
    FilteredCoordinates(:,7:8),...     % Left Wrist
   (FilteredCoordinates(:,15:16) + FilteredCoordinates(:,27:28))/2,...     %Midpoint between hips 
    FilteredCoordinates(:,29:30),...   %Right knee
    FilteredCoordinates(:,31:32),...   %Right ankle
    FilteredCoordinates(:,35:36),...   %Right metatarsal
    FilteredCoordinates(:,37:38),...   %Right hallux
    FilteredCoordinates(:,17:18),...   %Left knee
    FilteredCoordinates(:,19:20),...   %Left ankle
    FilteredCoordinates(:,23:24),...   %Left metatarsal
    FilteredCoordinates(:,25:26)]*1e-3;     %Left hallux 

if ~strcmp(file,'static')
    LabData.CutOffFrequencies = CutOffFrequencies;
end

end