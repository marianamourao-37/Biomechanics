function PlotJointPower(t, time, g_Driver, body_joints, joints_driver)

global JntDriver file cycles num_cycles
figure();
hold on
for i= 6:8
    subplot(3,1,i-5)
    legend_name = joints_driver(1,i);
    bodyi = body_joints(i,1);

    if strcmp(file,'gait')
        if i ==7
            plot(time,g_Driver(3*bodyi,:,i)'.* ppval(JntDriver(i).splined,t),'LineWidth',1.5)
        else
            plot(time,-g_Driver(3*bodyi,:,i)'.* ppval(JntDriver(i).splined,t),'LineWidth',1.5)
        end
    else
        if i ==7
            plot(time,g_Driver(3*bodyi,:,i)'.* ppval(JntDriver(i).splined,t),'LineWidth',1.5)
        else
            plot(time,-g_Driver(3*bodyi,:,i)'.* ppval(JntDriver(i).splined,t),'LineWidth',1.5)
        end
        
        for j = 1:num_cycles
            xline(time(cycles(j).complete(1)),'--r','HandleVisibility','off');
            xline(time(cycles(j).complete(2)),'--r','HandleVisibility','off');
        end    
    end
    xlabel('% of Motion'),
    ylabel('Power(W/kg)'), axis tight;
    title([legend_name,'Joint Power'])  
    line(xlim,[0,0],'Color','k','LineStyle',':')
end
hold off;

end