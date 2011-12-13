function [] = RoombaSong(serPort);

try
    %Flush Buffer    
    N = serPort.BytesAvailable();
    while(N~=0) 
    fread(serPort,N);
    N = serPort.BytesAvailable();
    end

    global td
    fwrite(serPort, [140 1 2 69 64 81 64])
    pause(td)
    
    fwrite(serPort, [141 1])
    pause(td)
catch err
    disp(strcat('WARNING:  function did not terminate correctly.',...
        'Output may be unreliable.',...
        err))
end


