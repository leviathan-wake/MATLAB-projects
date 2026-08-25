%function to create a visual overlay indicating movement
%uses both an alert icon and a moveable red box

function[] = alertMove(im1, im2, caution)
    
    %%image cleanup
    diff = rgb2gray(im2-im1);

    logicalDiff = diff > 30;  %stricter value than in calcDelta so the rectangle isn't as large

    cleanedDiff = diff .* 0;
    cleanedDiff(logicalDiff) = diff(logicalDiff);

    bw = bwareaopen(cleanedDiff, 10); %converts to bw and further cleans image, will make it easier for the script to detect objects


    %% detects objects (areas of motion) and stores their metadata in cc
    cc = bwconncomp(bw, 8);
    

    %% getting coordinates of the detected objects
    S = regionprops(cc, "Centroid");
    cen = cat(1, S.Centroid); %2d array with x, y columns
    

    %% getting x and y coordinates of the overall area of movement
    x = min(cen(:, 1));
    y = min(cen(:, 2));
    width = max(cen(:,1)) - x;
    height = max(cen(:,2)) - y;
    

    %% plotting red box over movement-detected area
    figure(1)
    hold on %because the current image feed is still in figure 1
    %plot(cen(:,1), cen(:,2), '*r'); %would plot centers of movement area
    drawrectangle("Position", [x, y, width, height], "Color", "r");
    imshow(caution);
    hold off;


end
