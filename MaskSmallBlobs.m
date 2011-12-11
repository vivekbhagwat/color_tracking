function [ mask ] = MaskSmallBlobs( img )
% lifted 50% off from find_largest_blob

blob_pixel_mask = img;

blobs = zeros(size(blob_pixel_mask,1), size(blob_pixel_mask,2));

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

[area, biggest_blob_index] = max(blob_counter);

area_dims = size(area);
if area_dims(1) == 0
    mask = -1;
    return
end

mask = zeros(size(blob_pixel_mask,1), size(blob_pixel_mask,2));
% scan through and only let the biggest mask through
for i = 1:size(blobs,1)
    for j = 1:size(blobs,2)
        if(blobs(i,j) == biggest_blob_index)
            mask(i,j) = 1;
        end
    end
end

end