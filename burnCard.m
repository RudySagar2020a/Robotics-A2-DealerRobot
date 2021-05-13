%%Burn Card

function [] = burnCard(robot,cards,cardNum,CD)

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
    animate(robot.model,q);
    pause(.05);
end
end

