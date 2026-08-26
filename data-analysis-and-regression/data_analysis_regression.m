%project 3 part 3
%data analysis and regression

%housekeeping
clc;
clear;
close all;

%%reading and formatting data
data = readtable("mtcars.csv");

names = data{:, 1};
mpg = data{2:end, 2};
hp = data{2:end, 5};
% the rest of the columns won't be needed

%% plot mpg vs horsepower
figure(1)

hold on
scatter(hp, mpg);
xlabel("Horsepower");
ylabel("Miles per Gallon");
title("MPG vs Horsepower");

%% linear fitline
f1 = polyfit(hp, mpg, 1);  %get the vector that represents the fitline

xf1 = linspace(0, max(hp));
yf1 = polyval(f1, xf1);
%gets the actual points from the fitline vector

plot(xf1, yf1, "red"); %plotting the line

%% quadratic fitline
f2 = polyfit(hp, mpg, 2);

xf2 = linspace(0, max(hp));
yf2 = polyval(f2, xf2);

plot(xf2, yf2, "green");

hold off

%% linear least squares regression
sumLinear = 0;
for i = 1:length(hp)
       %get values
       xVal = hp(i);
       yVal = mpg(i);
       yEstimate = polyval(f1, xVal);

       % add the square of the difference to the running total
       sumLinear = sumLinear + (yVal - yEstimate)^2;

end


%% quadratic least squares regression
sumQuad = 0;
for i = 1:length(hp)
       %get values
       xVal = hp(i);
       yVal = mpg(i);
       yEstimate = polyval(f2, xVal);

       % add the square of the difference to the running total
       sumQuad = sumLinear + (yVal - yEstimate)^2;

end


%% determine and display best model
if (sumLinear > sumQuad) % the better model is the one with the least error sum
    bestModel = "Quadratic";
else
    bestModel = "Linear";
end

fprintf("The best model is the %s model\n", bestModel);

%% highest and lowest mpg
%get the highest and lowest values, and their indexes
[hi, iHigh] = max(mpg);
[lo, iLow] = min(mpg);

nameHi = names(iHigh);
nameLo = names(iLow);

fprintf("The car with the highest mpg is: %s\n", nameHi{1}); %indexing bc cells are wierd
fprintf("The car with the lowest mpg is: %s\n", nameLo{1});


%% estimate mpg for car with 150hp using better model
%using polyval to get evaluate the model at hp = 150
hpVal = 150;
if (bestModel == "Linear")
    est = polyval(f1, hpVal);
else
    est = polyval(f2, hpVal);
end

fprintf("the %s model estimates that a 150hp car will have %0.2f mpg\n", bestModel, est);