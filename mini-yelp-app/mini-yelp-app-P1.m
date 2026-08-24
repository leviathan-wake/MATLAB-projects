%% Project 1: Houston Restaurant Locator
% leviathan-wake, Feb 8 2026
% Using user's inputted location and imported restaurant data, calculates
% the nearest restaurant and outputs specific information about that
% restaurant. also outputs data relating to the other restaurants


%% Housekeeping
clc;
clear;
close all;

%% Import and format raw restaurant data
resNum = readmatrix('Restaurant_Num.xlsx');    % format is (lat long rating; ... )
resText = readcell('Restaurant_Text.xlsx');    % format is (name review; ... )

resLat = resNum(:, 1);                   %array of just the lats and longs, still in order
resLong = resNum(:, 2);
resRLat = deg2rad(resLat);              %converts array to radians
resRLong = deg2rad(resLong);


%% Prompt user lat/long
uLat = input("Your Latitude: ");
uLong = input("Your Longitude: ");

% hardcoded values for easier testing
%uLat = 29.737;
%uLong = -95.41;


%converts lat and long to radians
uRLat = deg2rad(uLat);
uRLong = deg2rad(uLong);


%% apply haversine to lat/long matrix, element-wise

% get differences in latitude and longitude
dLat = resRLat - uRLat;
dLong = resRLong - uRLong;

%plug into haversine formula
R = 6731; % earth's radius, in km
a = sin(dLat ./ 2) .^ 2 + cos(resRLat) .* cos(uRLat) .* sin(dLong/2) .^ 2;
c = 2 * atan2(sqrt(a), sqrt(1 - a));
d = c .* R;
% result of haversine formula

%convert to miles
dMi = d .* 0.6214;

%% A nice little table and scatterplot, unsorted
figure;
plot(dMi, "+b");
title("Distances to Restaurants (mi), unsorted");
xlabel("Restaurant number");
ylabel("Distance (mi)");

%% Same, but sorted by distance to user, ascending
sortedD = sort(dMi);

figure;
plot(sortedD, "+g");
title("Distances to Restaurants (mi), sorted");
xlabel("Restaurant number");
ylabel("Distance (mi)");

%% getting average rating
avgRat = mean(resNum(:, 3));

%% Print final output with closest restaurant data
[~, minI] = min(dMi); % get closest restaurant index

disp("============================");
disp(" Houston Restaurant Locator");
disp("============================");
fprintf("User location (deg): Lat = %0.4f, ", uLat);
fprintf("Long = %0.4f \n\n", uLong);
fprintf("Closest Restaurant: %s \n", resText{minI, 1});
fprintf("Distance: %0.2f mi \n", dMi(minI, 1 ));
fprintf("Rating: %0.1f \n", resNum(minI, 3));


%error catching for empty notes entries
if ismissing(resText{minI, 2});
    disp("Notes: none");
else
    fprintf("Notes: %s \n\n", resText{minI, 2});
end

fprintf("Average Rating (all restaurants) %0.1f \n", avgRat);