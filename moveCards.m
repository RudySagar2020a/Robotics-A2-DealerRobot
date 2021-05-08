%% Move Cards

% Function used to move end effector gripper from goal pose to cards pose,
% pick it up and place wherever the goal pose is for that turn

function [] = moveCards(robot, item, goalPose)
    
    qz = robot.model.getpos .* 0;
    itemT = item.model.base;
    currentQ = robot.model.getpos;
    goalQ = robot.model.ikcon(itemT,qz);
    
    qMatrix = jtraj(currentQ, goalQ, 51);
    for i = 1:size(qMatrix, 1)
        robot.model.animate(qMatrix(i,:);
        pause(0.01);
    end
    pause(0.01);
    
    %------------------------------------
    
    currentQ = robot.model.getpos;
    newQ = robot.model.ikcon(goalPose, qz);
    
    qMatrix = jtraj(currentQ, newQ, 51);
    for i = 1:size(qMatrix, 1)
        q = qMatrix(i,:);
        robot.model.animate(q);
        newBase = robot.model.fkine(q);
        item.model.base = newBase;
        item.model.animate(0);
        pause(0.1);
    end
    pause(0.1);
end


% function [] = MoveCards(robot, goalPose, object)
%     initQ = robot.model.getpos();
%     goalQ = robot.model.ikcon(goalPose*trotx(pi)*transl(0,0,0),robot.model.getpos);
%     
%     trajectory = jtraj(robot.model.getpos(), goalQ, 50);
%     qMatrix = trajectory;
% end 