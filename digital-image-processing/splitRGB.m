%function to separate out the different rgb layers of an image

function[rImage, gImage, bImage] = splitRGB(image)

    rImage = image(:, :, 1);
    gImage = image(:, :, 1);
    bImage = image(:, :, 3);

end