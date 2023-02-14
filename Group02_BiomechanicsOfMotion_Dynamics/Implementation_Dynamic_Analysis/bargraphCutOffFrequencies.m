function bargraphCutOffFrequencies()

markernames = {'Head','Left shoulder','Left elbow','Left wrist',...
    'Right shoulder','Right elbow','Right wrist','Left hip','Left knee',...
    'Left ankle','Left heel','Left metatarsal V','Left toe II','Right hip',...
    'Right knee','Right ankle','Right heel','Right metatarsal V','Right toe II'};

freq_mountainclimber = dlmread('CuttOffFrequencies_mountain_climber.txt');
freq_gait = dlmread('CuttOffFrequencies_gait.txt');

freqs = zeros(4,length(markernames));

t = 1;
for i = 1:2:length(freq_mountainclimber)
    freqs(1:2,t) = freq_gait(i:i+1,1);
    freqs(3:4,t) = freq_mountainclimber(i:i+1,1);
    t = t+1;
end

grahbar = bar(reordercats(categorical(markernames),markernames),freqs);

set(grahbar, {'DisplayName'}, {'Gait x','Gait z','Mountain Climber x', 'Mountain Climber z'}');
legend();
ylabel('Cut off Frequency (Hz)');
end







