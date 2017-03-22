    %testCarsequence.m%
    %     Script testCarSequence.m loads the video sequence (carSequence.mat) 
    %     and runs the Lucas-Kanade Tracker to track the speeding car. 
	%     It save 'TrackedObject' in 'trackCoordinates.mat'.'TrackedObject' is a n×4 matrix; 
    %     n is number of frames in CarSequence and each row in the matrix contains 4 numbers: x1 y1 x2 y2,
    %     where indicates the coordinates of top-left and bottom-right corners to the object I  tracked.
    load('data/carSequence.mat');
    rect = [318, 202, 418, 274];
    Frames = size(sequence,4);
    TrackedObject =rect;
    mov=VideoWriter('car.avi');
    open(mov);
    for i=1:Frames-1
        i
        It = rgb2gray(sequence(:,:,:,i));
        It1 = rgb2gray(sequence(:,:,:,i+1));
        
        [ u,v ] = LucasKanade( It,It1,rect );
        rect = [rect(1)+u,rect(2)+v,rect(3)+u,rect(4)+v];
        %保存第20 60 80帧数据%
        %Saving frame20 frame60 frame80 %
        if i == 20
            height = rect(4) - rect(2);
            width = rect(3) - rect(1);
            figure(3);subplot(1,3,1);imshow(It);hold on;
            rectangle('Position',[rect(1),rect(2),width,height],'Edgecolor','y','LineWidth',5);
        end
        if i == 60
            height = rect(4) - rect(2);
            width = rect(3) - rect(1);
            figure(3);subplot(1,3,2);imshow(It);hold on;
            rectangle('Position',[rect(1),rect(2),width,height],'Edgecolor','y','LineWidth',5);
        end
        if i == 80
            height = rect(4) - rect(2);
            width = rect(3) - rect(1);
            figure(3);subplot(1,3,3);imshow(It);hold on;
            rectangle('Position',[rect(1),rect(2),width,height],'Edgecolor','y','LineWidth',5);
        end
        TrackedObject =[TrackedObject;rect];
    end
    close(mov);
    save('trackCoordinates.mat','TrackedObject');