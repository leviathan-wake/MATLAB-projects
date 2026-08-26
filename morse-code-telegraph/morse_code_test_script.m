% stuff for task 1

%housekeeping
clc;
clear;
close all;

%init
board = arduino();

%% tester function for the testLED function (task 1.4)

volt = -1;
while ~( (volt >= 0) && (volt <= 5) ) || (mod(volt, 0.1) ~= 0)
    volt = input("Please input a voltage from 0 to 5, divisible by 0.1: ");
end

testLED(board, volt);
pause(1);
testLED(board, 0);


%% read voltage across photoresistor (task 1.5)
choice = 1;

while (choice == 1)
    prVolt = readVoltage(board, 'A0');
    fprintf("Voltage across photoresistor: %0.1f\n", prVolt);

    choice = menu('repeat measurement?', 'y', 'n');
end

%% task 1.6 bright lighting

disp("Please bring the Arduino into bright light");
input("press enter to continue");

avgH = 0;

for i = 1:10
    pause(1);
    avgH = avgH + readVoltage(board, 'A0');
end

avgH = avgH / i;

fprintf("Average photoresistor voltage (bright): %0.1f\n", avgH);

%% task 1.7 dim lighting

disp("Please cover the photoresistor");
input("press enter to continue");

avgL = 0;

for i = 1:10
    pause(1);
    avgL = avgL + readVoltage(board, 'A0');
end

avgL = avgL / i;

fprintf("Average photoresistor voltage (dim): %0.1f\n", avgL);

%% task 1.8 relationship between voltage and light value
disp("A higher voltage means brighter light, and a lower voltage means darker");
fprintf("Expected light voltage: %0.1f\n", avgH);
fprintf("Expected dim voltage: %0.1f\n", avgL);