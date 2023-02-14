function Animate(t)

global Body NBodies 

newplot;axis([-1 2 -0.1 2]); axis square;

%Draw the model for every time step
for time = t
    cla(gca);
    hold on

    % Plot for each body
    for i = 1:NBodies
        plot([Body(i).pProx(1,time) Body(i).pDist(1,time)],...
             [Body(i).pProx(2,time) Body(i).pDist(2,time)],...
            '-o','MarkerSize',5,'MarkerFaceColor','g','MarkerEdgeColor','g');

    end
        
    textBox = uicontrol('style','text');
    set(textBox,'String',['Step: ' num2str(time)]);
    set(textBox,'Position',[140 320 60 30]);
    hold off; pause(0.01);

end
end