function [ react ] = ReactToBlob( serPort, dpos, darea)

angle_gain = 1.0;

% we only care about the x coordinate
dx = dpos(1);

% amount of turn
angle = angle_gain*dx;
% use log: 0->infty, 1.0->0.0
radius = (angle/abs(angle))*(-log(abs(angle)));

% whether to move forward or back
react = 1;
if darea > 1.0 + scale_threshold
    setFwdVelRadiusRoomba(serPort, forward_speed, radius);
elseif darea < 1.0 - scale_threshold
    setFwdVelRadiusRoomba(serPort, -forward_speed, radius);
else
    react = 0;
end

end

