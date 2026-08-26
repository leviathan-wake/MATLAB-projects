%logical matrix B. D(B) will return values of D where B is true

clc;
clear;
close all;

%green screens. if a certain color, then a logical array would mark those
%replace everything that's green with another image
%image arrays with only 2D are greyscale images
%3D arrays can represent color images

%concatenating cat(3) piles up arrays in the 3rd dimension
%mostly used for 3+D arrays because it can easily be done for 1, 2D arrays
%cat(3, arr1, arr2, arr3)

%read in images to create 3D arrays
puppy = imread("puppy.jpg");
tiedie = imread("tiedye.jpg");

[rows, columns, layers] = size(puppy);

%layer 1,2,3 -> RGB
%cougar red: 200-16-46

%separateLayers
[puppyR, puppyG, puppyB] = splitRGB(puppy);

%max value of red layer
maxPuppyR = max(puppyR, [], "all") %orrr min(min(min(puppyR))), [] means empty

%basic filter
filterRed = puppyR * 0; %matrix same dimensions of puppyR, all values zero
filterGreen = puppyG * 0;
filterBlue = puppyB;
%ig could make different colored filters by adjusting the multiplication
%values

%rejoin layers
FilteredImage = cat(3, filterRed, filterGreen, filterBlue);

figure(1);
image(FilteredImage);

figure(2);
image(puppy);

figure(3);
image(tiedie);

%cursedfilter
z = puppyR * 0;
filterRR = 255*(puppyR >= 240);
figure(4)
image(cat(3, filterRR, z, z));

%basedfilter
whiteL = ~(puppyR >= 243 & puppyG >= 243 & puppyB >= 243);
whiteImage = cat(3, whiteL, whiteL, whiteL);

copy = puppy;
copy(whiteImage) = 0;
figure(5);
image(copy);

%now replace with tiedie. have to resize
tdResize = imresize(tiedie, [rows, columns]);
copy2 = puppy;
copy2(whiteImage) = tdResize(whiteImage);
figure(6);
image(copy2);


