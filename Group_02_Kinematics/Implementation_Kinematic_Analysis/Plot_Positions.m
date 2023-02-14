function Plot_Positions(t,title_text)
% Function that plots sequential positions for given body 
% parts, at a specified time rate 

%access global memory
global Body NBodies

figure;

for time = t
    hold on
    for i = 1:NBodies
        plot([Body(i).pProx(1,time) Body(i).pDist(1,time)],...
             [Body(i).pProx(2,time) Body(i).pDist(2,time)],...
            '-o','MarkerSize',5,'MarkerFaceColor','g','MarkerEdgeColor','g');
    end
end
xlabel('X axis [m]');
ylabel('Z axis [m]');
title(title_text);
end