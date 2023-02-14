function Plot_EMGcycles(timecycle, diff_cycles, EMGData, num_cycles, cycles,...
    half_cycle, initial_cycle, title_name,ylabel_name)

for i = initial_cycle:num_cycles
    indexes = cycles(i).complete(1):cycles(i).complete(2);
    EMGData_cycle(i).cycle  = EMGData(indexes,1);
end

end_time = max(diff_cycles);

hold on;
for k = initial_cycle:num_cycles 
    diff_length = end_time - diff_cycles(k);

    data_plot = EMGData_cycle(k).cycle;
    if diff_length > 0
        data_plot = [data_plot;....
            ones(diff_length,1)*data_plot(end,1)];
    end
    plot(timecycle, data_plot)
end

line(xlim,[0,0],'Color','k','LineStyle',':')
xline(timecycle(half_cycle),'--r');
title(title_name)
xlabel('% of Motion')
ylabel(ylabel_name)
end
            