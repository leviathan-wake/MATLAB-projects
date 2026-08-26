%project 3 section 2
%anonymous fonctions

%housekeeping
clc;
clear;
close all;

%% anonymous function for velocity
vel = @(x) exp(sin(x)) - 1;

%% displaying velocity at time 4
fprintf("The car's velocity at time 4 = %0.1f m/s\n", vel(4));



%% find the times when the car is going backwards in the first 8 seconds
% the car is going backwards when the velocity function is less than zero

t = 0:0.1:8;
y = vel(t);

plot(t,y);

%the raw values where the velocity function is negative
negLogical = y < 0;
negTimes = t(negLogical);

disp("values of t where the car is moving backwards: ");
disp(negTimes);

%finding the actual bounds of this area
d = diff([0, negLogical, 0]);  %finding the differences between each value (zeros added for padding)

%the intent here is to see when the function switches between positive and
%negative

% the logical array will be 0 for positive and 1 for negative
%diff will make a change from 0 to 1 be 1, so 1 means a change from
%positive to negative
% a change from 1 to 0 would be -1, so that means a change from negative to
% positive

startI = find(d == 1);
endI = find(d  == -1) - 1; % subtract one because the raw value is the first positive value after

tStart = t(startI);
tEnd = t(endI);
%these are both negative values
%can't get zero values which are the true bounds for the negative region,
%but this is a good approximation. there's a little space outside of this
%region where the function is still zero (again, approximated)

fprintf("The time when the car is moving backwards is between t = %0.1f and t = %0.1f\n", tStart, tEnd);

%% calculating the total distance traveled from t = 0 to t = 8

%using an integral here because the integral of velocity is 
vel2 = @(t) abs(exp(sin(t)) - 1); %need absolute value for total distance instead of displacement
distance = integral(vel2, 0, 8);

fprintf("Total distance traveled in the first 8 seconds: %0.2f meters\n", distance);

%% gas consumption
%assumes 16 miles per gallon
%velocity is in meters per second
%distance is in meters

kmDist = distance / 1000; %convert distance to km
kmPerGal = 16 * 1.609;  %convert mi/gal to km/gal

gallons = kmDist / kmPerGal;  %the actual amount of gas used

fprintf("Amount of gas used in the first 8 seconds: %0.5f gallons\n", gallons);