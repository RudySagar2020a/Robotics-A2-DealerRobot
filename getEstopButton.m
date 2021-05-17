classdef getEstopButton < handle
   
    properties (Constant)
        %> Max height is for plotting of the workspace
        maxHeight = 3;
    end
    
    properties
        %> Number of tables
        EstopButtonCount = 1;
        
        %> A cell structure of \c tableCount table models
        EstopButton;
        
        %> workspace in meters
        workAreaSize = [2,2];        
        
        %> Dimensions of the workspace
        workspaceDimensions = [-2 2 -2 2 0 2.5];
    end
    
    methods
        %% ...structors
        function self = getEstopButton(EstopButtonCount)
            if 0 < nargin
                self.EstopButtonCount = EstopButtonCount;
            end
            
            T1 = eye(4)*transl(0,-0.28,0.84)*trotx(deg2rad(0))*troty(deg2rad(0))*trotz(deg2rad(0));
            
          

            % Create the required number of Estops
               [f,v,data] = plyread('EstopButton.ply','tri');  % where f is faceData and v is vertexData
   
   
            EstopButtonVertexCount = size(v,1);
   
            midPoint = sum(v)/EstopButtonVertexCount;
            EstopButtonVerts = v - repmat(midPoint,EstopButtonVertexCount,1);
   
            EstopButtonPose = T1;
   
            vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
   
            estopbutton_h = trisurf(f,v(:,1),v(:,2), v(:,3)-0.147 ...
                ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');

            axis([-5,5,-5,5,-2,3]);

   updatedPoints = [EstopButtonPose *[EstopButtonVerts,ones(EstopButtonVertexCount,1)]']';
   
   estopbutton_h.Vertices = updatedPoints(:,1:3);
   


   camlight;
   axis equal;
   view (3);
   hold on;
        
        end
    end
  
    
    methods (Static)
       
        %% GetEstopButtonModel
        function model = GetEstopButtonModel(name)
            if nargin < 1
                name = 'EstopButton';
            end
            [faceData,vertexData] = plyread('EstopButton.ply','tri');
            L1 = Link('alpha',0,'a',0,'d',0,'offset',0);
            model = SerialLink(L1,'name',name);
            model.faces = {faceData,[]};
            vertexData(:,2) = vertexData(:,2);
            model.points = {vertexData * rotx(pi),[]};
        
    end    
    end
end
