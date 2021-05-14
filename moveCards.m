%% Move Cards

% Function used to move end effector gripper from goal pose to cards pose,
% pick it up and place wherever the goal pose is for that turn

function moveCards(robot1)

robot = robot1;
CH = getCardHolders;
cards = getCards;

    for cardNum = 1:14
        q = robot.model.getpos;
        if cardNum == 3 || cardNum == 6
            nextCard_qest = [42.7 -67.7 -108 -128 86.8 0]*pi/180;
        else
            nextCard_qest = [60 -60 -100 30 -90 90]*pi/180;
        end
        nextq = robot.model.ikcon(cards.card{cardNum}.base,nextCard_qest);
        steps = 50;
        traj = jtraj(q,nextq,steps);
        for i=1:steps
            q = traj(i,:);
            while robot.eStop == 1
                pause(1);
            end
            animate(robot.model,q);
            pause(.05);
        end

        %% Deal Player Cards

        if cardNum >= 1 && cardNum <= 6
            if cardNum == 2 || cardNum == 5
                q_ch = [0 -70 -100 -90 -80 -90]*pi/180;
            else
                q_ch = zeros(1,6);
            end
            nextq = robot.model.ikcon(CH.cardHolder{cardNum}.base,q_ch);
        elseif cardNum == 7 || cardNum == 11 || cardNum == 13
            nextq = robot.model.ikcon(cards.card{cardNum}.base*transl(.3,0,0));
        else
            if cardNum > 13
                burntCards = 3;
            elseif cardNum > 11
                burntCards = 2;
            elseif cardNum > 7
                burntCards = 1;
            else
                burntCards = 0;
            end
            nextq = robot.model.ikcon(CH.cardHolder{cardNum-burntCards}.base...
                *trotz(pi),robot.model.getpos);
        end
        traj = jtraj(robot.model.getpos,nextq,steps);
        for i=1:steps
            q = traj(i,:);
            while robot.eStop == 1
                pause(1);
            end
            animate(robot.model,q);
            cards.card{cardNum}.base = (robot.model.fkine(q));
            animate(cards.card{cardNum},0);
            pause(0.05);
        end
        inc = q(2)/steps;
        for i = 1:steps
            q(2) = q(2)-inc;
            animate(robot.model,q);
            pause(0.025);
        end
        cardNum = cardNum + 1;

        q = robot.model.getpos;
        if cardNum == 3 || cardNum == 6
            nextCard_qest = [42.7 -67.7 -108 -128 86.8 0]*pi/180;
        else
            nextCard_qest = [60 -60 -100 30 -90 90]*pi/180;
        end
        nextq = robot.model.ikcon(cards.card{cardNum}.base,nextCard_qest);
        steps = 50;
        traj = jtraj(q,nextq,steps);
        for i=1:steps
            q = traj(i,:);
            while robot.eStop == 1
                pause(1);
            end
            animate(robot.model,q);
            pause(.05);
        end

        %% Deal Player Cards

        if cardNum >= 1 && cardNum <= 6
            if cardNum == 2 || cardNum == 5
                q_ch = [0 -70 -100 -90 -80 -90]*pi/180;
            else
                q_ch = zeros(1,6);
            end
            nextq = robot.model.ikcon(CH.cardHolder{cardNum}.base,q_ch);
        elseif cardNum == 7 || cardNum == 11 || cardNum == 13
            nextq = robot.model.ikcon(cards.card{cardNum}.base*transl(.3,0,0));
        else
            if cardNum > 13
                burntCards = 3;
            elseif cardNum > 11
                burntCards = 2;
            elseif cardNum > 7
                burntCards = 1;
            else
                burntCards = 0;
            end
            nextq = robot.model.ikcon(CH.cardHolder{cardNum-burntCards}.base...
                *trotz(pi),robot.model.getpos);
        end
        traj = jtraj(robot.model.getpos,nextq,steps);
        for i=1:steps
            q = traj(i,:);
            while robot.eStop == 1
                pause(1);
            end
            animate(robot.model,q);
            cards.card{cardNum}.base = (robot.model.fkine(q));
            animate(cards.card{cardNum},0);
            pause(0.05);
        end
        inc = q(2)/steps;
        for i = 1:steps
            q(2) = q(2)-inc;
            animate(robot.model,q);
            pause(0.025);
        end
        
        cardNum = cardNum + 1;
    end
end


% function [] = MoveCards(robot, goalPose, object)
%     initQ = robot.model.getpos();
%     goalQ = robot.model.ikcon(goalPose*trotx(pi)*transl(0,0,0),robot.model.getpos);
%
%     trajectory = jtraj(robot.model.getpos(), goalQ, 50);
%     qMatrix = trajectory;
% end