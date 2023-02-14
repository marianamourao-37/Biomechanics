function Plot_Positions(t,title_text)
% Function that plots sequential positions for given body 
% parts, at a specified time rate 

%access global memory
global Body NBodies

figure;

right = [10,9,8,7,3,4]; % bodies of the right side of the model considered 

for time = t
    hold on
    for b = 1:NBodies
        if ismember(b,right)
            plot([Body(b).pProx(1,time) Body(b).pDist(1,time)],...
             [Body(b).pProx(2,time) Body(b).pDist(2,time)],...
            'g-');
        else
            plot([Body(b).pProx(1,time) Body(b).pDist(1,time)],...
             [Body(b).pProx(2,time) Body(b).pDist(2,time)],...
            'b-');
        end
    end
end
xlabel('X axis [m]');
ylabel('Z axis [m]');
title(title_text);
end