function [bool] = LightCurtainCC(bottle1)
% function isCollision = CheckCollision(robot, sphereCenter, radius)
radius = 0.7;
sphereCenter = transl(0,0,.95);
bottle = bottle1;
    steps = 1;
    pause(0.1);
%     bottle = bottle.model.getpos;
    bottlepos = bottle.bottle.base*transl(0,0,0.08);
%     bottleToCenterDist = sqrt(sum( (sphereCenter - bottlepos(1:3,4)') .^2));
%     bottleToCenterDist = sqrt((bottlepos(1,4)^2)+(bottlepos(2,4)^2));
    dist = sqrt((sphereCenter(1,4)-bottlepos(1,4))^2+(sphereCenter(2,4)-bottlepos(2,4))^2+(sphereCenter(3,4)-bottlepos(3,4))^2)+-radius;
        if dist <=0 
        bool = 1;
%         disp('Object within Operation Safety Zone! Game Stopped');
%     %         isCollision = 1;
            bool = 1;
            return
        else
%             disp('Operational Safety Zone Clear! Continue');
    %         isCollision = 0;
            bool = 0;
        end
    end
