function [ color ] = ChoosePoint( img )
%ChosePoint( image )
%   Takes an image, prompt user to choose point, return color of point

f = figure();
image(img);

p = round(ginput(1));
disp(p);

color = img(p(2),p(1),:);
color = [color(1), color(2), color(3)];
disp(color);

close(f);

end
