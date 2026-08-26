%project 3 section 1
%image manipulation

%housekeeping
clc;
clear;
close all;


%read images
houston = imread("houston-1.jpg");
ironman = imread("ironman-1.jpg");

%get image sizes
hSize = size(houston);
iSize = size(ironman);

%display image sizes
disp("Size of Houston image: ");
disp(hSize);
fprintf("%d pixels tall  by %d pixels wide\n\n", hSize(1), hSize(2));

disp("Size of Iron Man image: ");
disp(iSize);
fprintf("%d pixels tall  by %d pixels wide\n", iSize(1), iSize(2));

%because the images are the same size, don't have to worry about out of
%index errors

%new image that is blank that will be filled by the loop
newImage = houston .* 0;

% comparison / replacement loop
for row = 1:hSize(1)
    for col = 1:hSize(2)
        % checking and filling in the correct pixel
        if isGreen(ironman(row, col, :))
            newImage(row, col, :) = houston(row, col, :);
        else
            newImage(row, col, :) = ironman(row, col,:);
        end

    end
end

%actually displaying the images
subplot(1, 3, 1);
imshow(houston);

subplot(1, 3, 2);
imshow(ironman);

subplot(1, 3, 3);
imshow(newImage);


%isGreen helper function
function[bool] = isGreen(inVector)
    if (inVector(1) < 90) && (inVector(2) > 150) && (inVector(3) < 70)
        bool = true;
    else
        bool = false;
    end
end