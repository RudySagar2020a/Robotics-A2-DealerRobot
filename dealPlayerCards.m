%%Deal Player Cards
function [] = dealPlayerCards(robot,cards,CH)

for cardNum = 1:6

q = grabNextCard(robot,cards,cardNum); 

iPose = robot.model.fkine(q);
nPose = robot.model.fkine(q)*transl(0,0,-0.1);
q = RMRC(robot,iPose,nPose,q,cards,cardNum);

if cardNum == 3 || cardNum == 6

    q = grabNextCard(robot,cards,cardNum);

    iPose = robot.model.fkine(q);
    nPose = robot.model.fkine(q)*transl(0,0,-0.1);
    q = RMRC(robot,iPose,nPose,q,cards,cardNum);
    
    if cardNum == 3 || cardNum == 6
        iPose = robot.model.fkine(q);
        %     nPoseRot = tr2rpy(CH.cardHolder{2}.base);
        %     nPoseTransl = transl(iPose(1:3,4))*transl(0.4,.4,0);
        nPose = CH.cardHolder{5}.base*transl(0,-.02,-.25);%nPoseTransl*rpy2tr(nPoseRot);
        q = RMRC(robot,iPose,nPose,q,cards,cardNum);
    end
    
    iPose = robot.model.fkine(q);
    if cardNum == 1 || cardNum == 4
        %nPoseRot = tr2rpy(CH.cardHolder{cardNum}.base);
        %nPoseTransl = transl(iPose(1:3,4))*transl(0.05,.1,0);
        nPose = CH.cardHolder{cardNum}.base*transl(0,-.02,-.2);%nPoseTransl*rpy2tr(nPoseRot);
    else
        iPose = robot.model.fkine(q);
        nPose = CH.cardHolder{cardNum}.base*transl(0,-.02,-.1);
    end
    q = RMRC(robot,iPose,nPose,q,cards,cardNum);
    
    iPose = robot.model.fkine(q);
    nPose = CH.cardHolder{cardNum}.base*transl(0,-.02,0);
    q = RMRC(robot,iPose,nPose,q,cards,cardNum);
    
    iPose = robot.model.fkine(q);
    nPose = CH.cardHolder{cardNum}.base;
    q = RMRC(robot,iPose,nPose,q,cards,cardNum);
    
    %release card
    
    nextq = robot.model.ikcon(robot.model.fkine(q)*transl(0,0,-.1),q);
    steps = 20;
    traj = jtraj(q,nextq,steps);
    for i=1:steps
        q = traj(i,:);
        animate(robot.model,q);
        pause(.05);
    end
    end
    q = zeros(1,6);
    animate(robot.model,q);
    pause(.05);
end
end
steps = 50;
traj = jtraj(q,zeros(1,6),steps);
for i=1:steps
    q = traj(i,:);
    animate(robot.model,q);
    pause(.05);
end
end
