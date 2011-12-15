function [ ] = DoorFinder(serPort)

    img = GetImage();
    
    color = [60 70 90]; %tbd, supposed to be a blue door.
    
    center = size(img)/2;
    center = center(1:2);

    [~, area] = find_largest_blob(img, color);


    %will break from this loop
    %searches for blue
%     mult = 1;
    while(area < 8000) %tbd
%         SetFwdVelRadiusRoomba(serPort,.05, mult*.2); %tbd
%         pause(1.5 - mult/4.0); %tbd
%         mult = mult*-1;
        SetFwdVelRadiusRoomba(serPort,.05,0);
        disp(area);
        img = GetImage();
        [~, area] = find_largest_blob(img, color);
    end
    SetFwdVelRadiusRoomba(serPort,0,0);
    
    disp('area = ');
    disp(area);
    
    img = GetImage();
    [position, area] = find_largest_blob(img, color);
    
%     angle = findBottomEdgeAngle(img, color);
%     angle = sign(angle)*(90-abs(angle));
%     turnSpeed = 0.03;
%     turnAngle(serPort, turnSpeed, angle);
%     disp('turned angle');
%     disp(angle);
%     
%     dx = -1*sign(angle);%(position - center)/center(1);
%     SetFwdVelAngVelCreate(serPort, 0.1, 0);
%     pause(0.5);
% %     disp(-1*sign(round(angle)));
% %     turnAngle(serPort,turnSpeed,-1*round(angle));    
%     
%     
%     %should be perpendicular to door at this point.
%     setFwdVelAngVelCreate(serPort,0,0);
%     while(abs(dx) > 0.1)
%         disp('this is in the loop');
%         turnAngle(serPort,turnSpeed,sign(dx)*90);
%         pause(0.5);
%         SetFwdVelAngVelCreate(serPort,0.1,0);
%         pause(0.5);
%         SetFwdVelAngVelCreate(serPort,0,0);
%         turnAngle(serPort,turnSpeed,-1*sign(dx)*90);
%         
%         img = GetImage();
%         [position, area] = find_largest_blob(img, color);
%     
%         dx = (position - center)/center(1);
%     end
    %centers on door
    
    
    
%     while(abs(dx) > 0.1) %fix
%         dx = (position - center)/center(1);
%         SetFwdVelAngVelCreate(serPort, 0, sign(dx) * pi/6);
%         
%         
%         img = GetImage();
%         [position, area] = find_largest_blob(img, color);
%     
%         dx = (position - center)/center(1);
%     end

    function untilBump()
        br = NaN;
        bl = NaN;
        bf = NaN;
        while ~(br == 1 || bl == 1 || bf == 1)
            try
                [br,bl, ~,~,~, bf] = BumpsWheelDropsSensorsRoomba(serPort);
            catch err
                disp(err);
                continue
            end
        end
    end

    fwd_speed = 0.06;
    %move until bump
    SetFwdVelAngVelCreate(serPort, fwd_speed, 0);
    untilBump();
    SetFwdVelAngVelCreate(serPort, 0, 0);
    %move back
    travelDist(serPort, fwd_speed, -0.2);
    %move until bump
    SetFwdVelAngVelCreate(serPort, fwd_speed, 0);
    untilBump();
    SetFwdVelAngVelCreate(serPort, 0, 0);
    %move back
    travelDist(serPort, fwd_speed, -0.2);
    %pause and emit sound
    RoombaSong(serPort);
    pause(5.0);
    %move forward into the room. Assume the room is infinite in size
    SetFwdVelAngVelCreate(serPort, fwd_speed, 0);
end
