% tester script for finding good threshold values, testing calcDelta
% just captures two frames

%% housekeeping
clc;
clear;
close all;

%% init 
cam = webcam;
thresh = 1000; 

%% image capture
im0 = snapshot(cam);
pause(1);

im1 = snapshot(cam);

im2 = snapshot(cam);

%% testing checkMovement
move = checkMovement(im1, im2, thresh);

%% show various images to check output
figure(1);
imshow(im1);

figure(2);
imshow(im2);

figure(3);
imshow (im2 - im1);

%% testing calcDelta itself
disp(calcDelta(im1, im2));

if move
    disp('Movement detected!');
else
    disp('No movement detected.');
end


%% testing alertMovement function 
alertMovement(im1, im2);


%% cleanup
clear cam;