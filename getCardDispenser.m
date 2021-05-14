classdef getCardDispenser < handle
   
    properties (Constant)
        %> Max height is for plotting of the workspace
        maxHeight = 2;
    end
    
    properties
        %> Number of CardDispensers
        cardDispenserCount = 1;
        
        %> A cell structure of \c CardDispenserCount CardDispenser models
        cardDispenser;
        
        %> Dimensions of the workspace
        workspaceDimensions;
    end
    
    methods
        %% ...structors
        function self = getCardDispenser(CardDispenserCount)
            if 0 < nargin
                self.cardDispenserCount = CardDispenserCount;
            end
            
            self.workspaceDimensions = [-2 2 -.6 2 0 2.1];
           
            
            T1 = eye(4)*transl(-.65,0,1.1)*trotx(-pi/2)*troty(-pi/2);
            
          

            % Create the required number of CardDispensers
            
                self.cardDispenser = self.GetCardDispenserModel('CardDispenser');
                % Spawn at locations
                self.cardDispenser.base = T1;
                 % Plot 3D model
                C = {'blue'};
                plot3d(self.cardDispenser,0,'workspace',self.workspaceDimensions,'delay',0,'color',C);
                
            axis equal
            camlight;
       
        
%         function delete(self)
% %             cla;
%         end       
        
        end
    end
  
    
    methods (Static)
       
        %% GetCardDispenserModel
        function model = GetCardDispenserModel(name)
            if nargin < 1
                name = 'CardDispenser';
            end
            [faceData,vertexData] = plyread('cardDispenser.ply','tri');
            L1 = Link('alpha',0,'a',0,'d',0,'offset',0);
            model = SerialLink(L1,'name',name);
            model.faces = {faceData,[]};
            vertexData(:,2) = vertexData(:,2);
            model.points = {vertexData,[]};
        
    end    
    end
end
