% Function to transfer data from y to r, thet, r dot and theta dot 

function [q, qd] = y2q(y)

global NBodies Body NCoord

q = y(1:NCoord, 1);
qd = y(NCoord + 1:end, 1);

for i = 1:NBodies 
    % transfer data to local storage Body 
    
    i1 = 3*i-2;
    i2 = i1+1;
    i3=i2+1;
    
    Body(i).r = q(i1:i2, 1);
    Body(i).theta = q(i3,1);
    Body(i).rd = qd(i1:i2,1);
    Body(i).thetad = qd(i3,1);

    % Form the transformation matrix A and B 

    ctheta = cos(Body(i).theta);
    stheta = sin(Body(i).theta);

    Body(i).A = [ctheta -stheta; ...
                 stheta ctheta];
    Body(i).B = [-stheta -ctheta; ...
                 ctheta -stheta];
end

% Finish function y2q
end 
    
