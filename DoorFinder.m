function [ ] = DoorFinder(serPort)

    img = GetImage();
    
    color = [0 235 0]; %tbd, supposed to be a blue door.
    
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
    
    dx = (position - center)/center(1);
    %centers on door
    while(abs(dx) > 0.1) %fix
        dx = (position - center)/center(1);
        SetFwdVelAngVelCreate(serPort, 0, sign(dx) * pi/6);
        
        
        img = GetImage();
        [position, area] = find_largest_blob(img, color);
    
        dx = (position - center)/center(1);
    end
    %move until bump
    for i = 1:2
        [br,bl, wr,wl,wc, bf] = BumpsWheelDropsSensorsRoomba(serPort);
        while ~(br || bl || bf)
            
        end
    end
    %move back
    %move until bump
    %move back
    %pause and emit sound
    %move forward into the room.
    
end


