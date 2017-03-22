function [xcropright,ycropdown,ycroptop]=plothelp(It1,M)


template=[1, size(It1,2), size(It1,2), 1; 1, 1, size(It1,1), size(It1,1); 1 1 1 1];

temptrans=M*template;
% figure(4)
% scatter(template(1,:),template(2,:),'red');
% hold on;
% scatter(temptrans(1,:),temptrans(2,:),'green');
% hold off;
% set(gca,'YDir','Reverse')

xcropright=min(temptrans(1,2:3))-max(template(1,2:3));
ycropdown=min(temptrans(2,3:4))-max(template(2,3:4));
ycroptop=max(temptrans(2,1:2))-max(template(2,1:2));

if xcropright<0
    xcropright=ceil(abs(xcropright));
else xcropright=0;
end

if ycropdown<0
    ycropdown=ceil(abs(ycropdown));
else ycropdown=0;
end

if ycroptop>0
    ycroptop=ceil(abs(ycroptop));
else ycroptop=0;
end

end
