%% Robotics
% Lab 8 - Visual Servoing with UR10 
function [  ] = VisualSurvoing(robot,cards,CH)
%% 1.1 Definitions

ch1Corner1 = CH.cardHolder{1}.base*transl(-.03175,0,.04445);
ch1Corner2 = CH.cardHolder{1}.base*transl(.03175,0,.04445);
ch1Corner3 = CH.cardHolder{1}.base*transl(-.03175,0,-.04445);
ch1Corner4 = CH.cardHolder{1}.base*transl(.03175,0,-.04445);

ch1_3dPoints = {[ch1Corner1(1,4);ch1Corner1(2,4);ch1Corner1(3,4)] [ch1Corner2(1,4);ch1Corner2(2,4);ch1Corner2(3,4)] [ch1Corner3(1,4);ch1Corner3(2,4);ch1Corner3(3,4)] [ch1Corner4(1,4);ch1Corner4(2,4);ch1Corner4(3,4)]};
               
%Points in cam frame
camTr = transl(0,.3,2.2)*trotx(pi);
z = camTr(3,4)-ch1_3dPoints{1}(3,1);
ch1_camPoints = {[ch1Corner1(1,4);-ch1Corner1(2,4)+.3;z] [ch1Corner2(1,4);-ch1Corner2(2,4)+.3;z] [ch1Corner3(1,4);-ch1Corner3(2,4)+.3;z] [ch1Corner4(1,4);-ch1Corner4(2,4)+.3;z]};

f = 0.08;
camResolution = [1024 1024];
principlePoint = [512 512];
pixWidth = 10e-5;    %pixel height = pixel width
cam2pixConvMatrix = [f/pixWidth,0,principlePoint(1);
                    0,f/pixWidth,principlePoint(2);
                    0,0,1];

             
%%  

% Create image target (points in the image plane) 
ch1Drop = [662 362 362 662; 362 362 662 662];

%Create 3D points
P=[ch1Corner1(1,4),ch1Corner2(1,4),ch1Corner3(1,4),ch1Corner4(1,4);
ch1Corner1(2,4),ch1Corner2(2,4),ch1Corner3(2,4),ch1Corner4(2,4);
 ch1Corner1(3,4),ch1Corner2(3,4),ch1Corner3(3,4),ch1Corner4(3,4)];         

% Add the camera
cam = CentralCamera('focal', f, 'pixel', pixWidth,'resolution', camResolution, 'centre', principlePoint,'name', 'SkyCam');

% frame rate
fps = 25;

%Define values
%gain of the controler
lambda = 0.6;
%depth of the IBVS
depth = mean (P(1,:));

%% 1.2 Initialise Simulation (Display in 3D)

% plot camera and points
cam.T = camTr;

% Display points in 3D and the camera
cam.plot_camera('Tcam',cam.T, 'label','scale',0.15);
plot_sphere(P, 0.05, 'b')
lighting gouraud
light

%% 1.3 Initialise Simulation (Display in Image view)

%Project points to the image
p = cam.plot(P, 'Tcam', cam.T);

%camera view and plotting
cam.clf()
cam.plot(ch1Drop, '*'); % create the camera view
cam.hold(true);
cam.plot(P, 'Tcam', cam.T, 'o'); % create the camera view
pause(2)
cam.hold(true);
cam.plot(P);    % show initial view


%Initialise display arrays
vel_p = [];
uv_p = [];
history = [];

