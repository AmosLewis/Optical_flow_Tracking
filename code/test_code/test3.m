
    %%%%%%%%%%%%%%%%%%%%% [ u,v ] = LucasKanade( It,It1,rect )%%%%%%%%%
    It = imread('data\Sequence1\frame0.pgm');%It(y,x)
    It1 = imread('data\Sequence1\frame1.pgm');%It1(y,x)
    rect = [150,85,170,95]; 
    %%%%%%%[x1, y1, x2,y2]%%%
    
    %显示在第一张和第二张图对应处事位置的矩形框%
    height = rect(4) - rect(2);
    width = rect(3) - rect(1);
    figure(1);imshow(It);hold on;
    rectangle('Position',[rect(1),rect(2),width,height],'Edgecolor','g');
    figure(2);imshow(It1);
    rectangle('Position',[rect(1),rect(2),width,height],'Edgecolor','r');
    fname = sprintf('test%d.jpg',0);
    print(2,'-djpeg',fname);
    hold on;
    %%%%% 找到第一张图的矩形 %%%% It_Interp 11*21 %%%%%
    [X0,Y0] = meshgrid(1:size(It,2),1:size(It,1));
    [Xi,Yi] = meshgrid(rect(1):rect(3),rect(2):rect(4));
    It_rect = interp2(X0,Y0,double(It),Xi,Yi);

    u=0;
    v=0;
    threshold = 0.001;
    threshold1 = 0.000001;
    sum_uv = 1;
    [X1,Y1] = meshgrid(1:size(It1,2),1:size(It1,1));
    i=0;
    while(1)
        i = i+1;
        %%%%% 找到第二张图的矩形 %%%% It_rect 11*21 %%%%%
        [Xi,Yi] = meshgrid(rect(1)+u:rect(3)+u,rect(2)+v:rect(4)+v);
        It1_rect = interp2(X1,Y1,double(It1),Xi,Yi);
        %%%画出所有找到的矩形%%%%%
        rectangle('Position',[rect(1)+u,rect(2)+v,width,height],'Edgecolor','g');
        hold on;
        fname = sprintf('test%d.jpg',i);
        print(2,'-djpeg',fname);
        pause(1);


    
        %判断两个矩形是否相等，由于插值会出现不等的情况，要归一化%
        size1 = size(It_rect);%%插值后会有问题 第一张图比第二张图多一行或一列
        size2 = size(It1_rect);
        if (size1(1)*size1(2)) ~= (size2(1)*size2(2))
            size1
            size2
            if size1(1)==size2(1)+1
               It_rect(1,:) = [];
            elseif size1(1)==size2(1)-1
                    It1_rect(1,:) = [];
            elseif size1(2)==size2(2)+1
                    It_rect(:,1) = [];
            elseif size1(2)==size2(2)-1
                    It1_rect(:,1) = [];
            end  
        end
        
        %计算Ix，Iy% 
        [Ix,Iy] = gradient(double(It1_rect));
        %计算A%
        Sum_Ix2 = sum(sum(Ix.^2));
        Sum_Iy2 = sum(sum(Iy.^2));
        Sum_IxIy =sum(sum(Ix.*Iy));
        A = [Sum_Ix2,Sum_IxIy;Sum_IxIy,Sum_Iy2];
        
        %计算b%
        I_t = It1_rect-It_rect;
        Ix_I_t = sum(sum(Ix.*I_t));
        Iy_I_t = sum(sum(Iy.*I_t));  
        b = -1*[Ix_I_t;Iy_I_t];

        %计算新的矩形框的uv%
        uv = A\b;
        %用于判断新的uv是否足够小%
        sum_uv_this = uv(1).^2+uv(2).^2;
        if (sum_uv_this <  threshold )
            %%%画出最终矩形%%%%%
           rectangle('Position',[rect(1)+u,rect(2)+v,width,height],'Edgecolor','b');
           fname = sprintf('test%d.jpg',i);
           print(2,'-djpeg',fname);
           break;
        end
%         %%判断新的uv的改变量是否足够小%
%         if abs(sum_uv_this-sum_uv)<threshold1
%            %%%画出最终矩形%%%%%
%            rectangle('Position',[rect(1)+u,rect(2)+v,width,height],'Edgecolor','y');
%            break
%         end 
        %用于下一次计算改变量%
        sum_uv = sum_uv_this; 
        %累加进旧的uv%
        u = u + uv(1);
        v = v + uv(2);
    end