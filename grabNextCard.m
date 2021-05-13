%%Grab Next Card
function [q] = grabNextCard(robot,cards,cardNum)

nextCardApproachTr = transl(-0.4,0,1)*trotz(pi/2)*trotx(-pi/2);

q = robot.model.getpos;
nextq = robot.model.ikcon(nextCardApproachTr,zeros(1,6));
steps = 50;
traj = jtraj(q,nextq,steps);
for i=1:steps
    q = traj(i,:);
    animate(robot.model,q);
    pause(.05);
end
nextq = robot.model.ikcon(cards.card{cardNum}.base,q);
steps = 20;
traj = jtraj(q,nextq,steps);
for i=1:steps
    q = traj(i,:);
    animate(robot.model,q);
    pause(.05);
end