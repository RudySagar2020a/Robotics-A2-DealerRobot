%%Burn Card

function [] = burnCard(robot1,cards,cardNum,CD)
robot = robot1;

q = grabNextCard(robot,cards,cardNum);

iPose = robot.model.fkine(q);
nPose = iPose*transl(0,0,-0.1);
q = RMRC(robot,iPose,nPose,q,cards,cardNum);

iPose = robot.model.fkine(q);
nPose = iPose*transl(0,-.1,0);
q = RMRC(robot,iPose,nPose,q,cards,cardNum);

iPose = robot.model.fkine(q);
nPose = CD.cardDispenser.base;
q = RMRC(robot,iPose,nPose,q,cards,cardNum);

nextq = robot.model.ikcon(robot.model.fkine(q)*transl(0,0,-.1),q);
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

