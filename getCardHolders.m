classdef getCardHolders < handle
   
    
    properties (Constant)
        %> Max height is for plotting of the workspace
        maxHeight = 2;
    end
    
    properties
        %> Number of cardHolders
        cardHolderCount = 11;
        
        %> A cell structure of \c cardHolderCount cardHolder models
        cardHolder;
        
        %> paddockSize in meters
        workAreaSize = [2,2];        
        
        %> Dimensions of the workspace in regard to the padoc size
        workspaceDimensions;
    end
    
    methods
        %% ...structors
        function self = getCardHolders(cardHolderCount)
            if 0 < nargin
                self.cardHolderCount = cardHolderCount;
            end
            
            self.workspaceDimensions = [-self.workAreaSize(1)/2, self.workAreaSize(1)/2 ...
                                       ,-self.workAreaSize(2)/2, self.workAreaSize(2)/2 ...
                                       ,0,self.maxHeight];
           degBetPlayers = 70;
                                               
            ch1 = eye(4)*transl(.6*cos(deg2rad(90+degBetPlayers)),.6*sin(deg2rad(90+degBetPlayers)),.97)*trotz(deg2rad(degBetPlayers))*transl(-.0345,0,0);
            ch2 = eye(4)*transl(0,.6,.97)*transl(-.0345,0,0);
            ch3 = eye(4)*transl(.6*cos(deg2rad(90-degBetPlayers)),.6*sin(deg2rad(90-degBetPlayers)),.97)*trotz(deg2rad(-degBetPlayers))*transl(-.0345,0,0);
            ch4 = eye(4)*transl(.6*cos(deg2rad(90+degBetPlayers)),.6*sin(deg2rad(90+degBetPlayers)),.97)*trotz(deg2rad(degBetPlayers))*transl(.0345,0,0);
            ch5 = eye(4)*transl(0,.6,.97)*transl(.0345,0,0);
            ch6 = eye(4)*transl(.6*cos(deg2rad(90-degBetPlayers)),.6*sin(deg2rad(90-degBetPlayers)),.97)*trotz(deg2rad(-degBetPlayers))*transl(.0345,0,0);
            ch7 = eye(4)*transl(.138,.15,.97)*trotz(pi);
            ch8 = eye(4)*transl(.069,.15,.97)*trotz(pi);
            ch9 = eye(4)*transl(0,.15,.97)*trotz(pi);
            ch10 = eye(4)*transl(-.069,.15,.97)*trotz(pi);
            ch11 = eye(4)*transl(-.138,.15,.97)*trotz(pi);
            
            
            
            
           chlocs = {[ch1] [ch2] [ch3] [ch4] [ch5] [ch6] [ch7] [ch8] [ch9] [ch10] [ch11]};
                
           for i=1:11
                self.cardHolder{i} = self.GetcardHolderModel(['cardHolder',num2str(i)]);
                % Spawn at locations
                self.cardHolder{i}.base = chlocs{i}*trotx(-pi/2);
                 % Plot 3D model
                plot3d(self.cardHolder{i},0,'workspace',self.workspaceDimensions,'delay',0);
                % Hold on after the first plot (if already on there's no difference)
                if i == 1 
                    hold on;
                end
            end

            axis equal
            camlight;
        end
        
        function delete(self)
%             cla;
        end       
        
        
    end
    
    methods (Static)
        %% GetcardHolderModel
        function model = GetcardHolderModel(name)
            if nargin < 1
                name = 'cardHolder';
            end
            [faceData,vertexData] = plyread('cardHolder.ply','tri');
            L1 = Link('alpha',0,'a',0,'d',0,'offset',0);
            model = SerialLink(L1,'name',name);
            model.faces = {faceData,[]};
            vertexData(:,2) = vertexData(:,2);
            model.points = {vertexData,[]};
        end
    end    
end

