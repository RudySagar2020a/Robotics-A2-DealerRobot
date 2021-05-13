classdef People < handle
    
    properties
        model;
        location;
        workspace;
        plyData;
    end
    
    methods
        function self = People(workspace, modelName, location)
            self.plotAndColour(workspace, modelName, location)
        end
        
        function plotAndColour(self, workspace, modelName, location)
            for linkIndex = 0:1
                [faceData, vertexData, plyData{linkIndex+1}] = plyread ...
                    ([modelName,'.ply'],'tri');
                self.model.faces{linkIndex+1} = faceData;
                self.model.points{linkIndex+1} = vertexData;
            end
            
            % Instantiate a 1-Link item
            L1 = Link('alpha',0, 'a',0, 'd',0, 'offset',0);
            
            self.model = SerialLink(L1,'name',[modelName,'_']);
            self.model.faces = {faceData,[]};
            self.model.points = {vertexData,[]};
            
            % 3D plot the Item within workspace
            self.model.base = location;
            self.model.plot3d(0, 'workspace', workspace)
            
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
    end
end