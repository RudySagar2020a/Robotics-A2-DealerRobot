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
CD = getCardDispenser;
cards = getCardsRMRC;
%bottle = getBottle;
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

moveCard()

end


