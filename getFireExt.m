classdef getFireExt< handle
   
    properties (Constant)
        %> Max height is for plotting of the workspace
        maxHeight = 3;
    end
    
    properties
        %> Number of fire extinguishers
        FireExtCount = 1;
        
        %> A cell structure of \c tableCount table models
        FireExt;
        
        %> workspace in meters
        workAreaSize = [2,2];        
        
        %> Dimensions of the workspace
        workspaceDimensions = [-2 2 -2 2 0 2.5];
    end
    
    methods
        %% ...structors
        function self = getFireExt(FireExtCount)
            if 0 < nargin
                self.FireExtCount = FireExtCount;
            end
            
            T1 = eye(4)*transl(0.5,-0.3,0.38)*trotx(deg2rad(0))*troty(deg2rad(0))*trotz(deg2rad(0));
            
          

            % Create the required number of Estops
               [f,v,data] = plyread('fireExtLP.ply','tri');  % where f is faceData and v is vertexData
   
   
            FireExtVertexCount = size(v,1);
   
            midPoint = sum(v)/FireExtVertexCount;
            FireExtVerts = v - repmat(midPoint,FireExtVertexCount,1);
   
            FireExtPose = T1;
   
            vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
   
            fireext_h = trisurf(f,v(:,1),v(:,2), v(:,3)-0.147 ...
                ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');

            axis([-5,5,-5,5,-2,3]);

   updatedPoints = [FireExtPose *[FireExtVerts,ones(FireExtVertexCount,1)]']';
   
   fireext_h.Vertices = updatedPoints(:,1:3);
   


   camlight;
   axis equal;
   view (3);
   hold on;
        
        end
    end
  
    
    methods (Static)
       
        %% GetEstopButtonModel
        function model = GetFireExt(name)
            if nargin < 1
                name = 'FireExt';
            end
            [faceData,vertexData] = plyread('fireExtLP.ply','tri');
            L1 = Link('alpha',0,'a',0,'d',0,'offset',0);
            model = SerialLink(L1,'name',name);
            model.faces = {faceData,[]};
            vertexData(:,2) = vertexData(:,2);
            model.points = {vertexData * rotx(pi),[]};
        
    end    
    end
end
