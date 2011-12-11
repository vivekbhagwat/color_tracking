function [ react ] = ReactToBlob( serPort, dx, darea)
% dpos = number between (-1.0, 1.0), 

angle_gain = pi/6; % maximum angular speed
forward_speed = 0.03; % base speed

% thresholds to test against
scale_threshold = 0.2;
pos_threshold = 0.2;

% by default, don't do anything
angle = 0;
speed = 0;
react = 0;
% set the amount of angular velocity
if abs(dx) > pos_threshold
    angle = -sign(dx)*(abs(dx) - pos_threshold)*angle_gain;
    react = 1;
end
% set the amount of forward speed
if darea > 1.0 + scale_threshold
    speed = -forward_speed * darea;
    react = 1;
elseif darea < 1.0 - scale_threshold
    speed = forward_speed * (2 - darea);
    react = 1;
end

% actually actuate
SetFwdVelAngVelCreate(serPort, speed, angle);

end