%% Resolved Motion Rate Control
% Lab 9 - Question 1 - Resolved Motion Rate Control in 6DOF referenced to
% apply towards Kinova Arm movement (end effector position)

function [q] = RMRC(robot,iPose,nPose,q,cards,cardNum)%, Time)
% 1.1) Set parameters for the simulation
t = sqrt((nPose(1,4)-iPose(1,4))^2+(nPose(2,4)-iPose(2,4))^2+(nPose(3,4)-iPose(3,4))^2)*5;             % Total time (s)
deltaT = 0.05;      % Control frequency (discrete timestep)
steps = round(t/deltaT);   % No. of steps for simulation
delta = 2*pi/steps; % Small angle change
epsilon = 0.1;      % Threshold value for manipulability/Damped Least Squares
% [Lx Ly Lz Ax Ay Az]
% Lx-Ly-Lz are linear velocities / Ax-Ay-Az are angular velocities
W = diag([1 1 1 0.1 0.1 0.1]);    % Weighting matrix for the velocity vector

% 1.2) Allocate array data
m = zeros(steps,1);             % Array for Measure of Manipulability
qMatrix = zeros(steps,6);       % Array for joint anglesR
qdot = zeros(steps,6);          % Array for joint velocities
theta = zeros(3,steps);         % Array for roll-pitch-yaw angles
x = zeros(3,steps);             % Array for x-y-z trajectory
positionError = zeros(3,steps); % For plotting trajectory error
angleError = zeros(3,steps);    % For plotting trajectory error

s = lspb(0,1,steps);                % Trapezoidal trajectory scalar
% 1.3) Set up trajectory, initial pose
x = [iPose(1,4) nPose(1,4)];  %start and end x position
y = [iPose(2,4) nPose(2,4)];   %start and end y position
z = [iPose(3,4) nPose(3,4)];   %start and end z position
iPose_rpy = tr2rpy(iPose);
nPose_rpy = tr2rpy(nPose);
roll = [iPose_rpy(1) nPose_rpy(1)];
pitch = [iPose_rpy(2) nPose_rpy(2)];
yaw = [iPose_rpy(3) nPose_rpy(3)];

for i=1:steps
    pos(1,i) = x(1)+s(i)*(x(2)-x(1)); % Points in x
    pos(2,i) = y(1)+s(i)*(y(2)-y(1)); % Points in y
    pos(3,i) = z(1)+s(i)*(z(2)-z(1)); % Points in z
    theta(1,i) = roll(1)+s(i)*(roll(2)-roll(1));               % Roll angle
    theta(2,i) = pitch(1)+s(i)*(pitch(2)-pitch(1));             % Pitch angle
    theta(3,i) = yaw(1)+s(i)*(yaw(2)-yaw(1));                 % Yaw angle
end
% xscalar = lspb(iQ(1), eQ(1), steps);
% yscalar = lspb(iQ(2), eQ(2), steps);
% zscalar = lspb(iQ(3), eQ(3), steps);

% for  i = 1:steps
%      pos(1,i) = xscalar;      % Points in x
%      pos(2,i) = yscalar;      % Points in y
%      pos(3,i) = zscalar;      % Points in z
%      theta(1,i) = 0;        % Roll angle
%      theta(2,i) = 0;        % Pitch angle
%      theta(3,i) = 0;        % Yaw angle
% end
qMatrix(1,:) = q;                                     % Solve joint angles to achieve first waypoint

% 1.4) Track the trajectory with RMRC
for i = 1:steps-1
    T = robot.model.fkine(qMatrix(i,:));                                    % Get forward transformation at current joint state
    deltaX = pos(:,i+1) - T(1:3,4);                                         % Get position error from next waypoint
    Rd = rpy2r(theta(1,i+1),theta(2,i+1),theta(3,i+1));                     % Get next RPY angles, convert to rotation matrix
    Ra = T(1:3,1:3);                                                        % Current end-effector rotation matrix
    Rdot = (1/deltaT)*(Rd - Ra);                                            % Calculate rotation matrix error
    S = Rdot*Ra';                                                           % Skew symmetric!
    linear_velocity = (1/deltaT)*deltaX;
    angular_velocity = [S(3,2);S(1,3);S(2,1)];                              % Check the structure of Skew Symmetric matrix!!
    deltaTheta = tr2rpy(Rd*Ra');                                            % Convert rotation matrix to RPY angles
    xdot = W*[linear_velocity;angular_velocity];                          	% Calculate end-effector velocity to reach next waypoint.
    J = robot.model.jacob0(qMatrix(i,:));                                   % Get Jacobian at current joint state
    m(i) = sqrt(det(J*J'));
    if m(i) < epsilon  % If manipulability is less than given threshold
        lambda = (1 - m(i)/epsilon)*5E-2;
    else
        lambda = 0;
    end
    invJ = inv(J'*J + lambda *eye(6))*J';                                   % DLS Inverse
    qdot(i,:) = (invJ*xdot)';                                               % Solve the RMRC equation (you may need to transpose the         vector)
    for j = 1:6                                                             % Loop through joints 1 to 6
        if qMatrix(i,j) + deltaT*qdot(i,j) < robot.model.qlim(j,1)          % If next joint angle is lower than joint limit...
            qdot(i,j) = 0; % Stop the motor
        elseif qMatrix(i,j) + deltaT*qdot(i,j) > robot.model.qlim(j,2)      % If next joint angle is greater than joint limit ...
            qdot(i,j) = 0; % Stop the motor
        end
    end
    qMatrix(i+1,:) = qMatrix(i,:) + deltaT*qdot(i,:);                       % Update next joint state based on joint velocities
    positionError(:,i) = pos(:,i+1) - T(1:3,4);                               % For plotting
    angleError(:,i) = deltaTheta;
end
q = qMatrix; %(steps,:);
% q = qMatrix(steps,:);
% % 1.5) Plot the results
% figure(1)
% for i = 1:steps
%     cards.card{cardNum}.base = robot.model.fkine(qMatrix(i,:))
%     animate(robot.model,qMatrix(i,:));
%     animate(cards.card{cardNum},0);
%     pause(deltaT);% For plotting
%     %plot3(pos(1,i),pos(2,i),pos(3,i),'k.','LineWidth',1)
% end

%
% for i = 1:6
%     figure(2)
%     subplot(3,2,i)
%     plot(qMatrix(:,i),'k','LineWidth',1)
%     title(['Joint ', num2str(i)])
%     ylabel('Angle (rad)')
%     refline(0,p560.qlim(i,1));
%     refline(0,p560.qlim(i,2));
%
%     figure(3)
%     subplot(3,2,i)
%     plot(qdot(:,i),'k','LineWidth',1)
%     title(['Joint ',num2str(i)]);
%     ylabel('Velocity (rad/s)')
%     refline(0,0)
% end
%
% figure(4)
% subplot(2,1,1)
% plot(positionError'*1000,'LineWidth',1)
% refline(0,0)
% xlabel('Step')
% ylabel('Position Error (mm)')
% legend('X-Axis','Y-Axis','Z-Axis')
%
% subplot(2,1,2)
% plot(angleError','LineWidth',1)
% refline(0,0)
% xlabel('Step')
% ylabel('Angle Error (rad)')
% legend('Roll','Pitch','Yaw')
% figure(5)
% plot(m,'k','LineWidth',1)
% refline(0,epsilon)
% title('Manipulability')
%
% end
