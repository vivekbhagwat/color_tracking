function [ ] = main( serPort )

CAMERA_URL = 'adirobot.';

image = imread(strcat('http://http://', CAMERA_URL, ...
    '/img/snapshot.cgi?=3&quality=1'));
color = ChoosePoint(image);

while (1)
    % vivek's stuff
    
    pos = [];
    size = [];
    ReactToBlob(pos, size);
end

end

