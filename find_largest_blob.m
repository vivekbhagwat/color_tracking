function [center, area] = find_largest_blob(img, color)

range = 20;
red_color = color(1); green_color = color(2); blue_color = color(3);

blob_pixel_mask = img(:,:,1) > red_color - range & ...
    img(:,:,1) < red_color + range * ...
    img(:,:,2) > blue_color - range & ...
    img(:,:,2) < blue_color + range & ...
    img(:,:,3) > green_color - range & ...
    img(:,:,3) < green_color + range;

%blob_pixel_mask is 2d array, 
imshow(blob_pixel_mask)

blobs = zeros(size(blob_pixel_mask,1), size(blob_pixel_mask,2));

disp(blob_pixel_mask)

current_blob = 0;

blob_mapper = [];
blob_counter = [];

for i = 1:size(blob_pixel_mask,1)
    for j = 1:size(blob_pixel_mask,2)
        if(blob_pixel_mask(i,j) == 1)
            if(i > 1 && j > 1 && ...
                    blobs(i-1,j) ~= blobs(i,j-1) && ...
                    blobs(i-1,j) ~= 0 && blobs(i,j-1) ~= 0)
                disp ' '
                disp(blobs(i,j-1));
                
                blob_mapper(blobs(i,j-1)) = blobs(i-1,j);
                blobs(i,j) = blobs(i,j-1);
            elseif(i > 1 && blob_pixel_mask(i-1,j) == 1)
                blobs(i,j) = blobs(i-1,j);
            elseif(j > 1 && blob_pixel_mask(i,j-1) == 1)
                blobs(i,j) = blobs(i,j-1);
            else
                current_blob = current_blob + 1;
                blob_mapper = [blob_mapper current_blob];
                blob_counter = [blob_counter 0];
                blobs(i,j) = current_blob;
            end
        end
    end
end

for i = 1:size(blobs,1)
    for j = 1:size(blobs,2)
        while(blob_mapper(blobs(i,j)) ~= blobs(i,j))
            blobs(i,j) = blob_mapper(blobs(i,j));
        end
        blob_counter(blobs(i,j)) = blob_counter(blobs(i,j)) + 1;
    end
end

biggest_blob_index = 1;
for i = 1:size(blob_counter)
    if blob_counter(i) > blob_counter(biggest_blob_index)
        biggest_blob_index = i;
    end
end

sum_x = 0;
sum_y = 0;
for i = 1:size(blobs,1)
    for j = 1:size(blobs,2)
        if(blobs(i,j) == biggest_blob_index)
            sum_x = sum_x + i;
            sum_y = sum_y + j;
        end
    end
end

area = blob_counter(biggest_blob_index);

center = [sum_x / area, sum_y / area];

disp(center);
disp(area);

% return [center, area];



