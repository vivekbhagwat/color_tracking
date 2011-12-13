function [ mask ] = ThresholdColor( img, color )
% utility function

range = 5;
ext_range = 120;

color = double(color);
red_color = color(1);
green_color = color(2);
blue_color = color(3);

red = double(img(:,:,1));
green = double(img(:,:,2));
blue = double(img(:,:,3));

% r/g, r/b
prop = [red_color/green_color, red_color/blue_color];
prop_thresh = 0.18;
dproportions = sqrt((prop(1) - red./green).^2 +...
                   (prop(2) - red./blue).^2);

prop_mask = dproportions < prop_thresh;

%m = max(max(prop_mask));
%prop_mask = uint8(((255*prop_mask)/m).^1);
%imshow(prop_mask);

mask = sqrt((red   - red_color).^2+ ...
            (green - green_color).^2+ ...
            (blue  - blue_color).^2)...
            < range + ext_range * prop_mask;
end

