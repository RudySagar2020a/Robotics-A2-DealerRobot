%% Clear+Prepare Setup

close all
clear
clc

%% MAIN CLASS FOR EXECUTING CODE

w = 2;
workspace =  [-w w -w w -w w];

%generate & Plot table, arm & card holders

Dennis = People(workspace, 'Dennis', transl(1.1, 0.4, 0.0) * trotz(pi));
Mei = People(workspace, 'Mei', transl(-1.15, 0.55, 0.0) * trotz(-pi/2));
Jack = People(workspace, 'Jack', transl(0.0, 1.15, 0.0));

table = getTable;
robot = Kinova;
CH = getCardHolders;
cards = getCards;
bottle = getBottle;

%% Testing RMRC movement

%moveCards(Kinova, cards.card{i}.getpos*transl(-0.4,0,1)*trotz(pi/2), transl(0.0,0.5,1));

cardNum = 1;
holderNum = 1;
q = zeros(1,6);

iPose = cards.card{cardNum}.base; %{cardCount}
nPose = CH.cardHolder{holderNum}.base; %{cardHolderCount}
q1 = RMRC(robot,iPose,nPose,q);

%% Normal JTRAJ (Joint Trajectory) working

moveCards();
