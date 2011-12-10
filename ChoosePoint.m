function [ color ] = ChoosePoint( img )
%ChosePoint( image )
%   Takes an image, prompt user to choose point, return color of point

% init an empty color
color = [0,0,0];

f = figure;
i = image(img);

    function [] = HandleMouse(src, event)
        disp('mu');
    end

set(f, 'WindowButtonDownFcn', @HandleMouse);

disp('aoeu');

% wait for a mouse click
k = waitforbuttonpress;
while k ~= 0
    k = waitforbuttonpress;
end

end

