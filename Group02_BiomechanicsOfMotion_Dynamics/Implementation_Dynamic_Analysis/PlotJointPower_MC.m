function PlotJointPower_MC(t,time_MC, g_Driver, body_joints, joints_driver,legend_name_r)

global num_cycles cycles half_mean diff_cycles ...
    JntDriver initial_cycle

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
            indexes = cycles(k).complete(1):cycles(k).complete(2);

            data_plot = g_Driver(3*bodyi,:,i)'.*...
                ppval(JntDriver(i).splined,t);

            data_plot = data_plot(indexes,1);

            if diff_length > 0
                data_plot = [data_plot;....
                    ones(diff_length,1)*data_plot(end,1)];
            end
            plot(time_MC, data_plot)
        end
    else
        for k = initial_cycle:num_cycles 
            diff_length = end_time - diff_cycles(k);
            indexes = cycles(k).complete(1):cycles(k).complete(2);

            data_plot = -g_Driver(3*bodyi,:,i)'.*...
                ppval(JntDriver(i).splined,t);

            data_plot = data_plot(indexes,1);

            if diff_length > 0
                data_plot = [data_plot;....
                    ones(diff_length,1)*data_plot(end,1)];
            end
            plot(time_MC, data_plot)
        end
    end
    xlabel('% of Motion'),
    ylabel('Power(W/kg)'), axis tight;
    title([legend_name,'Joint Power'])
    line(xlim,[0,0],'Color','k','LineStyle',':')
    xline(time_MC(half_mean),'--r');
end
legend(legend_name_r);
hold off;
end

