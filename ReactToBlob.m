function [ react ] = ReactToBlob( serPort, dx, darea)
% dpos = number between (-1.0, 1.0), 

angle_gain = 1.0;
forward_speed = 0.1;

scale_threshold = 0.5;
pos_threshold = 0.1;

% amount of turn
angle = angle_gain*dx;
% use log: 0->infty, 1.0->0.0
% radius = (angle/abs(angle))*(-log(abs(angle)));

% whether to move forward or back
react = 1;
if darea > 1.0 + scale_threshold
%     setFwdVelRadiusRoomba(serPort, forward_speed, radius);
    SetFwdVelAngVelCreate(serPort, -forward_speed, sign(dx)*pi/6);
elseif darea < 1.0 - scale_threshold
    SetFwdVelAngVelCreate(serPort, forward_speed, sign(dx)*pi/6);
elseif abs(dx) > pos_threshold
    SetFwdVelAngVelCreate(serPort, 0, sign(dx) * pi/6);
else
    react = 0;
    SetFwdVelAngVelCreate(serPort, 0, 0);
end

end
