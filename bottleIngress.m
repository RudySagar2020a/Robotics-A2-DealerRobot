%% Demonstration Code for LightCurtain

% When an object enters Operation Safety Zone, operation of the game and
% robot movement will cease immediately upon object detection

function [] = bottleIngress(robot,Jack,bottle)
% robot = Kinova;
% bottle = bottle;
steps = 20;
q = [0 0 -pi/2 pi/2 -pi/2 0];
animate(robot.model,q);
% LIGHT CURTAIN-------------------------------------------
% Create sphere
sphereCenter = [0,0,0.95];
radius = 0.65;
[X,Y,Z] = sphere(50);
X = X * radius + sphereCenter(1);
Y = Y * radius + sphereCenter(2);
Z = Z * radius + sphereCenter(3);

% Plot it
% Plot point cloud
points = [X(:),Y(:),Z(:)];
spherePc_h = plot3(points(:,1),points(:,2),points(:,3),'r.');
% 
% circleCenter = [0,0,0.95];
% radius = 0.7;
% 
% [X,Y,Z] = sphere(200);
% X = X * radius + sphereCenter(1);
% Y = Y * radius + sphereCenter(2);
% Z = Z * radius + sphereCenter(3);

for i = 1:steps
    Jack.model.base = Jack.model.base * trotz(deg2rad(45)/steps);
    animate(Jack.model,0);
    if robot.eStop == 0
        q(1) = q(1)+deg2rad(5);
        animate(robot.model,q);
    end
    pause(0.03);
end

for i = 1:steps
    bottle.bottle.base = bottle.bottle.base*transl(0,-.1*tan(deg2rad(4.5)),0)*trotx(deg2rad(4.5));
    LightCurtainCC(bottle); %(robot,...)
    if LightCurtainCC(bottle) == 1 %(robot,...)
        disp('Please remove object from Operation Zone');
        robot.eStop = 1;
    else robot.eStop = 0;
        disp('Area Cleared. Resuming')
    end
    animate(bottle.bottle,0);
    if robot.eStop == 0
        q(1) = q(1)+deg2rad(5);
        animate(robot.model,q);
    end
    pause(0.03);
end

pause(3);

for i = 1:steps
    LightCurtainCC(bottle); %(robot,...)
    if LightCurtainCC(bottle) == 1 %(robot,...)
        disp('Please remove object from Operation Zone');
        robot.eStop = 1;
    else robot.eStop = 0;
        disp('Area Cleared. Resuming');
    end
    Jack.model.base = Jack.model.base * trotz(-deg2rad(45)/steps);
    animate(Jack.model,0);
    bottle.bottle.base = bottle.bottle.base * trotx(-deg2rad(4.5))*transl(0,.1*tan(deg2rad(4.5)),0);
    animate(bottle.bottle,0);
    if robot.eStop == 0
        q(1) = q(1)+deg2rad(5);
        animate(robot.model,q);
    end
    pause(0.05);
end

end