%% 1.4 Loop
% loop of the visual servoing
ksteps = 0;
 while true
        ksteps = ksteps + 1;
        
        % compute the view of the camera
        uv = cam.plot(P);
        
        % compute image plane error as a column
        e = ch1Drop-uv;   % feature error
        e = e(:);
        Zest = [];
        
        % compute the Jacobian
        if isempty(depth)
            % exact depth from simulation (not possible in practice)
            pt = homtrans(inv(Tcam), P);
            J = cam.visjac_p(uv, pt(3,:) );
        elseif ~isempty(Zest)
            J = cam.visjac_p(uv, Zest);
        else
            J = cam.visjac_p(uv, depth );
        end

        % compute the velocity of camera in camera frame
        try
            v = lambda * pinv(J) * e;
        catch
            status = -1;
            return
        end
        fprintf('v: %.3f %.3f %.3f %.3f %.3f %.3f\n', v);

        %compute robot's Jacobian and inverse
        J2 = r.model.jacobn(q0);
        Jinv = pinv(J2);
        % get joint velocities
        qp = Jinv*v;

         
         %Maximum angular velocity cannot exceed 180 degrees/s
         ind=find(qp>pi);
         if ~isempty(ind)
             qp(ind)=pi;
         end
         ind=find(qp<-pi);
         if ~isempty(ind)
             qp(ind)=-pi;
         end

        %Update joints 
        q = q0 + (1/fps)*qp;
        r.model.animate(q');

        %Get camera location
        Tc = r.model.fkine(q);
        cam.T = Tc;

        drawnow
        
        % update the history variables
        hist.uv = uv(:);
        vel = v;
        hist.vel = vel;
        hist.e = e;
        hist.en = norm(e);
        hist.jcond = cond(J);
        hist.Tcam = Tc;
        hist.vel_p = vel;
        hist.uv_p = uv;
        hist.qp = qp;
        hist.q = q;

        history = [history hist];

         pause(1/fps)

        if ~isempty(200) && (ksteps > 200)
            break;
        end
        
        %update current joint position
        q0 = q;
 end %loop finishes
 
%% 1.5 Plot results
figure()            
plot_p(history,ch1Drop,cam)
figure()
plot_camera(history)
figure()
plot_vel(history)
figure()
plot_robjointpos(history)
figure()
plot_robjointvel(history)

end

%% Functions for plotting

 function plot_p(history,uv_star,camera)
            %VisualServo.plot_p Plot feature trajectory
            %
            % VS.plot_p() plots the feature values versus time.
            %
            % See also VS.plot_vel, VS.plot_error, VS.plot_camera,
            % VS.plot_jcond, VS.plot_z, VS.plot_error, VS.plot_all.
            
            if isempty(history)
                return
            end
            figure();
            clf
            hold on
            % image plane trajectory
            uv = [history.uv]';
            % result is a vector with row per time step, each row is u1, v1, u2, v2 ...
            for i=1:numcols(uv)/2
                p = uv(:,i*2-1:i*2);    % get data for i'th point
                plot(p(:,1), p(:,2))
            end
            plot_poly( reshape(uv(1,:), 2, []), 'o--');
            uv(end,:)
            if ~isempty(uv_star)
                plot_poly(uv_star, '*:')
            else
                plot_poly( reshape(uv(end,:), 2, []), 'rd--');
            end
            axis([0 camera.npix(1) 0 camera.npix(2)]);
            set(gca, 'Ydir' , 'reverse');
            grid
            xlabel('u (pixels)');
            ylabel('v (pixels)');
            hold off
        end

       function plot_vel(history)
            %VisualServo.plot_vel Plot camera trajectory
            %
            % VS.plot_vel() plots the camera velocity versus time.
            %
            % See also VS.plot_p, VS.plot_error, VS.plot_camera,
            % VS.plot_jcond, VS.plot_z, VS.plot_error, VS.plot_all.
            if isempty(history)
                return
            end
            clf
            vel = [history.vel]';
            plot(vel(:,1:3), '-')
            hold on
            plot(vel(:,4:6), '--')
            hold off
            ylabel('Cartesian velocity')
            grid
            xlabel('Time')
            xaxis(length(history));
            legend('v_x', 'v_y', 'v_z', '\omega_x', '\omega_y', '\omega_z')
        end

        function plot_camera(history)
            %VisualServo.plot_camera Plot camera trajectory
            %
            % VS.plot_camera() plots the camera pose versus time.
            %
            % See also VS.plot_p, VS.plot_vel, VS.plot_error,
            % VS.plot_jcond, VS.plot_z, VS.plot_error, VS.plot_all.

            if isempty(history)
                return
            end
            clf
            % Cartesian camera position vs time
            T = reshape([history.Tcam], 4, 4, []);
            subplot(211)
            plot(transl(T));
            ylabel('camera position')
            grid
            subplot(212)
            plot(tr2rpy(T))
            ylabel('camera orientation')
            grid
            xlabel('Time')
            xaxis(length(history));
            legend('R', 'P', 'Y');
            subplot(211)
            legend('X', 'Y', 'Z');
        end

        function plot_robjointvel(history)
          
            if isempty(history)
                return
            end
            clf
            vel = [history.qp]';
            plot(vel(:,1:6), '-')
            hold on
            ylabel('Joint velocity')
            grid
            xlabel('Time')
            xaxis(length(history));
            legend('\omega_1', '\omega_2', '\omega_3', '\omega_4', '\omega_5', '\omega_6')
        end

 function plot_robjointpos(history)
          
            if isempty(history)
                return
            end
            clf
            pos = [history.q]';
            plot(pos(:,1:6), '-')
            hold on
            ylabel('Joint angle')
            grid
            xlabel('Time')
            xaxis(length(history));
            legend('\theta_1', '\theta_2', '\theta_3', '\theta_4', '\theta_5', '\theta_6')
        end
     