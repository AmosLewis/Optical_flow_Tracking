function IS = loadImageSequence(fnames)
% Load a sequence of equally-sized images into a 3D array with
% width as first dimension, height as second dimension and time as third 
% dimension.

% assuming all images have same size
img1 = im2double(rgb2gray(imread(fnames{1})));    
IS = zeros([size(img1) size(fnames, 1)]);
for t=1:size(fnames, 1)
    IS(:,:,t) = im2double(rgb2gray(imread(fnames{t})));    
end
