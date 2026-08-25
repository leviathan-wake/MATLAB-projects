%% main function for motion detector 

%% housekeeping
clc;
clear;
close all;


%% variables
frames = 0;     %frames counter
thresh = 0.0086;    %threshold value, fraction of pixels with significant change
move = false;
tic; %sets up timer
firstMotionFrame = 0; % var to store first frame with motion

%% init
cam = webcam;   %opens camera

caution = imread("alert.png");
caution = imresize(caution, 0.5);

%let the camera warm up
[imTrash, dummy] = getImage(cam, frames);
pause(1);

%gets the first images
[im1, frames] = getImage(cam, frames);  
[im2, frames] = getImage(cam, frames);


%% detection loop
while true %sets up indefinite loop
    % creates live feed (updated every iteration)
    figure(1)
    imshow(im1);
    
    % checks for movement and calls alert scripts if movement detected
    if checkMovement(im1,im2, thresh);
        alertMove(im1, im2, caution);
        printAlert(frames);
        
        %if no movement detected yet, stores the current frame number
        if firstMotionFrame == 0  
            firstMotionFrame = frames; 
        end
    end
       
    
    im1 = im2;
    [im2, frames] = getImage(cam, frames);
    %rotates images 
        

    if toc >= 10 %%allows loop to run for 10 seconds, so we don't have an infinite loop
        break;
    end
    pause(0.03); %slows down the loop a bit

end  %end of detection loop

%% cleanup, final output
clear cam;
fprintf("\nThreshold used: %0.1f\n", thresh);
fprintf("First frame with motion: %0.0f\n", firstMotionFrame);