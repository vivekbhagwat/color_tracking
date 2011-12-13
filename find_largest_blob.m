function [middle, area] = find_largest_blob( img, color )

% find all the colors similar to the given
blob_pixel_mask = ThresholdColor(img, color);

blobs = zeros(size(blob_pixel_mask,1), size(blob_pixel_mask,2));

imshow(blob_pixel_mask)

current_blob = 0;

blob_mapper = [];
blob_counter = [];

% go through and assign labels
for i = 1:size(blob_pixel_mask,1)
    for j = 1:size(blob_pixel_mask,2)
        if(blob_pixel_mask(i,j) == 1)
            if(i > 1 && j > 1 && ...
                    blobs(i-1,j) ~= blobs(i,j-1) && ...
                    blobs(i-1,j) ~= 0 && blobs(i,j-1) ~= 0)
                % follow labels backwards to top
                uplabel = blobs(i,j-1);
                lowlabel = blobs(i-1,j);
                while blob_mapper(uplabel) ~= uplabel
                    uplabel = blob_mapper(uplabel);
                end
                while blob_mapper(lowlabel) ~= lowlabel
                    lowlabel = blob_mapper(lowlabel);
                end
                if uplabel ~= lowlabel
                    blob_mapper(lowlabel) = uplabel;
                end
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

% fix equivalencies
for i = 1:size(blobs,1)
    for j = 1:size(blobs,2)
        if(blobs(i,j) == 0)
            continue
        end
        label = blobs(i,j);
        while(blob_mapper(label) ~= label)
            label = blob_mapper(label);
        end
        blobs(i,j) = label;
        blob_counter(blobs(i,j)) = blob_counter(blobs(i,j)) + 1;
    end
end

[area,biggest_blob_index] = max(blob_counter);
disp(blob_counter);


area_dims = size(area);
if area_dims(1) == 0
    area = -1;
    middle = [0,0];
    return
end

% find the center
sum_x = 0;
sum_y = 0;
for i = 1:size(blobs,1)
    for j = 1:size(blobs,2)
        if(blobs(i,j) == biggest_blob_index)
            % flipped indicies, array access is backwards
            sum_y = sum_y + i;
            sum_x = sum_x + j;
        end
    end
end

disp(size(area));
middle = [sum_x / area, sum_y / area];

% DEBUG
%c = round(middle);
%dim = size(img);
%ly = max(c(1) - 10, 1); uy = min(c(1) + 10, dim(2));
%lx = max(c(2) - 10, 1); ux = min(c(2) + 10, dim(1));
%img([ly:uy], [lx:ux],:) = 255;
%img = uint8(img);
%imshow(img)

disp(middle);
disp(area);

end
