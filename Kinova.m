%% KINOVA ARM CLASS
classdef Kinova < handle
    properties %constant property
        %> Robot model
        model;
        location;
        workspace = [-1 1 -1 1 0.1 1];
        plyData;
        startPoseJoints;
%         maxReachRadius;
%         maxVolume;
%         pointCloud;
    end
    
    methods %% Static Class for Kinova robot simulation

        function self = Kinova(workspace,modelName,location)
            self.workspace = workspace;
            self.model.base = location;
            self.location = location;
            self.GetKinova(modelName,workspace);
%             self.PlotAndColourRobot();
            self.startPoseJoints = zeros(1,6);
        end

%% GetUR3Robot
% Given a name (optional), create and return a UR3 robot model

function GetKinova(self, modelName, workspace)
    pause(0.001);
    workspace = [-1 1 -1 1 0 1];
    
% Kinova Gen3 Lite DH parameters found on Datasheet on below website: 
% https://www.kinovarobotics.com/sites/default/files/...
% UG-017_KINOVA_Gen3_lite_robot_USER_GUIDE_EN_R01_0.pdf

% NOTE:
% theta - rotation about z-axis
% d     - translation along z-axis
% a     - translation along x-axis
% alpha - rotation about x-axis
% offset - kinematic joint coordinate offset (Nx1)

    % CHANGE DH PARAMETERS
    L1 = Link('d',0.1283, 'a',0,    'alpha',pi/2, 'offset',pi/2);
    L2 = Link('d',0.03,   'a',0.27, 'alpha',pi,   'offset',0);
    L3 = Link('d',0.02,   'a',0,    'alpha',pi/2, 'offset',0);
    L4 = Link('d',0.140,  'a',0,    'alpha',pi/2, 'offset',0);
    L5 = Link('d',0.0285, 'a',0,    'alpha',pi/2, 'offset',0);
    L6 = Link('d',0.105,  'a',0,    'alpha',0,    'offset',0);

    L1.qlim = [deg2rad(-154.1),deg2rad(154.1)];
    L2.qlim = [deg2rad(-150.1),deg2rad(150.1)];
    L3.qlim = [deg2rad(-150.1),deg2rad(150.1)];
    L4.qlim = [deg2rad(-148.98),deg2rad(148.98)];
    L5.qlim = [deg2rad(-144.97),deg2rad(145.0)];
    L6.qlim = [deg2rad(-148.98),deg2rad(148.98)];
        
    self.model = SerialLink([L1 L2 L3 L4 L5 L6],'name', modelName);
    
    % ADDED FOR THE ASSIGNMENT, RETURN BACK TO NOTHING ONCE COMPLETE
    % CHANGED POSE FOR A1 BELOW - transl(-X, Z, Y):
    % NEW CHANGE: (multiply base by location as you've already preset
    % location parameter and passing it to Get function when calling
    % in main. Now you can change location of base in Main.
    
%     self.model.base = self.model.base * transl(0.0,0.0,0.0);
    self.model.base = self.model.base * self.location;
    
    % NOTE: TO USE STICK MODEL, COMMENT OUT PLOTANDCOLOUR FUNCTION AND USE
    % THE PARAMETERS AND SETUP BELOW:
        q = zeros(1,6);
        self.model.plot(q,'workspace', workspace);
        self.model.teach();
end

%% PlotAndColourRobot
% Given a robot index, add the glyphs (vertices and faces) and
% colour them in if data is available 
         function PlotAndColourRobot(self)%robot,workspace)
            for linkIndex = 0:self.model.n
                [faceData, vertexData, plyData{linkIndex + 1}] = plyread ...
                    (['KiJoint',num2str(linkIndex),'.ply'],'tri');
                self.model.faces{linkIndex+1} = faceData;
                self.model.points{linkIndex+1} = vertexData;
            end

