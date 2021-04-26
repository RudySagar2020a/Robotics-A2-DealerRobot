%% Clear+Prepare Setup

close all
set(0,'DefaultFigureWindowStyle','docked')
clear
clc
clf

%% MAIN CLASS FOR EXECUTING CODE

w = 5;
workspace = [-w w -w w -w w];

% EDIT ROBOT ARM TRANSLATION HERE---

K1Loc = transl(0.0, 0.0, 0.0);

% K1 = ItemTest(workspace,'KiJoint0', K1Loc);

KinovaLoc = transl(0.0,0.0,0.1); %TRANSLATE FOR UR3 Arm
%NOTE: POSE for LINEAR UR5 changed @LinearUR5 (line 62)

% 3D PLOT ROBOT ARM IN WORKSPACE---

KinovaArm = Kinova(workspace, 'KinovaArm', KinovaLoc);
