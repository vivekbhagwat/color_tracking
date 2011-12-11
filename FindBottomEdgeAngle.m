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

imshow(edge_img);
% run a line hough transform on it


% find lowest line

end

