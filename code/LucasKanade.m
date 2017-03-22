function [ u,v ] = LucasKanade( It,It1,rect )
%LucasKanade
%   It      frame n
%   It1     frame n+1
%   rect    rectangle[x1; y1; x2; y2]
%    It computes the optimal local motion from frame It to frame It+1 minimizing Eqn. 1.
%    Here It is the image frame It , It1 is the image frame It+1 , and rect is the 4 × 1 vector
%    representing a rectangle on the image frame It . 

    %显示在第一张和第二张图对应位置的矩形框% 
    %Show rectangle in It and It1 corresponding to the same thing%
    height = rect(4) - rect(2);
    width = rect(3) - rect(1);
    
    % 找到第一张图的矩形 %
    %Finding rect in It%
    [X0,Y0] = meshgrid(1:size(It,2),1:size(It,1));
    [Xi,Yi] = meshgrid(rect(1):rect(3),rect(2):rect(4));
    It_rect = interp2(X0,Y0,double(It),Xi,Yi);
    u=0;
    v=0;
    threshold = 0.001;
    [X1,Y1] = meshgrid(1:size(It1,2),1:size(It1,1));
    while(1)
        % 找到第二张图的矩形 %
        %Finding rect in It1%
        [Xi,Yi] = meshgrid(rect(1)+u:rect(3)+u,rect(2)+v:rect(4)+v);
        It1_rect = interp2(X1,Y1,double(It1),Xi,Yi);
%         %画出所有找到的矩形%测试用
%         rectangle('Position',[rect(1)+u,rect(2)+v,width,height],'Edgecolor','g');
        %判断两个矩形是否相等，由于插值会出现不等的情况，要归一化%
        %Determine whether the two rectangles are equal, because the interpolation will be unequal, to be normalized%
        size1 = size(It_rect);%插值后会有问题 第一张图比第二张图多一行或一列%There will be problems after interpolation. The first picture is more than one or second lines in the first picture
        size2 = size(It1_rect);
        if (size1(1)*size1(2)) ~= (size2(1)*size2(2))
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
        
        %Calculating Ix，Iy%
        %计算Ix，Iy% 
        [Ix,Iy] = gradient(double(It1_rect));
        %Calculating A%
        Sum_Ix2 = sum(sum(Ix.^2));
        Sum_Iy2 = sum(sum(Iy.^2));
        Sum_IxIy =sum(sum(Ix.*Iy));
        A = [Sum_Ix2,Sum_IxIy;Sum_IxIy,Sum_Iy2];
        
        %Calculating b%
        I_t = It1_rect-It_rect;
        Ix_I_t = sum(sum(Ix.*I_t));
        Iy_I_t = sum(sum(Iy.*I_t));  
        b = -1*[Ix_I_t;Iy_I_t];

        %计算新的矩形框的u　v%
        %Calculating u　v in new rectangle %
        uv = A\b;
        %最小二乘 用于判断新的uv是否足够小%
        %Least square%
        sum_uv_this = uv(1).^2+uv(2).^2;
        if ( sum_uv_this < threshold )
%             %画出最终矩形%测试用
%            rectangle('Position',[rect(1)+u,rect(2)+v,width,height],'Edgecolor','b');
           break
        end
        %累加进旧的uv%
        %Accumulation uv%
        u = u + uv(1);
        v = v + uv(2);
    end

end

