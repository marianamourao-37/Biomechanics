function PlotGroundReaction(time, fplate, bodyweight) 

global TotalBodyMass file num_cycles cycles
    
if strcmp(file,'gait')
    figure(2);
    subplot(211)
    hold on;
    plot(time,fplate(1).Data(:,2)/TotalBodyMass,'LineWidth',1.5);
    plot(time,fplate(2).Data(:,2)/TotalBodyMass,'LineWidth',1.5);
    plot(time,fplate(3).Data(:,2)/TotalBodyMass,'LineWidth',1.5);
    legend('Plate 1','Plate 2','Plate 3','location','southeast');
    title('Horizontal');
    xlabel('% of Motion'), ylabel ('N/kg'), axis tight;
    % ylim([-2 3])
    hold off

    figure(2);
    subplot(212);
    hold on;
    plot(time,fplate(1).Data(:,3)/TotalBodyMass,'LineWidth',1.5);
    plot(time,fplate(2).Data(:,3)/TotalBodyMass,'LineWidth',1.5);
    plot(time,fplate(3).Data(:,3)/TotalBodyMass,'LineWidth',1.5);
    plot(time,bodyweight);
    legend('Plate 1','Plate 2','Plate 3','B.W.','location','southeast');
    title('Vertical');
    xlabel('% of Motion'), ylabel ('N/kg'), axis tight;
    % ylim([0 12]);
    hold off;
else
    figure(2);
    subplot(211)
    plot(time,fplate(1).Data(:,2)/TotalBodyMass,'LineWidth',1.5);
    title('GRF Horizontal Component - Plate 1');
    xlabel('% of Motion'), ylabel ('N/kg'), axis tight;
    
    for j = 1:num_cycles
        xline(time(cycles(j).complete(1)),'--r');
        xline(time(cycles(j).complete(2)),'--r');
    end
    
    subplot(212)
    plot(time,fplate(1).Data(:,3)/TotalBodyMass,'LineWidth',1.5);
    title('GRF Vertical Component - Plate 1');
    xlabel('% of Motion'), ylabel ('N/kg'), axis tight;
    
    for j = 1:num_cycles
        xline(time(cycles(j).complete(1)),'--r');
        xline(time(cycles(j).complete(2)),'--r');
    end
    
    figure(3)
    subplot(211)    
    plot(time,fplate(3).Data(:,2)/TotalBodyMass,'LineWidth',1.5);
    title('GRF Horizontal Component - Plate3');
    xlabel('% of Motion'), ylabel ('N/kg'), axis tight;
    
    subplot(212)  
    plot(time,fplate(3).Data(:,3)/TotalBodyMass,'LineWidth',1.5);
    title('GRF Vertical Component - Plate 3');
    xlabel('% of Motion'), ylabel ('N/kg'), axis tight;    
end
end