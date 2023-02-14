function [] = Angles(q,t)
% Function that plots the angle theta_ij(t) of driver joints of type 3

%access global memory
global NDriver JntDriver file 

% driver joints of type 3 
joints = ["neck joint", "right shoulder", "right elbow", "left shoulder",...
        "left elbow", "right hip", "right knee", "right ankle", "right metatarsal", ...
        "left hip","left knee","left ankle","left metatarsal"];

if strcmp(file,'gait')    
    x_axis = (t/t(end))*100; % conversion of time to percentage of stride
    x_legend = '% of Stride';
else
    x_axis = t;
    x_legend = 'Time (s)';
end
% plots the angles for the drivers of type 3, being the first 13 
% of the 16 drivers existing in the model

for i = 1:(NDriver-3)
    if strcmp(file,'gait') 
        angle_joint = (q(3*JntDriver(i).j,:) - q(3*JntDriver(i).i,:))*180/pi;
        if i == 8
            angle_joint = angle_joint - 65;
        elseif i == 7
            angle_joint = angle_joint + 8;
        end 
    else
        angle_joint = (q(3*JntDriver(i).j,:) - q(3*JntDriver(i).i,:))*180/pi;
    end
    
    figure
    legend = joints(1,i);
    hold on 
    plot(x_axis,angle_joint); % angle theta_ij, in degrees
    xlabel(x_legend);
    ylabel('Theta (deg)');
    title(['Angle of ', legend, ' joint']);
    axis tight
    grid on 
    hold off
end
end