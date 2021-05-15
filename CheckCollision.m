%%Check Collision
function[bool] = CheckCollision(robot,bottle,q)
   bottleAndRobotRadius = 0.03;
   J2 = robot.model.links(1).A(q(1))*robot.model.links(2).A(q(2));
   J3 = J2 * robot.model.links(3).A(q(3));
   J4 = J3 * robot.model.links(4).A(q(4));
   J5 = J4 * robot.model.links(5).A(q(5));
   J6 = J5 * robot.model.links(6).A(q(6));
   EE = robot.model.fkine(robot.model.getpos);
   transforms = {[J2] [J3] [J4] [J5] [J6] [EE]};
   for i = 1:6
   Joints2Bottle{i} = sqrt((bottle.bottle.base(1,4)-transforms{i}(1,4))^2+(bottle.bottle.base(1,4)-transforms{i}(1,4))^2)-bottleAndRobotRadius
   if Joints2Bottle{i} <= 0;
       bool = 1;
       break
   else
       bool = 0;
   end
end
    