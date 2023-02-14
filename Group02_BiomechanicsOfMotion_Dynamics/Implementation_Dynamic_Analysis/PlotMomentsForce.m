function PlotMomentsForce(time, gDriver, body_joints, joints_driver)

global cycles num_cycles file

if strcmp(file,'gait')
    body1 = body_joints(6,1);
    body7 = body_joints(7,1);
    body8 = body_joints(8,1);
    m_winter = gDriver(3*body1,:,6) - gDriver(3*body7,:,7) + gDriver(3*body8,:,8);

    figure();
    hold on
    subplot(4,1,1)
    plot(time,m_winter,'LineWidth',1.5);
    xlabel('% of Motion');
    ylabel('[N.m/Kg]'), axis tight;
    title(sprintf('Support'));
    line(xlim,[0,0],'Color','k','LineStyle',':')

    for i= 6:8
        subplot(4,1,i-4)
        legend_name = joints_driver(1,i);
        bodyi = body_joints(i,1);
        if i ==7
            plot(time,-gDriver(3*bodyi,:,i),'LineWidth',1.5)
        else
            plot(time,gDriver(3*bodyi,:,i),'LineWidth',1.5)
        end
        xlabel('% of Motion'),
        ylabel('[N.m/Kg]'), axis tight;
        title([legend_name,' driver']);
        line(xlim,[0,0],'Color','k','LineStyle',':')
    end
    hold off;
else
    figure();
    for i= 6:8
        subplot(3,1,i-5)
        legend_name = joints_driver(1,i);
        bodyi = body_joints(i,1);
        if i ==7
            plot(time,-gDriver(3*bodyi,:,i),'LineWidth',1.5)
        else
            plot(time,gDriver(3*bodyi,:,i),'LineWidth',1.5)
        end
        xlabel('% of Motion'),
        ylabel('[N.m/Kg]'), axis tight;
        title(['Joint Moment in', legend_name])
        line(xlim,[0,0],'Color','k','LineStyle',':')

        for j = 1:num_cycles
            xline(time(cycles(j).complete(1)),'--r');
            xline(time(cycles(j).complete(2)),'--r');
        end

    end
    hold off
end
end