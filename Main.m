%% Clear+Prepare Setup

close all
clear
clc

%% MAIN CLASS FOR EXECUTING CODE

w = 2;
workspace =  [-w w -w w 0 3];

%generate & Plot table, arm & card holders
surf([-2,-2;2,2],[-2,2;-2,2],[0.001,0.001;0.001,0.001],...
    'CData',imread('carpet.jpg'),'FaceColor','texturemap');

table = getTable;
robot = Kinova;
CH = getCardHolders;
CD = getCardDispenser;
cards = getCardsRMRC;
bottle = getBottle;
eStopButton = getEstopButton;
fireExt = getFireExt;

Dennis = People(workspace, 'Dennis', transl(1.1, 0.4, 0.01) * trotz(pi));
Mei = People(workspace, 'Mei', transl(-1.15, 0.55, 0.001) * trotz(-pi/2));
Jack = People(workspace, 'Jack', transl(0.0, 1.15, 0.01));
view(3); %view(3)

q = zeros(1,6);
%% Deal Player cards

dealPlayerCards(robot,cards,CH);
%% The Flop

theFlop(robot,cards,CH,CD);
%% The Turn

theTurn(robot,cards,CH,CD);
%% The River

theRiver(robot,cards,CH,CD);
%% Light Curtain Tester

bottleIngress(robot,Jack,bottle);
%% Collision Detection Tester

CollisionDetectionTest(robot,cards,CH,bottle);