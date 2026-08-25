%function to check if there's movement

function move = checkMovement(im1, im2, thresh)
    %use another function to calculate the delta value
    delta = calcDelta(im1, im2);
    
    %bc thresh is originally a fraction for the number of pixels with
    %change, uses the size of the image to get the actual number of pixels
    %iwth change needed
    [l, w] = size(im1);
    pixelThresh = thresh * (l * w);

    %checks if delta over thresh, returns boolean true if delta over thresh
    if (delta > pixelThresh)
        move = true;
    else
        move = false;
    end
    
end