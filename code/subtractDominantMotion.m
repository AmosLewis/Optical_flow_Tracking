function [ moving_image ] = subtractDominantMotion( image1, image2 )
%SUBTRACTDOMINANTMOTION 
%   image1 and image2 (in uint8 format) form the input image pair and moving image 
%   is a binary image of the same size as the input images, in which the non-zero pixels 
%   correspond to locations of moving objects. The script test motion.m that we will use 
%   for grading this section has been provided for testing subtractDominantMotion. 
%   This script simply makes repeated calls to subtractDominantMotion on every consecutive 
%   image pair in the file Sequence1.tar.gz , makes an AVI movie out of the moving image 
%   returned for every image pair processed, and saves it as a file motion.avi for my
%   offline viewing 3pleasure. An example of such a movie is also provided consisting of 
%   results using the methods described above.

    image1 = uint8(image1);
    image2 = uint8(image2);
    M = LucasKanadeAffine(image1,image2);
    I = warpH(image1,M,size(image2));
    diff_I = abs(I -image2);
    diff_II=im2double(diff_I);
    moving_image =hysthresh(diff_II, 0.33, 0.30);
end

