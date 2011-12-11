function [ mask ] = ThresholdColor( img, color )
% utility function

range = 80;

color = double(color);
red_color = color(1);
green_color = color(2);
blue_color = color(3);

% find RGB distance away from goal color
img = double(img);
mask = sqrt((1.0*img(:,:,1)-1.0*red_color).^2+ ...
            (1.0*img(:,:,2)-1.0*green_color).^2+ ...
            (1.0*img(:,:,3)-1.0*blue_color).^2) < range;
end

