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

Dennis = People(workspace, 'Dennis', transl(1.1, 0.4, 0.001) * trotz(pi));
Mei = People(workspace, 'Mei', transl(-1.15, 0.55, 0.001) * trotz(-pi/2));
Jack = People(workspace, 'Jack', transl(0.0, 1.15, 0.001));
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

%% Light Curtains

% LIGHT CURTAIN ATTEMPT 1---------------------------------
% X.lightCurtain = [-0.75, 0.75]; % <---->
% Y.lightCurtain = [0.0, 0.75]; % thin line of one point
% Z.lightCurtain = [1.75, 1.75];

% for lineIT = Z.lightCurtain(1):-0.1:0.95
%     plot3(X.lightCurtain, Y.lightCurtain, [lineIT, lineIT], '--r','LineWidth',0.3);
% end

% LIGHT CURTAIN ATTEMPT 2---------------------------------
% radius of table = 0.84 metres
% X.lightCurtain = -0.84:0.1:0.84; %[-0.75, 0.75]; % <---->
% Y.lightCurtain = 0.0:0.12:0.84; %[0.0, 0.75]; % thin line of one point
% [X,Y] = meshgrid(X.lightCurtain,Y.lightCurtain);
% Z = (X + Y).^2; %[1.75, 1.75]; % /\----\/
% plot3(X,Y,Z);

% LIGHT CURTAIN-------------------------------------------
% Create sphere
sphereCenter = [0,0,0.95];
radius = 0.7;
[X,Y,Z] = sphere(20);
X = X * radius + sphereCenter(1);
Y = Y * radius + sphereCenter(2);
Z = Z * radius + sphereCenter(3);

% Plot it
% Plot point cloud
points = [X(:),Y(:),Z(:)];
spherePc_h = plot3(points(:,1),points(:,2),points(:,3),'r.');
pause
delete (spherePc_h)
 
% CheckCollision(robot,sphereCenter,radius);
% if CheckCollision(robot,sphereCenter,radius) == 1
%     disp('UNSAFE: Robot stopped')
%     break;
% end