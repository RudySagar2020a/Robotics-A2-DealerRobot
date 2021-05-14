%%Return to Home

function [] = return2Home(robot1)
robot = robot1;

q = robot.model.getpos;
steps = 50;
traj = jtraj(q,zeros(1,6),steps);
for i=1:steps
    q = traj(i,:);
        while robot.eStop == 1
            pause(1);
        end
    animate(robot.model,q);
    pause(.05);
end
end