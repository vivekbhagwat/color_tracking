function [ ] = DoorFinder(serPort)

    img = GetImage();
    
    color = [59 59 83]; %tbd, supposed to be a blue door.
    
    center = size(img)/2;
    center = center(1:2);

    [~, area] = find_largest_blob(img, color);


    %will break from this loop
    %searches for blue
    sign = 1;
    while(area < 150) %tbd
        SetFwdVelRadiusRoomba(serPort,20, sign*2); %tbd
        pause(1.0); %tbd
        sign = sign*-1;
        img = GetImage();
        [~, area] = find_largest_blob(img, color);
    end
    
    img = GetImage();
    [position, area] = find_largest_blob(img, color);
    
    angle = findBottomEdgeAngle(img, color);%45; %THIS WILL USE NATHAN'S METHOD
    turnSpeed = 0.03;
    turnAngle(serPort, turnSpeed, angle);
    
    
    dx = (position - center)/center(1);
    SetFwdVelAngVelCreate(serPort, 0.1, 0);
    pause(0.5);
    turnAngle(serPort,turnSpeed,-1*sign(round(angle)));    
    
    
    %should be perpendicular to door at this point.
    
    while(abs(dx) > 0.1)
        turnAngle(serPort,turnSpeed,sign(dx)*90);
        pause(0.5);
        SetFwdVelAngVelCreate(serPort,0.1,0);
        pause(0.5);
        turnAngle(serPort,turnSpeed,-1*sign(dx)*90);
        
        img = GetImage();
        [position, area] = find_largest_blob(img, color);
    
        dx = (position - center)/center(1);
    end
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
    %move until bump
    for i = 1:2
        [br,bl, wr,wl,wc, bf] = BumpsWheelDropsSensorsRoomba(serPort);
        while ~(br || bl || bf)
            %move forward.
        end
    end
    %move back
    %move until bump
    %move back
    %pause and emit sound
    %move forward into the room.
    
end


