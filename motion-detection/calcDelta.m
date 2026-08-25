%function to calculate the difference between two images

function delta = calcDelta(im1, im2)
    diff = im2 - im1;       %creates an array of the differences between each pixel
   
    diff = rgb2gray(diff);  %collapses into a grayscale, 2D array

    diffInd = diff > 20;   %logical index of pixels with significant change
                            %got this value by using the tester script to
                            %get an acceptable number of flagged pixels
                            %with me just being basically still

    delta = sum(sum(diffInd)); %gets number of pixels with change

end
