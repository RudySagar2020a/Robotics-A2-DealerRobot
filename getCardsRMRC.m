%%getCardRMRC
classdef getCardsRMRC < handle
    
    properties (Constant)
        %> Max height is for plotting of the workspace
        maxHeight = 3;
    end
    
    properties
        %> Number of cards
        cardCount = 14;
        model;
        location;
        
        %> A cell structure of \c cardCount card models
        card;
        
        %> paddockSize in meters
        workAreaSize = [2,2];
        
        %> Dimensions of the workspace in regard to the padoc size
        workspaceDimensions = [-2 2 -2 2 0 2.5];
    end
    
    methods
        %% ...structors
        function self = getCardsRMRC(cardCount)
            if 0 < nargin
                self.cardCount = cardCount;
            end
            
%             self.workspaceDimensions = [-self.workAreaSize(1)/2,...
%                 self.workAreaSize(1)/2,-self.workAreaSize(2)/2,...
%                 self.workAreaSize(2)/2, 0, self.maxHeight];
            
            cardLocation = transl(-0.6,0,1)*trotz(pi/2)*trotx(-pi/2);
            
            C = {'white'};
            for i=1:14
                self.card{i} = self.GetCardModel(['card',num2str(i)]);
               
                % Spawn at locations
                self.card{i}.base = cardLocation;
                
                % Plot 3D model
                plot3d(self.card{i},0,'workspace',self.workspaceDimensions,'delay',0,'color',C);
                % Hold on after the first plot (if already on there's no difference)
                if i == 1
                    hold on;
                end
            end
            
            axis equal
%             camlight;
        end
        
        function delete(self)
            % delete cards when necessary
        end
        
    end
    
    methods (Static)
        %% GetcardModel
        function model = GetCardModel(name)
            if nargin < 1
                name = 'card';
            end
            [faceData,vertexData,data] = plyread('Card.ply','tri');
            L1 = Link('alpha',0,'a',0,'d',0,'offset',0);
            model = SerialLink(L1,'name',name);
            model.faces = {faceData,[]};
            vertexData(:,2) = vertexData(:,2);
            model.points = {vertexData,[]};
            
        end
        
    end
end
