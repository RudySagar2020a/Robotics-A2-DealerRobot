%% Demonstration Code for LightCurtain

% When an object enters Operation Safety Zone, operation of the game and
% robot movement will cease immediately upon object detection


% TRANSLATION CODE GOES HERE.......



% LIGHT CURTAIN-------------------------------------------
% Create sphere
sphereCenter = [0,0,0.95];
radius = 0.7;
[X,Y,Z] = sphere(20);
X = X * radius + sphereCenter(1);
Y = Y * radius + sphereCenter(2);
Z = Z * radius + sphereCenter(3);

% Plot it
% Plot point cloud
points = [X(:),Y(:),Z(:)];
spherePc_h = plot3(points(:,1),points(:,2),points(:,3),'r.');
pause
delete (spherePc_h)

if i = 1:steps
% CheckCollision(robot,sphereCenter,radius);
% if CheckCollision(robot,sphereCenter,radius) == 1
%     disp('UNSAFE: Robot stopped')
%     break;
% end
end