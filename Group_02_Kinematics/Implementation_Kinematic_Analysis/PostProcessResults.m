function PostProcessResults(q,qd,qdd,t)

%access global memory
global NBodies file

bodies = ["Trunk","Neck","Right Arm","Right Forearm",...
    "Left Arm","Left Forearm","Right Thigh", ...
    "Right Leg","Rigth Foot","Right Toes","Left Thigh",...
    "Left Leg","Left Foot","Left Toes"];
j = 1; % index for accessing the body 

if strcmp(file,'gait')    
    x_axis = (t/t(end))*100; % conversion of time to percentage of stride
    x_legend = '% of Stride';
else
    x_axis = t;
    x_legend = 'Time (s)';
end

%Plots for the Position, Velocity and Acelleration of the bodies 
for k= 1:3:3*NBodies
    figure
    subplot(231)
    plot(x_axis,q(k,:)); xlabel(x_legend); title('Horizontal Displacement x [m]');
    axis tight 
    grid on
    subplot(232)
    plot(x_axis,qd(k,:)),xlabel(x_legend), title('Horizontal Velocity x [m/s]');
    axis tight
    grid on
    subplot(233)
    plot(x_axis,qdd(k,:)), xlabel(x_legend), title('Horizontal Acceleration x [m/s^2]');
    axis tight 
    grid on
    subplot(234)
    plot(x_axis,q(k+1,:)); xlabel(x_legend); title('Vertical Displacement z [m]');
    axis tight
    grid on
    subplot(235)
    plot(x_axis,qd(k+1,:)),xlabel(x_legend), title('Vertical velocity z [m/s]');
    axis tight 
    grid on
    subplot(236)
    plot(x_axis,qdd(k+1,:)), xlabel(x_legend), title('Vertical Acceleration z [m/s^2]');
    axis tight 
    grid on
    suptitle(bodies(j));
    j = j + 1;
end

%finish function PostProcessData
end