function [] = climbercycle_angles(q,t,samples)
% Function that plots the angle theta_ij(t) of driver joints of type 3

%access global memory
global NDriver JntDriver

% driver joints of type 3 
joints = ["neck joint", "right shoulder", "right elbow", "left shoulder",...
        "left elbow", "right hip", "right knee", "right ankle", "right metatarsal", ...
        "left hip","left knee","left ankle","left metatarsal"];

temporal_window = t(samples(1):samples(2)) - t(samples(1));

% plots the angles for the drivers of type 3, being the first 13 
% of the 16 drivers existing in the model 
for i = 1:(NDriver-3)
    angle_joint = (q(3*JntDriver(i).j,samples(1):samples(2)) ...
        - q(3*JntDriver(i).i, samples(1):samples(2)))*180/pi;
    
    figure
    legend = joints(1,i);
    hold on 
    plot(temporal_window,angle_joint); % angle theta_ij, in degrees
    xlabel('Time (s)');
    ylabel('Theta (deg)');
    title(['Angle of ', legend, ' joint']);
    axis tight
    grid on 
    hold off
end
end