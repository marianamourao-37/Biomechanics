function ProcessedData = FilterForcePlateData(ProcessedData, SamplingFrequency,plate)

% considering only the vertical component of the force, i will estimate the
% instants of time in which contact existed by finding the time steps for
% which the force was larger than 5 N 
% ContactTimeSteps = find(ProcessedData(:,2) > 5);
% ContactIndices = (ProcessedData(:,2) > 5);
ContactTimeSteps = find(ProcessedData(:,2) > 7);
ContactIndices = (ProcessedData(:,2) > 7);

label = ['X', 'Z'];

% Filters the forces 
for j = 1:2 
    
    % Filters the force data using a low pass filter with a cut off
    % frequency of 20 Hz 
%     FilteredData = DoublePassLPFilter(ProcessedData(:,j),...
%         20, SamplingFrequency);
    RawData = ProcessedData(:,j);
    
    FilteredData = FilterCoordinates(RawData,SamplingFrequency);
    
    ProcessedFileterdData = FilteredData;
    % the instants of time for which no contact existed will be assigned a
    % 0 N force 
    ProcessedFileterdData(~ContactIndices) = 0;
    
    % Update the output 
    ProcessedData(:,j) = ProcessedFileterdData;
    
    figure();
    hold on;
    plot(RawData); 
    plot(FilteredData); 
    plot(ProcessedFileterdData); 
    legend('Raw', 'Filtered', 'Processed');
    xlabel('Frames');
    ylabel('Force (N)');
    title(['Ground Reaction Force in Plate ', num2str(plate), ' - ', label(j), ' Component']); 
    hold off;
end

% Filters the center of pressure 
for j = 3:4 
    
    % before filtering, the position of the center of pressure imediately
    % before and after contact will be put at those positons to diminish
    % the impact of the filter adaptation 
    RawCoP = ProcessedData(:,j);
    FilteredData_RawCoP = DoublePassLPFilter(RawCoP, 10 , SamplingFrequency);
    
    ProcessedRawCoP = RawCoP;
    if (ContactTimeSteps(1)>1)
        % puts the position for all time steps before equal to the position
        % of the first contact 
        ProcessedRawCoP(1:ContactTimeSteps(1)-1)=ProcessedRawCoP(ContactTimeSteps(1));
    end 
    
    if (ContactTimeSteps(end) < length(ProcessedRawCoP))
        % puts the position for all time steps after contact equal to the
        % position of the last contact 
        ProcessedRawCoP(ContactTimeSteps(end) + 1:end) = ProcessedRawCoP(ContactTimeSteps(end));
    end
    
    % filters the center of pressure using a low pass filter with a cut off
    % frequency of 10 Hz 
    ProcessedData(:,j) = DoublePassLPFilter(ProcessedRawCoP, 10 , SamplingFrequency);
    
    % Plots of the results 
    figure();
    hold on;
    plot(RawCoP); 
    plot(ProcessedRawCoP); 
    plot(FilteredData_RawCoP); 
    plot(ProcessedData(:,j)); 
    legend('Raw', 'Processed', 'Filtered', 'Processed and Filtered');
    xlabel('Frames');
    ylabel('CoP (m)');
    title(['Center of Pressure in Plate ', num2str(plate), ' - ', label(j-2), ' Component']);
    hold off;
    axis tight;
end

% end of function 
end 