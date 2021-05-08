function [] = moveDeal(robot, goalPose, object)

    goalQ = goalPose;
    poseQ = robot.getpos;
    
    for i = 0:1
        RMRC(robot,robot.model.getpos,transl(goalQ(1,4),goalQ(2,4),goalQ(3,4)));
        RMRC(robot, qMatrix(end,:), transl(poseQ(1,4),poseQ(2,4),poseQ(3,4)));
        qMatrix = [qMatrix; q];
        steps = steps + steps;
    end
end