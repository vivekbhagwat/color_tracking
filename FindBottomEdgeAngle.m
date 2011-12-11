function [ theta ] = FindBottomEdgeAngle( img, color )
% TEST 60, 150, 50
% given an image of a door, find angle (deg) at which we are viewing it

img = double(img);

% blur it
gaussian5 = 1/159*reshape([[2,4,5,4,2], [4,9,12,9,4], [5,12,15,12,5],...
                           [4,9,12,9,4], [2,4,5,4,2]], 5,5);
r_blur = conv2(gaussian5, double(img(:,:,1)));
g_blur = conv2(gaussian5, double(img(:,:,2)));
b_blur = conv2(gaussian5, double(img(:,:,3)));
blur_img = cat(3, r_blur, g_blur, b_blur);

% threshold it
thresh = ThresholdColor(blur_img, color);
thresh = double(thresh);

% find biggest blob, clear all but that one
big_blob_mask = MaskSmallBlobs( thresh );

% apply the sobel edge detector on it
sobeldx = reshape([[-1,0,1],[-2,0,2],[-1,0,1]], 3,3);
sobeldy = reshape([[-1,-2,-1],[0,0,0],[1,2,1]], 3,3);

edge_img = sqrt(conv2(sobeldx, big_blob_mask).^2 + ...
                conv2(sobeldy, big_blob_mask).^2);

% run a line hough transform on it
h_array = zeros(150,150); % accumulator array (theta, rho)
max_r = sqrt(size(edge_img,1).^2 + size(edge_img,2).^2);
edge_img = edge_img > 0.5; % thresh the edge
for i = 1:size(edge_img,1)
    for j = 1:size(edge_img,2)
        for a = 1:size(h_array,1)
            theta = a/size(h_array,1)*2*pi;
            % flip the image here
            rho = j*cos(theta) + i*sin(theta);
            r = round((rho/(2*max_r)+0.5)*size(h_array,2));
            r = min(max(r, 1), size(h_array, 2));
            h_array(a,r) = 1 + h_array(a,r);
        end
    end
end

% DEBUG convert to uint
%m = max(max(h_array));
%h_array = uint8(255*(h_array/m).^1);
%imshow(h_array);

% find the local maxima
% can get a better max with iterative max(max())
h_max = max(max(h_array));
h_array = double(h_array > 0.98*h_max);

% reject non-horizontal lines
a_thresh = 45;
th_bounds90 = [((90-a_thresh)*pi/180),...
                  ((90+a_thresh)*pi/180)];
th_bounds270 = [((270-a_thresh)*pi/180),...
                   ((270+a_thresh)*pi/180)];
% find lowest line
midx = round(size(img, 2)/2);
miny = size(img, 1);
minth = -1;
minr = -1;
figure
hold off
clf
hold on
for i = 1:size(h_array,1)
    for j = 1:size(h_array,2)
        if h_array(i,j) == 0
            continue
        end
        theta = i/size(h_array,1) * pi;
        r = (j/size(h_array,2)-0.5) * 2*max_r;
        x = 0:1:size(img,2);
        y = -cos(theta)/sin(theta)*x + r/sin(theta);
        disp([theta,r]);
        plot(x,y);
        if ~(theta > th_bounds90(1) && theta < th_bounds90(2) ||...
             theta > th_bounds270(1) && theta < th_bounds270(2))
            continue;
        end
        r = (j/size(h_array,2)-0.5) * 2*max_r;
        % find lowest y
        y = -cos(theta)/sin(theta)*midx + r/sin(theta);
        if y < miny && y > 0
            miny = y;
            minth = theta;
            minr = r;
        end
    end
end
disp(minth);
disp(minr);
disp(miny);

% find lowest line

end

