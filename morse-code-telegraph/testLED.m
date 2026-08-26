%tester function for writePWM (task 1.3)

%syntax: writePWMVoltage(board, 'pin code', voltage)

%digital pins used: D3, D5, D6
function[] = testLED(board, volt)
    writePWMVoltage(board, 'D3', volt);
    writePWMVoltage(board, 'D5', volt);
    writePWMVoltage(board, 'D6', volt);
end
