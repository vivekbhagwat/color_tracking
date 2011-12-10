function [ ] = main( serPort )

img = GetImage();
color = ChoosePoint(img);
center = size(img)/2;
center = center(1:2);

[~, area] = find_largest_blob(img, color);

while (1)
    img = GetImage();
    [position, new_area] = find_largest_blob(img, color);

    % we only care about the differences
    dpos = (position - center)/center(1);
    darea = new_area/area;
    ReactToBlob(serPort, dpos(1), darea);
end

end

