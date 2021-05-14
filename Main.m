%% Clear+Prepare Setup

close all
clear
clc

%% MAIN CLASS FOR EXECUTING CODE

w = 2;
workspace =  [-w w -0.5 w 0 w];

%generate & Plot table, arm & card holders
surf([-2,-2;2,2],[-1.6,2;-1.6,2],[0.001,0.001;0.001,0.001],'CData',imread('carpet.jpg'),'FaceColor','texturemap');

table = getTable;
robot = Kinova;
CH = getCardHolders;
CD = getCardDispenser;
cards = getCardsRMRC;
%bottle = getBottle;

Dennis = People(workspace, 'Dennis', transl(1.1, 0.4, 0.0) * trotz(pi));
Mei = People(workspace, 'Mei', transl(-1.15, 0.55, 0.0) * trotz(-pi/2));
Jack = People(workspace, 'Jack', transl(0.0, 1.15, 0.0));
view(3);

q = zeros(1,6);

%% Deal Player cards
    
dealPlayerCards(robot,cards,CH); 
%% The Flop

theFlop(robot,cards,CH,CD);

%% The Turn

theTurn(robot,cards,CH,CD);

%% The River

theRiver(robot,cards,CH,CD);
