%%Show Card

function [] = showCard(robot,cards,CH,cardNum)

if cardNum < 11
    CHNum = cardNum - 1;
elseif cardNum == 12
    CHNum = 10;
else CHNum = 11;
end

q = grabNextCard(robot,cards,cardNum);
   
iPose = robot.model.fkine(q);
nPose = iPose*transl(0,0,-0.1);
q = RMRC(robot,iPose,nPose,q,cards,cardNum);

iPose = robot.model.fkine(q);
nPose = CH.cardHolder{11}.base*transl(0,-.04,0);
q = RMRC(robot,iPose,nPose,q,cards,cardNum);

iPose = robot.model.fkine(q);
nPose = CH.cardHolder{CHNum}.base*transl(0,-.04,0);
q = RMRC(robot,iPose,nPose,q,cards,cardNum);

q = robot.model.getpos;
steps = 20;
inc = (pi/2-q(6))/steps;
for i=1:steps
    q(6) = q(6)+inc;   
    animate(robot.model,q);
    cards.card{cardNum}.base = robot.model.fkine(q);
    animate(cards.card{cardNum},0);
    pause(.05);
end

iPose = robot.model.fkine(q);
nPose = CH.cardHolder{CHNum}.base*trotz(pi);
q = RMRC(robot,iPose,nPose,q,cards,cardNum);

nextq = robot.model.ikcon(robot.model.fkine(q)*transl(0,0,-.06),robot.model.getpos);
steps = 20;
traj = jtraj(q,nextq,steps);
for i=1:steps
    q = traj(i,:);
    animate(robot.model,q);
    pause(.05);
end
end