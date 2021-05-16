%% Collision Detection Tester

function CollisionDetectionTest(robot1,cards,CH,cardNum)
robot = robot1;
cardNum = 2;
q = grabNextCard(robot,cards,cardNum);

    iPose = robot.model.fkine(q);
    nPose = robot.model.fkine(q)*transl(0,0,-0.1);
    q = RMRC(robot,iPose,nPose,q,cards,cardNum);

    if cardNum == 3 || cardNum == 6
        iPose = robot.model.fkine(q);
        nPose = CH.cardHolder{5}.base*transl(0,-.02,-.25);%nPoseTransl*rpy2tr(nPoseRot);
        q = RMRC(robot,iPose,nPose,q,cards,cardNum);
    end
    
    iPose = robot.model.fkine(q);
    if cardNum == 1 || cardNum == 4
        nPose = CH.cardHolder{cardNum}.base*transl(0,-.02,-.2);%nPoseTransl*rpy2tr(nPoseRot);
    else
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
    q = robot.model.getpos;
    nPose = robot.model.fkine(q)*transl(0,0,-.1);
    nextq = robot.model.ikcon(nPose,q);
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
    cardNum = 1;
    
    grabNextCardCD(robot,cards,cardNum,bottle);

end