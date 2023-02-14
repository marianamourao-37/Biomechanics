function [FilteredData,FinalCutOff] = FilterCoordinates(Data,fs)
% Function that filters the data (Data) using the cut off frequency 
% define by the a residual analysis

%Data = Data/1000; %meters

% range of cutoff frequencies (Hz)
CutOffRange = (0.1:0.1:0.15*fs);

% number of frequencies to test 
NFrequencies = length(CutOffRange);

% length of the data 
NData = length(Data);

% allocates memory for the residuals
Residual = zeros(NFrequencies,1);

% Filter the data for each of the frequencies, computing the 
% respective residual for the cutoff frequency considered, 
% by taking the root squared error of difference between the 
% filtered and unfiltered data
for i = 1:NFrequencies
    
    % cut off frequency, normalized by the nyquist frequency 
    wn = CutOffRange(i)/(fs/2); 
    
    % Butterworth parameters, designing a low-pass filter by default
    [b,a] = butter(2,wn);
    
    % Filtering of the data with a zero phase lag filter 
    FilteredData = filtfilt(b,a,Data);

    % Computation of the residual 
    Residual(i) = sqrt((sum((Data - FilteredData).^2))/NData);
end

%% Fits a line into the Residual(fc) plot, in order to find the cutoff frequency

min_corr = 0.92;

% Index data 
i = NFrequencies-1;
correlation = 1; % correlation

while (correlation^2 > min_corr && i>0)
    
    % Fits a line to the data 
    [correlation,~,b] = regression(CutOffRange(i:NFrequencies),...
        Residual(i:NFrequencies)');
    i = i - 1; 
end

% Computes the final cut-off frequency 
[~,index] = min(abs(Residual-b));
FinalCutOff = CutOffRange(index);

%% Final filtering, using the cutoff frequency determined 

% Note: The cutoff frequencies for a gait cycle are 
% expected to range between 2 and 6 Hz

% cut off frequency, normalized by the nyquist frequency 
wn = (2*FinalCutOff)/fs;

% Butterworth parameters, designing a low-pass filter by default 
[b,a]=butter(2,wn);

% Filtering of the data with a zero phase lag filter 
FilteredData = filtfilt(b,a,Data);

end