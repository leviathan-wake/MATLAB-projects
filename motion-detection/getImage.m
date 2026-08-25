%function to get image and update frames var

function [im1, frames] = getImage(cam, frames)
    im1 = snapshot(cam);
    frames = frames + 1;
end