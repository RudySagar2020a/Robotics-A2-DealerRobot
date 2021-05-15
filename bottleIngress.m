%% Bottle Ingress

function [] = bottleIngress(Jack,bottle)
steps = 20;
for i = 1:steps
    Jack.model.base = Jack.model.base * trotz(deg2rad(45)/steps);
    animate(Jack.model,0);
    pause(0.03);
end
for i = 1:steps
    bottle.bottle.base = bottle.bottle.base * transl(0,-.1*tan(deg2rad(4.5)),0)*trotx(deg2rad(4.5));
    animate(bottle.bottle,0);
    pause(0.03);
end
pause(3);
for i = 1:steps
   Jack.model.base = Jack.model.base * trotz(-deg2rad(45)/steps);
    animate(Jack.model,0);
    bottle.bottle.base = bottle.bottle.base * trotx(-deg2rad(4.5))*transl(0,.1*tan(deg2rad(4.5)),0);
    animate(bottle.bottle,0);
    pause(0.05);
end




end