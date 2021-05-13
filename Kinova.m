classdef Kinova < handle
    properties
        
        model;
        workspace = [-2 2 -2 2 -1 2.1];
        location;
        startJoints;
        restPose;
        useGripper = false;
        
        eStop = 0;  %currently in off state
        
    end
    
    methods
        
        function self = Kinova()
            
            self.model.base = transl(0,0,0.9);
            self.model.location = transl(0,0,0.9);
            self.startJoints = zeros(1,6);
            self.restPose = deg2rad([0,-25,-95,0,0,0]);
            self.GetKinova();
            self.PlotAndColourRobot();
            self.getPose();
            
        end
        %% GetKinova
        function GetKinova(self)
            name = 'Kinova';
            
            % https://www.kinovarobotics.com/sites/default/files/...
            % UG-017_KINOVA_Gen3_lite_robot_USER_GUIDE_EN_R01_0.pdf
            
            % NOTE:
            % theta - rotation about z-axis
            % d     - translation along z-axis
            % a     - translation along x-axis
            % alpha - rotation about x-axis
            % offset - kinematic joint coordinate offset (Nx1)
            
            Kinova.L(1) = Link('d',0.2433,'a',0,   'alpha',pi/2,'offset',pi/2);
            Kinova.L(2) = Link('d',0.03,  'a',0.28,'alpha',0,   'offset',pi/2);
            Kinova.L(3) = Link('d',-.02,  'a',0,   'alpha',pi/2,'offset',-pi/2);
            Kinova.L(4) = Link('d',-.245, 'a',0,   'alpha',pi/2,'offset',pi/2);
            Kinova.L(5) = Link('d',0.057, 'a',0,   'alpha',pi/2,'offset',0);
            Kinova.L(6) = Link('d',0.2622,'a',0,   'alpha',0,   'offset',0);
            
            Kinova.L(1).qlim = [deg2rad(-154.1) ,deg2rad(154.1)];
            Kinova.L(2).qlim = [deg2rad(-150.1) ,deg2rad(150.1)];
            Kinova.L(3).qlim = [deg2rad(-150.1) ,deg2rad(150.1)];
            Kinova.L(4).qlim = [deg2rad(-148.98),deg2rad(148.98)];
            Kinova.L(5).qlim = [deg2rad(-144.97),deg2rad(145.0)];
            Kinova.L(6).qlim = [deg2rad(-148.98),deg2rad(148.98)];
            
            self.model = SerialLink([Kinova.L(1) Kinova.L(2) Kinova.L(3)...
                Kinova.L(4) Kinova.L(5) Kinova.L(6)], 'name', 'Kinova');
            
            self.model.base = self.model.base*transl(0,0,0.9);
%             self.model.teach();
            
        end
        
        %% Get Current Position of Robot Arm Configuration
        
        function [pose] = getPose(self)
            pose = self.model.fkine(self.model.getpos);
        end
        
        %% PlotAndColourRobot
        % Given a robot index, add the glyphs (vertices and faces) and
        % colour them in if data is available
        function PlotAndColourRobot(self)%robot,workspace)
            for linkIndex = 0:self.model.n
                if self.useGripper && linkIndex == self.model.n
                    [ faceData, vertexData, plyData{linkIndex+1} ] = plyread(['Joint',num2str(linkIndex),'Gripper.ply'],'tri'); %#ok<AGROW>
                else
                    [ faceData, vertexData, plyData{linkIndex+1} ] = plyread(['Joint',num2str(linkIndex),'.ply'],'tri'); %#ok<AGROW>
                end
                self.model.faces{linkIndex+1} = faceData;
                self.model.points{linkIndex+1} = vertexData;
            end
            C = {'gray'};
            % Display robot
            self.model.plot3d(zeros(1,self.model.n),'noarrow','workspace',self.workspace,'color',C);
            if isempty(findobj(get(gca,'Children'),'Type','Light'))
                camlight
            end
            self.model.delay = 0;
            
            % Try to correctly colour the arm (if colours are in ply file data)
            for linkIndex = 0:self.model.n
                handles = findobj('Tag', self.model.name);
                h = get(handles,'UserData');
                try
                    h.link(linkIndex+1).Children.FaceVertexCData = [plyData{linkIndex+1}.vertex.red ...
                        , plyData{linkIndex+1}.vertex.green ...
                        , plyData{linkIndex+1}.vertex.blue]/255;
                    h.link(linkIndex+1).Children.FaceColor = 'interp';
                catch ME_1
                    disp(ME_1);
                    continue;
                end
            end
        end
    end
end
