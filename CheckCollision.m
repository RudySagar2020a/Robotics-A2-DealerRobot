function [bool] = CheckCollision(robot, sphereCenter, radius)
% function isCollision = CheckCollision(robot, sphereCenter, radius)

    pause(0.1)
    tr = robot.fkine(robot.getpos);
    endEffectorToCenterDist = sqrt(sum((sphereCenter-tr(1:3,4)').^2));
    if endEffectorToCenterDist <= radius
        disp('Object within Operation Safety Zone! Game Stopped');
%         isCollision = 1;
        bool = 1;
    else
        disp(['Object no longer in Operation Safety Zone! Continue (',...
            num2str(endEffectorToCenterDist), 'm) is more than the sphere radius, '...
            num2str(radius), 'm']);
%         isCollision = 0;
        bool = 0;
    end

end