%           Display robot
            self.model.plot3d(zeros(1,self.model.n),'noarrow','workspace',self.workspace);
            if isempty(findobj(get(gca,'Children'),'Type','Light'))
                camlight
            end
            self.model.delay = 0;

%           Try to correctly colour the arm (if colours are in ply file data)
            for linkIndex = 0:self.model.n
                handles = findobj('Tag', self.model.name);
                h = get(handles,'UserData');
                try 
                    h.link(linkIndex+1).Children.FaceVertexCData = ...
                        [plyData{linkIndex+1}.vertex.red ...
                       , plyData{linkIndex+1}.vertex.green ...
                       , plyData{linkIndex+1}.vertex.blue]/255;
                    h.link(linkIndex+1).Children.FaceColor = 'interp';
                catch ME_1
                    disp(ME_1);
                    continue;
                end
            end
         end

%% Point Cloud

        function [pointCloud] = PointCloudSphere(self, stepCount)
% Lab 3 Point Cloud
% 2.4 Sample the joint angles within the joint limits at 'step-Count' degree increments between each of the joint limits
% & 2.5 Use fkine to determine the point in space for each of these poses, so that you end up with a big list of points
        stepRads = deg2rad(stepCount);
        qlim = self.model.qlim;
        % Don't need to worry about joint 6
        pointCloudeSize = prod(floor((qlim(1:5,2)-qlim(1:5,1))/stepRads + 1));
        pointCloud = zeros(pointCloudeSize,3);
        counter = 1;
        count = 1;
        tic
        
            for q1 = qlim(1,1):stepRads:qlim(1,2)
                for q2 = qlim(2,1):stepRads:qlim(2,2)        
                    for q3 = qlim(3,1):stepRads:qlim(3,2)            
                        for q4 = qlim(4,1):stepRads:qlim(4,2)                
                            for q5 = qlim(5,1):stepRads:qlim(5,2)                    
                                % Don't need to worry about joint 6, just assume it=0
%                                 q6 = 0;%                     
%                                 for q6 = qlim(6,1):stepRads:qlim(6,2)                        
                                    q = [q1,q2,q3,q4,q5,0];                        
                                    tr = self.model.fkine(q);                                                
                                    pointCloud(counter,:) = tr(1:3,4)';                        
                                    counter = counter + 1;
                                    count = count + 1;
                                    if mod(counter/pointCloudeSize * 100,1) == 0                            
                                        disp(['After ',num2str(toc),' seconds, completed ',num2str(counter/pointCloudeSize * 100),'% of poses']);                        
                                    end%
%                                 end
                            end
                        end
                    end
                end
            end
            
            % makes pointCloud global so that other functions and
            % parameters can access it without needing to call 
            self.pointCloud = pointCloud;
            
            %------------------------Max Reach----------------------------
            % tabulate all point cloud into rows and columns of data points
            % extract maximum value points in point cloud in each direction
            % find the maximum value and calculate the difference between
            % that 'max point' and base of Robot
            
            % UR3 Spec Sheet declares Arm Reach = 500mm (0.5m)
            % https://www.universal-robots.com/media/240787/ur3_us.pdf
            % Should expect a value around 0.5m
            
            % NOTE: a peer student walked through this code for me, it is
            % theirs and I am simply referencing it
            
            [row, column] = size(self.pointCloud);
            value = zeros(row, 1);
                       
            for points = 1:row
                % Base Point:
                bP = self.model.base(1:3, 4)';
                % Max Point Cloud Point:
                maxPCP = self.pointCloud(points, :);
                
                value(points, 1) = norm(maxPCP - bP);
            end

            [reachRadius, table] = max(value);
            self.maxReachRadius = reachRadius
                    
            % -----------------------Max Volume---------------------------
            % Convhull function to calculate volume of PointCloudSphere
            % https://www.mathworks.com/help/matlab/ref/convhull.html#bspql3e-1
            
            [k,av] = convhull(self.pointCloud);
            self.maxVolume = av
            
        end
    end
end