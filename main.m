function [ ] = main( serPort )

img = GetImage();
color = ChoosePoint(img);
center = size(img)/2;
% b/c we flip all the x/y in matlab
center = [center(2), center(1)];

[~, area] = find_largest_blob(img, color);

while (1)
    try
        % find the largest blob of the given color
        img = GetImage();
        [position, new_area] = find_largest_blob(img, color);
        %if new_area < 0
        %    ReactToBlob(serPort, 0.0, 1.0);
        %    continue
        %end

        % we only care about the differences
        dpos = (position - center)/center(1);
        darea = new_area/area;
        disp([dpos(1), darea]);
        ReactToBlob(serPort, dpos(1), darea);
    catch err
        disp(err);
        % stop the robot, prevent robot chases
        ReactToBlob(serPort, 0.0, 1.0);
    end
end

end

