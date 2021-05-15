classdef getBottle < handle
    
    
    properties (Constant)
        %> Max height is for plotting of the workspace
        maxHeight = 3;
    end
    
    properties
        %> Number of bottles
        bottleCount = 1;
        
        %> A cell structure of \c bottleCount bottle models
        bottle;
        
        %> workspace in meters
        workAreaSize = [2,2];
        
        %> Dimensions of the workspace
        workspaceDimensions = [-2 2 -2 2 0 2.5];
    end
    
    methods
        %% ...structors
        function self = getBottle(bottleCount)
            if 0 < nargin
                self.bottleCount = bottleCount;
            end
            
%             self.workspaceDimensions = [-self.workAreaSize(1)/2, self.workAreaSize(1)/2 ...
%                 ,-self.workAreaSize(2)/2, self.workAreaSize(2)/2 ...
%                 ,0,self.maxHeight];
            
            zoffset = 0.02;
            T1 = transl(.78*cos(deg2rad(120)), .78*sin(deg2rad(120)), 1.05-zoffset);
            
            % Create the required number of bottles
            
            self.bottle = self.GetBottleModel('bottle');
            % Spawn at locations
            self.bottle.base = T1;
            % Plot 3D model
            C = {'green'};
            plot3d(self.bottle,0,'workspace',self.workspaceDimensions,'delay',0,'color',C);
            
            
            
            
            axis equal
%             camlight;
            
            
            function delete(self)
                %             cla;
            end
            
        end
    end
    
    
    methods (Static)
        
        % GetbottleModel
        function model = GetBottleModel(name)
            if nargin < 1
                name = 'bottle';
            end
            [faceData,vertexData] = plyread('bottle.ply','tri');
            L1 = Link('alpha',0,'a',0,'d',0,'offset',0);
            model = SerialLink(L1,'name',name);
            model.faces = {faceData,[]};
            vertexData(:,2) = vertexData(:,2);
            model.points = {vertexData * rotx(pi),[]};
            
            
        end
    end
end
