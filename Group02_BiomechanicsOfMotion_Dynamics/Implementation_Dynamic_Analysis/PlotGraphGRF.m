function PlotGraphGRF(grf_data, time_i, name_title)

global cycles TotalBodyMass num_cycles diff_cycles half_mean initial_cycle
hold on;

end_time = max(diff_cycles);

for i = initial_cycle:num_cycles
    diff_length = end_time - diff_cycles(i);
    indexes = cycles(i).complete(1):cycles(i).complete(2);
    last_value = cycles(i).complete(2);
    
    if diff_length > 0            
        grf_data_cycle = [grf_data(indexes);ones(diff_length,1)*grf_data(last_value,1)];
    else
        grf_data_cycle = grf_data(indexes);
    end
    plot(time_i,grf_data_cycle/TotalBodyMass);
end

xline(time_i(half_mean),'--r');
title(name_title);
xlabel('% of Motion'), ylabel ('N/kg'), axis tight;
hold off;
end