function [ img ] = GetImage()
% just a convenience function

% ddns of robot
domain = 'adirobot.myipcamera.com';

img = imread(strcat('http://',domain,...
    '/img/snapshot.cgi?=3&quality=1'));
end

