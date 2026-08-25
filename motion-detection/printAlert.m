%function to print alert message. just makes the main script a bit cleaner

function [] = printAlert(frames)
    disp("Movement detected!");
    fprintf("Number of frames captured: %0.0f\n\n", frames);

end