
function points = computeHarris3D(images, sigma, tau, maxpoints)
sigma1 = [sigma sigma tau];
% integration window of mu
sigma2 = sqrt(2)*sigma1;

% compute 'scale space'
gimages = gaussSmooth(images, sigma1, 'same');

% gradients
[Lx, Ly, Lt] = gradient(gimages);

% aggregate responses locally
LxLx = gaussSmooth(Lx.^2, sigma2, 'same');
LyLy = gaussSmooth(Ly.^2, sigma2, 'same');
LtLt = gaussSmooth(Lt.^2, sigma2, 'same');
LxLy = gaussSmooth(Lx.*Ly, sigma2, 'same');
LxLt = gaussSmooth(Lx.*Lt, sigma2, 'same');
LyLt = gaussSmooth(Ly.*Lt, sigma2, 'same');

% response of score on each pixel
k = 0.0005;   
%k = 0.005;   
detmu = - LyLy.*LxLt.^2 + 2*LxLt.*LxLy.*LyLt - LtLt.*LxLy.^2 - LxLx.*LyLt.^2 + LtLt.*LxLx.*LyLy;
trmu = LtLt + LxLx + LyLy;
H = detmu - k*(trmu.^3);

%% nonmax suppresion
[points, vals] = nonMaxSupr(H, 3, [], maxpoints);
