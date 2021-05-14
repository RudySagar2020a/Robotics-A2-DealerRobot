%% Clear+Prepare Setup

close all
clear
clc

%% MAIN CLASS FOR EXECUTING CODE

workspace =  [-2 2 -.6 2 0 2.1];
surf([-2,-2;2,2],[-1.2,2;-1.2,2],[0.001,0.001;0.001,0.001],'CData',imread('carpet.jpg'),'FaceColor','texturemap');
%generate & Plot table, arm & card holders

table = getTable;
robot = Kinova;
CH = getCardHolders;
CD = getCardDispenser;
cards = getCardsRMRC(workspace);
%bottle = getBottle(workspace);
q = zeros(1,6);

%% Deal Player cards
    
dealPlayerCards(robot,cards,CH) 
%% The Flop

theFlop(robot,cards,CH,CD)

%% The Turn

theTurn(robot,cards,CH,CD)

%% The River

theRiver(robot,cards,CH,CD)



%% Grab card  ***JTRAJ METHOD***

moveCards()

