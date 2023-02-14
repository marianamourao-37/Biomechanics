function FilteredData = DoublePassLPFilter(Data, CutOff, SamplingFrequency)

% cut off frequency 
Wn = (2*CutOff)/SamplingFrequency;

% Butterworth parameters 
[Ab, Bb] = butter(2, Wn, 'low');

% filtering of the data with a zero phase lag filter 
FilteredData = filtfilt(Ab, Bb, Data);

% end of function 
end 