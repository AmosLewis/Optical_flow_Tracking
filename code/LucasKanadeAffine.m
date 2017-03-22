function [ M ] = LucasKanadeAffine( It, It1 )
%LUCASKANADEAFFINE 
%   It      frame n
%   It1     frame n+1
%   Where M is the affine transformation matrix, and It and It1 are It and It+1 respectively.
%   LucasKanadeAffine is relatively similar to LucasKanade.

    %计算A%
    %Calculating A%
    [X,Y] = meshgrid(1:size(It,2),1:size(It,1));
    [Ix,Iy] = gradient(double(It));
    X2 = X.^2;
    Y2 = Y.^2;
    XY = X.*Y; 
    Ix2 = Ix.^2;
    Iy2 = Iy.^2;
    IxIy = Ix.*Iy;

    A1 = [sum(sum(X2.*Ix2)) sum(sum(XY.*Ix2)) sum(sum(X.*Ix2));
          sum(sum(XY.*Ix2)) sum(sum(Ix2.*Y2)) sum(sum(Y2.*Ix2));
          sum(sum(X.*Ix2)) sum(sum(Y.*Ix2)) sum(sum(Ix2))];
    A2 = [sum(sum(X2.*IxIy)) sum(sum(XY.*IxIy)) sum(sum(X.*IxIy));
          sum(sum(XY.*IxIy)) sum(sum(IxIy.*Y2)) sum(sum(Y2.*IxIy));
          sum(sum(X.*IxIy)) sum(sum(Y.*IxIy)) sum(sum(IxIy))];
    A3 = [sum(sum(X2.*Iy2)) sum(sum(XY.*Iy2)) sum(sum(X.*Iy2));
          sum(sum(XY.*Iy2)) sum(sum(Iy2.*Y2)) sum(sum(Y2.*Iy2));
          sum(sum(X.*Iy2)) sum(sum(Y.*Iy2)) sum(sum(Iy2))];
    A = -[A1,A2;A2',A3];

    %计算b%
    %Calculating b%
    I_t = double(It1-It); 

    b = [sum(sum(X.*Ix.*I_t));
    sum(sum(Y.*Ix.*I_t));
    sum(sum(Ix.*I_t));
    sum(sum(X.*Iy.*I_t));
    sum(sum(Y.*Iy.*I_t));
    sum(sum(Iy.*I_t))];
    %Calculating delta(abcdef)%    
    p = A\b;
    M = [1+p(1),p(2),p(3);p(4),1+p(5),p(6);0,0,1];
    %Least square%
    sum_p = sqrt(p'*p);

    threshold = 2e-3;
    i=0;
   while(1)
        i = i+1;
        if i >21
            break;
        end
        It_warp = warpH(It,M,size(It1));%%It after affine
        
        %Calculating A%
        [X,Y] = meshgrid(1:size(It_warp,2),1:size(It_warp,1));
        [Ix,Iy] = gradient(double(It_warp));
        X2 = X.^2;
        Y2 = Y.^2;
        XY = X.*Y; 
        Ix2 = Ix.^2;
        Iy2 = Iy.^2;
        IxIy = Ix.*Iy;

        A1 = [sum(sum(X2.*Ix2)) sum(sum(XY.*Ix2)) sum(sum(X.*Ix2));
              sum(sum(XY.*Ix2)) sum(sum(Ix2.*Y2)) sum(sum(Y2.*Ix2));
              sum(sum(X.*Ix2)) sum(sum(Y.*Ix2)) sum(sum(Ix2))];
        A2 = [sum(sum(X2.*IxIy)) sum(sum(XY.*IxIy)) sum(sum(X.*IxIy));
              sum(sum(XY.*IxIy)) sum(sum(IxIy.*Y2)) sum(sum(Y2.*IxIy));
              sum(sum(X.*IxIy)) sum(sum(Y.*IxIy)) sum(sum(IxIy))];
        A3 = [sum(sum(X2.*Iy2)) sum(sum(XY.*Iy2)) sum(sum(X.*Iy2));
              sum(sum(XY.*Iy2)) sum(sum(Iy2.*Y2)) sum(sum(Y2.*Iy2));
              sum(sum(X.*Iy2)) sum(sum(Y.*Iy2)) sum(sum(Iy2))];
        A = -[A1,A2;A2',A3];

         %Calculating b%
         I_t = double(It1-It_warp); 
         
         b = [sum(sum(X.*Ix.*I_t));
              sum(sum(Y.*Ix.*I_t));
              sum(sum(Ix.*I_t));
              sum(sum(X.*Iy.*I_t));
              sum(sum(Y.*Iy.*I_t));
              sum(sum(Iy.*I_t))];
         %Calculating delta(abcdef)%    
         p0 = A\b;
         p = p+p0;
         M = [1+p(1),p(2),p(3);p(4),1+p(5),p(6);0,0,1];
         %最小二乘%
         %Least square%
        sum_p_this = sqrt(p0'*p0);
        if ( sum_p_this <threshold)%%这次的值小于一个阈值
           break;
        end
        sum_p = sum_p_this;
   end    
i