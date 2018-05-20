% Local Feature Stencil Code
% Written by James Hays for CS 143 @ Brown / CS 4476/6476 @ Georgia Tech

% Returns a set of interest points for the input image

% 'image' can be grayscale or color, your choice.
% 'descriptor_window_image_width', in pixels.
%   This is the local feature descriptor width. It might be useful in this function to 
%   (a) suppress boundary interest points (where a feature wouldn't fit entirely in the image, anyway), or
%   (b) scale the image filters being used. 
% Or you can ignore it.

% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
% 'confidence' is an nx1 vector indicating the strength of the interest
%   point. You might use this later or not.
% 'scale' and 'orientation' are nx1 vectors indicating the scale and
%   orientation of each interest point. These are OPTIONAL. By default you
%   do not need to make scale and orientation invariant local features.
function [x, y, confidence, scale, orientation] = get_interest_points(image, descriptor_window_image_width)

% Implement the Harris corner detector (See Szeliski 4.1.1) to start with.
% You can create additional interest point detector functions (e.g. MSER)
% for extra credit.

% If you're finding spurious interest point detections near the boundaries,
% it is safe to simply suppress the gradients / corners near the edges of
% the image.

% The lecture slides and textbook are a bit vague on how to do the
% non-maximum suppression once you've thresholded the cornerness score.
% You are free to experiment. Here are some helpful functions:
%  BWLABEL and the newer BWCONNCOMP will find connected components in 
% thresholded binary image. You could, for instance, take the maximum value
% within each component.
%  COLFILT can be used to run a max() operator on each sliding window. You
% could use this to ensure that every interest point is at a local maximum
% of cornerness.

% Placeholder that you can delete -- random points
%x = ceil(rand(500,1) * size(image,2));
%y = ceil(rand(500,1) * size(image,1));

threshold = 'min'; 
numeroDePontos = 1000;
fThreshold = 0.7; 

ANMSToggle = 0;
ANMSNoOfPts = 5000;             
rParameter = 0.9;

%pega o tamanho da imagem
[linhas colunas] = size(image);

%Harris Corner Detection

 %Gaussian Filters
filterSize = 3;
sigma1 = 1; 
sigma2 = 1;

dx = [-1 0 1;
     -1 0 1;
     -1 0 1];
     
 %matriz transposta 
dy = dx'

%gausiana 1
 g1 = fspecial('gaussian',filterSize,sigma1);

 %removendo ruido
 imageG = conv2(image,g1,'same');
 
 Ix = conv2(image,dx,'same');
 Iy = conv2(image,dy,'same');
 
  Ix2_semFiltro = Ix.^2;
  Iy2_semFiltro = Iy.^2;
  Ixy_semFiltro = Ix.*Iy;
  
  g2 = fspecial('gaussian',filterSize,sigma2);
  Ix2 = conv2(Ix2_semFiltro, g2, 'same');
  Iy2 = conv2(Iy2_semFiltro, g2, 'same');
  Ixy = conv2(Ixy_semFiltro, g2, 'same');
  
  %%Calculation of Cornerness value
  %Method: Using g(Ix2)g(Iy2) - (g(Ixy))^2 - a(g(Ix2)+g(Iy2))^2
  %where det = Ix2*Iy2-Ixy^2; trace = Ix2+Iy2;
    a = 0.04;
    har = Ix2.*Iy2 - Ixy.^2 - a*((Ix2 + Iy2).^2);
  
  

    
    
end

