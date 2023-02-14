function g = ForcePlates(g, time)
% this function reads the data form the force plates and applies
% the force onto the corresponding bodies 

% memory access to data 
global Body FPlate NFplates file

% goes through all force plates 
for k = 1:NFplates 
    if ~(strcmp(file,'mountain_climber') && k == 2)
        % defines the center of pressure and the forces in the global
        % reference frama 
        GRF = [ppval(FPlate(k).spline(1), time); ...
            ppval(FPlate(k).spline(2), time)];
        CoP = [ppval(FPlate(k).spline(3), time); ...
            ppval(FPlate(k).spline(4), time)];

        % bodies that may contact the force plate 
        i = FPlate(k).i;
        j = FPlate(k).j;

        % global coordinates of the point that separates the 
        % two bodies 
        BodySeparationPos = Body(i).r(1,1) + Body(i).A * FPlate(k).spi;
    end

    % if the x position of the cop is smaller than the x position of the
    % BodySeparationPos, then the force is to be applied on the foot.
    % otherwise, it is to be applied on the phalanges 
    if (CoP(1) < BodySeparationPos(1))
        % defines the coordinates of the CoP with respect to the center of
        % mass of the body 
        spi =  CoP - Body(i).r;
        
        % application of the force on the foot (body i) 
        
        g=ApplyForce(i,g,GRF, spi);
    else
        %defines the coordinates of the CoP with respect to the center of
        %mass of the body 
        spj = CoP - Body(j).r;
        
        g = ApplyForce(j,g, GRF, spj);
    end
end
end       