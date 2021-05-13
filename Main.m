%% Clear+Prepare Setup

close all
clear
clc

%% MAIN CLASS FOR EXECUTING CODE

w = 2;
workspace =  [-w w -w w -w w];

%generate & Plot table, arm & card holders

table = getTable;
robot = Kinova;
CH = getCardHolders;
cards = getCardsRMRC;
%bottle = getBottle;


%% 
for cardNum = 1:6
% Move to Collect card
q = grabNextCard(robot,cards,cardNum) 
% RMRC deal
q = dealPlayerCards(robot,q,cards,cardNum,CH) 
end



%% Grab card  ***JTRAJ METHOD***

for cardNum = 1:14
    q = robot.model.getpos;
    %if cardNum == 3 || cardNum == 1%%6
        nextCard_qest = [42.7 -67.7 -108 -128 86.8 0]*pi/180;
    %else nextCard_qest = [60 -60 -100 30 -90 90]*pi/180;
    %end
    nextq = robot.model.ikcon(cards.card{cardNum}.base*troty(pi),nextCard_qest);
    steps = 50;
    traj = jtraj(q,nextq,steps);
    for i=1:steps
        q = traj(i,:);
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
        nextq = robot.model.ikcon(CH.cardHolder{cardNum-burntCards}.base*trotz(pi),robot.model.getpos);
    end
    traj = jtraj(robot.model.getpos,nextq,steps);
    for i=1:steps
        q = traj(i,:);
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
        animate(robot.model,q);
        pause(.05);
    end
 end
=======
%% Clear+Prepare Setup

close all
clear
clc

%% MAIN CLASS FOR EXECUTING CODE

w = 2;
workspace =  [-w w -w w -w w];

%generate & Plot table, arm & card holders

table = getTable;
robot = Kinova;
CH = getCardHolders;
cards = getCardsRMRC;
%bottle = getBottle;


%% 
for cardNum = 3
% Move to Collect card
q = grabNextCard(robot,cards,cardNum) 
% RMRC deal
q = dealPlayerCards(robot,q,cards,cardNum,CH) 
end

%% Grab card  ***JTRAJ METHOD***

for cardNum = 1:14
    q = robot.model.getpos;
    %if cardNum == 3 || cardNum == 1%%6
        nextCard_qest = [42.7 -67.7 -108 -128 86.8 0]*pi/180;
    %else nextCard_qest = [60 -60 -100 30 -90 90]*pi/180;
    %end
    nextq = robot.model.ikcon(cards.card{cardNum}.base*troty(pi),nextCard_qest);
    steps = 50;
    traj = jtraj(q,nextq,steps);
    for i=1:steps
        q = traj(i,:);
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
        nextq = robot.model.ikcon(CH.cardHolder{cardNum-burntCards}.base*trotz(pi),robot.model.getpos);
    end
    traj = jtraj(robot.model.getpos,nextq,steps);
    for i=1:steps
        q = traj(i,:);
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
        animate(robot.model,q);
        pause(.05);
    end
 end
>>>>>>> ab78baf59ae6b6cf5b11a7ef93739405ad4d4d8d
