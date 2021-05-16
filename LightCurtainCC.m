function [bool] = LightCurtainCC(bottle1, sphereCenter, radius)
% function isCollision = CheckCollision(robot, sphereCenter, radius)
radius = 0.1;

bottle = bottle1;
    steps = 1;
    pause(0.1);
%     bottle = bottle.model.getpos;
    bottlepos = bottle.bottle.base;
%     bottleToCenterDist = sqrt(sum( (sphereCenter - bottlepos(1:3,4)') .^2));
%     bottleToCenterDist = sqrt((bottlepos(1,4)^2)+(bottlepos(2,4)^2));

    bottle.pointsMat{1,1}

    pointMat;
    
    [r,c] = size(pointMat)
    
    for i = 1:steps:r
        X = pointMat(i,1); %- sphereCenter(1);
        Y = pointMat(i,2); %- sphereCenter(2);
        
        bottleToCenterDist = sqrt(((X).^2)+((Y).^2));
        
        if bottleToCenterDist <= radius
            disp('Object within Operation Safety Zone! Game Stopped');
    %         isCollision = 1;
            bool = 1;
        else
            disp('Object no longer in Operation Safety Zone! Continue');
    %         isCollision = 0;
            bool = 0;
        end
    end
end