    It = imread('data\Sequence1\frame0.pgm');%It(y,x)
    It1 = imread('data\Sequence1\frame1.pgm');%It1(y,x)
    
    threshold=0.001;

[FX,FY]=gradient(double(It));%get Ix and Iy

Ix=reshape(FX,[],1);
Iy=reshape(FY,[],1);%reshape the gradient

[row,col]=size(It);%get the size of the image

[X,Y]=meshgrid(1:col,1:row);%x and y coordinates

x=reshape(X,[],1);
y=reshape(Y,[],1);%get x and y in a column

A=[x.*Ix,y.*Ix,Ix,x.*Iy,y.*Iy,Iy];

diff=It1-It;
B=reshape(diff,[],1);
B=double(B);

result=-inv(A'*A)*A'*B;

a=result(1);
b=result(2);
c=result(3);
d=result(4);
e=result(5);
f=result(6);

M=[1+a,b,c;d,1+e,f;0,0,1];%the affine transformation matrix


% n=size(x,1);
% u_ave=sum(a*x+b*y+c)/n;
% v_ave=sum(d*x+e*y+f)/n;%calculate the average of u and v
% 
% dis=u_ave^2+v_ave^2;%dis is the average displacement which is used to be compared with threshold
tol=sqrt((a^2)+(b^2)+(c^2)+(d^2)+(e^2)+(f^2))

i=0;

while tol>threshold
    warp_It=warpH(It,M,size(It));%It after affine transformation
    
    mask=warp_It&It1;%find the overlap region
    
    It1_overlap=mask.*double(It1);%get the overlap region in It
    warp_It_overlap=mask.*double(warp_It);%get the overlap region in warp_It
    
    diff=It1_overlap-warp_It_overlap;
    B=reshape(diff,[],1);
    B=double(B);%get b for common region
    
    [FX,FY]=gradient(double(It1_overlap));%get Ix and Iy
    %[FX,FY]=gradient(double(warp_It_overlap));%get Ix and Iy

    Ix=reshape(FX,[],1);
    Iy=reshape(FY,[],1);%reshape the gradient
    
    A=[x.*Ix,y.*Ix,Ix,x.*Iy,y.*Iy,Iy];
    
    result=-inv(A'*A)*A'*B;
    
%     a=result(1);
%     b=result(2);
%     c=result(3);
%     d=result(4);
%     e=result(5);
%     f=result(6);
    a_m=result(1);
    b_m=result(2);
    c_m=result(3);
    d_m=result(4);
    e_m=result(5);
    f_m=result(6);
    
    a=a+a_m;
    b=b+b_m;
    c=c+c_m;
    d=d+d_m;
    e=e+e_m;
    f=f+f_m;
    

    M=[1+a,b,c;d,1+e,f;0,0,1];%the affine transformation matrix
    
    
    tol=sqrt((a_m^2)+(b_m^2)+(c_m^2)+(d_m^2)+(e_m^2)+(f_m^2));

    i=i+1
    tol
    
end


%%%%%%%%%%%sub%%%%%%%%%%%%%%
      image1 = imread('data\Sequence1\frame0.pgm');%It(y,x)
      image2 = imread('data\Sequence1\frame1.pgm');%It1(y,x)     
%       M = LucasKanadeAffine(image1,image2);
      I = warpH(image1,M,size(image2));
      diff_I = abs(I -image2);
      diff_II=im2double(diff_I);
      moving_image =hysthresh(diff_II, 0.33, 0.30); 
      figure(1);imshow(diff_I);hold on;
      se=strel('disk',2);
      moving_image = imdilate(moving_image,se);
      currframe = imfuse(moving_image,image2);
      figure(2);imshow(currframe);hold on;
