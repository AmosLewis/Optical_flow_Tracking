path_to_images ='data/Sequence1';

numimages=21;


fname = sprintf('%s//frame%d.pgm',path_to_images,0);

img1 = double(imread(fname));

% create movie object
%  mov=avifile('motion.avi','quality',100);
mov=VideoWriter('motion.avi');
open(mov);
try
    for frame = 1:numimages-1
        % Reads next image in sequence        
        fname = sprintf('%s//frame%d.pgm',path_to_images,frame);
        
		img2 = double(imread(fname));
        
        % Runs the function to estimate dominant motion
        disp(['Processing pair of image ' num2str(frame-1) ' and ' num2str(frame)]);
        save tmp.mat;
        [motion_img] = subtractDominantMotion(img1, img2);
        % Superimposes the binary image on img2, and adds it to the movie
         currframe = imfuse(motion_img,img2);
         writeVideo(mov,currframe);
        % Prepare for processing next pair
         imshow(uint8(currframe));
         img1 = img2;

    end
    close(mov);
catch
    % In case an error occurs, it's a good idea to close the avi object
    % handle before exiting. Otherwise MATLAB complains when you try
    % to open the file again in future.
    close(mov);
    return;
end

