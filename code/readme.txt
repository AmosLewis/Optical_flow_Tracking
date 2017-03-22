%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
Carnegie Mellon University
Robotic Institute
16720 Computer Vision: Homework 3
Template Tracking and Action Classification.
Instructor: Martial Hebert
TAs: David Fouhey, Heather Knight and Daniel Maturana
Due Date: January 11th, 2017

%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    [u,v] = LucasKanade(It,It1,rect)
    It computes the optimal local motion from frame It to frame It+1 minimizing Eqn. 1.
    Here It is the image frame It , It1 is the image frame It+1 , and rect is the 4 ¡Á 1 vector
    representing a rectangle on the image frame It . 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	testCarSequence.m
     Script testCarSequence.m loads the video sequence (carSequence.mat) and runs the Lucas-Kanade Tracker to track the speeding car. 
	 It save 'TrackedObject' in 'trackCoordinates.mat'.'TrackedObject' is a n¡Á4 matrix; n is number of frames in CarSequence and each row in the matrix contains 4 numbers: x1 y1 x2 y2, where indicates the coordinates of top-left and bottom-right corners to the object I  tracked.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	[ M ] = LucasKanadeAffine( It, It1 )
	 Where M is the affine transformation matrix, and It and It1 are It and It+1 respectively.
     LucasKanadeAffine is relatively similar to LucasKanade.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	[ moving_image ] = subtractDominantMotion( image1, image2 )
	 image1 and image2 (in uint8 format) form the input image pair and moving image is a binary image of the same size as the input images, in which the non-zero pixels to locations of moving objects. 
	 The script test motion.m that we will use for grading this section has been provided to you for testing your function. 
	 This script simply makes repeated calls to subtractDominantMotion on every consecutive image pair in the file Sequence1.tar.gz , makes an AVI movie out of the moving image returned for every image pair processed, and saves it as a file motion.avi for your offline viewing 3pleasure. 
	 An example of such a movie is also provided consisting of results using the methods described above.