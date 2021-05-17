%%Grab Next Card
function [q] = grabNextCardCD(robot,cards,cardNum,bottle)
%robot = robot1;

nextCardApproachTr = transl(-0.4,0,1)*trotz(pi/2)*trotx(-pi/2);
bottle.bottle.base = transl(-.2,.4,.98);
animate(bottle.bottle,0);
q = robot.model.getpos;
nextq = robot.model.ikcon(nextCardApproachTr,zeros(1,6));
steps = 41;
traj = jtraj(q,nextq,steps);
for i=1:steps
    q = traj(i,:);
    CheckCollision(robot,bottle,q); %un-mask to see boolean states (0/1)
    if CheckCollision(robot,bottle,q) == 1
        disp('Collision Detection! To Prevent a Party Foul, Movement Has Been Stopped');
        robot.eStop = 1;
    end
    while robot.eStop == 1
        pause(1);
%         bottle.bottle.base = transl(-0.2,0.4,0.98);
    end
    animate(robot.model,q);
    pause(.05);
end
steps = 41; %11
for i = 1:steps
    cards.card{cardNum}.base(1,4) = cards.card{cardNum}.base(1,4) + .1/steps;
    animate(cards.card{cardNum},0);
    pause(.05);
end
nextq = robot.model.ikcon(cards.card{cardNum}.base,q);
steps = 20;
traj = jtraj(q,nextq,steps);

for i=1:steps
    q = traj(i,:);
    while robot.eStop == 1
        pause(1);
    end
    animate(robot.model,q);
    pause(.05);
end
end