function [ ] = main( serPort )

img = GetImage();
color = ChoosePoint(img);

while (1)
    img = GetImage();
    % find_largest_blob();
    % vivek's stuff
    
    pos = [];
    size = [];
    ReactToBlob(pos, size);
end

end

