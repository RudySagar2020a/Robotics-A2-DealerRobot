%% EXTRA INFORMATION FILE

%% Kinova Gen3 Lite DH parameters found on Datasheet on below website: 
% https://www.kinovarobotics.com/sites/default/files/...
% UG-017_KINOVA_Gen3_lite_robot_USER_GUIDE_EN_R01_0.pdf

% NOTE:
% theta - rotation about z-axis
% d     - translation along z-axis
% a     - translation along x-axis
% alpha - rotation about x-axis
% offset - kinematic joint coordinate offset (Nx1)



    % ADDED FOR THE ASSIGNMENT, RETURN BACK TO NOTHING ONCE COMPLETE
    % CHANGED POSE FOR A1 BELOW - transl(-X, Z, Y):
    % NEW CHANGE: (multiply base by location as you've already preset
    % location parameter and passing it to Get function when calling
    % in main. Now you can change location of base in Main.
    
        % NOTE: TO USE STICK MODEL, COMMENT OUT PLOTANDCOLOUR FUNCTION AND USE
    % THE PARAMETERS AND SETUP BELOW:
%         q = zeros(1,6);
%         self.model.plot(q,'workspace', workspace);
%         self.model.teach();