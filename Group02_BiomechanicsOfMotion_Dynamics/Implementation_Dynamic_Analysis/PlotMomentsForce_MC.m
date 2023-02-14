function PlotMomentsForce_MC(time_MC, g_Driver, body_joints, joints_driver,legend_name_r)

global num_cycles cycles half_mean diff_cycles initial_cycle

for i = initial_cycle:num_cycles
    indexes = cycles(i).complete(1):cycles(i).complete(2);
    gDriver(i).cycle  = g_Driver(:,indexes,:);
end

end_time = max(diff_cycles);

figure();
for i= 6:8
    subplot(3,1,i-5)
    legend_name = joints_driver(1,i);
    bodyi = body_joints(i,1);
    hold on;
    if i ==7
        for k = initial_cycle:num_cycles 
            diff_length = end_time - diff_cycles(k);

            data_plot = -gDriver(k).cycle(3*bodyi,:,i)';
            if diff_length > 0
                data_plot = [data_plot;....
                    ones(diff_length,1)*data_plot(end,1)];
            end
            plot(time_MC, data_plot)
        end
    else
        for k = initial_cycle:num_cycles 
            diff_length = end_time - diff_cycles(k);

            data_plot = gDriver(k).cycle(3*bodyi,:,i)';

            if diff_length > 0
                data_plot = [data_plot;....
                    ones(diff_length,1)*data_plot(end,1)];
            end
            plot(time_MC, data_plot)
        end
    end
    xlabel('% of Motion'),
    ylabel('[N.m/Kg]'), axis tight;
    title(['Joint Moment in', legend_name])
    line(xlim,[0,0],'Color','k','LineStyle',':')
    xline(time_MC(half_mean),'--r');
end
legend(legend_name_r);
hold off;

end