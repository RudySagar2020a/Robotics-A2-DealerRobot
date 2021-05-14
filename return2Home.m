%%Return to Home

function [] = return2Home(robot)
q = robot.model.getpos
steps = 50;
traj = jtraj(q,zeros(1,6),steps);
for i=1:steps
    q = traj(i,:);
    animate(robot.model,q);
    pause(.05);
end
end