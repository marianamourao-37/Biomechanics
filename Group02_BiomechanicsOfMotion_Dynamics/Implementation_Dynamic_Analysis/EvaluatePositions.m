function EvaluatePositions()
%This function defines the position and orientation of the bodies for all
%frames

%global memory data
global NBody Body Data

%number of frames to evaluate 
NFrames = size(Data.Coordinates,1);

for i=1:NBody
    
    %Allocates memory for the positions and angles
    Body(i).r=zeros(NFrames,2);
    Body(i).theta=zeros(NFrames,1);
    
    %Goes through all frames 
    for j = 1:NFrames
      
      %Position of the coordinates for points Pi and Pj (in data matrix)
      Pi = 2*(Body(i).pi - 1) + 1;
      Pj = 2*(Body(i).pj - 1) + 1;
      
      %Direction of the local csi axis
      Csi=(Data.Coordinates(j,Pj:Pj+1)-Data.Coordinates(j,Pi:Pi+1))'/...
          norm(Data.Coordinates(j,Pj:Pj+1)-Data.Coordinates(j,Pi:Pi+1));
      
      % Note: because we are in 2D, eta axis is perpendicular 
      % to the csi axis, being obtained by rotating 90º 
      % about the axis perpendicular to the plane
      
      % Updates the position of the center of mass from the proximal point 
      Body(i).r(j,:)=Data.Coordinates(j,Pi:Pi+1)'+Body(i).PCoM* ...
          Body(i).Length*Csi;
      
      %Updates the orientation of the body 
      if (Csi(2)>0)
          Body(i).theta(j)=acos(Csi(1));
      else
          Body(i).theta(j)=2*pi-acos(Csi(1));
      end
      
      %End the loop that goes through all frames
    end
    
    % To ensure continuity of the angles, the unwrap 
    % function is applied
    Body(i).theta=unwrap(Body(i).theta);

    %End the loop that goes through all bodies   
end

%End of fuction

end
