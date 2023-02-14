function climbercycle_pva(q,qd,qdd,t,samples)

%access global memory
global NBodies

bodies = ["Trunk","Neck","Right Arm","Right Forearm",...
    "Left Arm","Left Forearm","Right Thigh", ...
    "Right Leg","Rigth Foot","Right Toes","Left Thigh",...
    "Left Leg","Left Foot","Left Toes"];
j = 1; % index for accessing the body 

temporal_window = t(samples(1):samples(2)) - t(samples(1));
samples_window = samples(1):samples(2);

%Plots for the Position, Velocity and Acelleration of the bodies 
for k= 1:3:3*NBodies
    figure
    subplot(231)
    plot(temporal_window,q(k,samples_window)); xlabel('Time (s)'); title('Horizontal Displacement x [m]');
    axis tight 
    grid on
    subplot(232)
    plot(temporal_window,qd(k,samples_window)),xlabel('Time (s)'), title('Horizontal Velocity x [m/s]');
    axis tight
    grid on
    subplot(233)
    plot(temporal_window,qdd(k,samples_window)), xlabel('Time (s)'), title('Horizontal Acceleration x [m/s^2]');
    axis tight 
    grid on
    subplot(234)
    plot(temporal_window,q(k+1,samples_window)); xlabel('Time (s)'); title('Vertical Displacement z [m]');
    axis tight
    grid on
    subplot(235)
    plot(temporal_window,qd(k+1,samples_window)),xlabel('Time (s)'), title('Vertical velocity z [m/s]');
    axis tight 
    grid on
    subplot(236)
    plot(temporal_window,qdd(k+1,samples_window)), xlabel('Time (s)'), title('Vertical Acceleration z [m/s^2]');
    axis tight 
    grid on
    suptitle(bodies(j));
    j = j + 1;
end
end