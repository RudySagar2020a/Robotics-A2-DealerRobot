classdef getTable < handle
   
    
    properties (Constant)
        %> Max height is for plotting of the workspace
        maxHeight = 2;
    end
    
    properties
        %> Number of tables
        tableCount = 1;
        
        %> A cell structure of \c tableCount table models
        table;
        
        %> workspace in meters
        workAreaSize = [2,2];        
        
        %> Dimensions of the workspace
        workspaceDimensions;
    end
    
    methods
        %% ...structors
        function self = getTable(tableCount)
            if 0 < nargin
                self.tableCount = tableCount;
            end
            
            self.workspaceDimensions = [-self.workAreaSize(1)/2, self.workAreaSize(1)/2 ...
                                       ,-self.workAreaSize(2)/2, self.workAreaSize(2)/2 ...
                                       ,0,self.maxHeight];
            
            T1 = eye(4)*transl(0,0,0)*trotx(deg2rad(180))*troty(deg2rad(0))*trotz(deg2rad(0));
            
          

            % Create the required number of tables
            
                self.table = self.GetTableModel('table');
                % Spawn at locations
                self.table.base = T1;
                 % Plot 3D model
                C = {'green'};
                 plot3d(self.table,0,'workspace',self.workspaceDimensions,'delay',0,'color',C);
                             
                   
           

            axis equal
            camlight;
       
        
        function delete(self)
%             cla;
        end       
        
        end
    end
  
    
    methods (Static)
       
        %% GetTableModel
        function model = GetTableModel(name)
            if nargin < 1
                name = 'table';
            end
            [faceData,vertexData] = plyread('PokerTable.ply','tri');
            L1 = Link('alpha',0,'a',0,'d',0,'offset',0);
            model = SerialLink(L1,'name',name);
            model.faces = {faceData,[]};
            vertexData(:,2) = vertexData(:,2);
            model.points = {vertexData * rotx(pi),[]};
        
        
    end    
    end
end
