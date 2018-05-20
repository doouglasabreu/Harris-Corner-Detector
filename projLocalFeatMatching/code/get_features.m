% Local Feature Stencil Code
% Written by James Hays for CS 143 @ Brown / CS 4476/6476 @ Georgia Tech

% Returns a set of feature descriptors for a given set of interest points. 

% 'image' can be grayscale or color, your choice.
% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
%   The local features should be centered at x and y.
% 'descriptor_window_image_width', in pixels, is the local feature descriptor width. 
%   You can assume that descriptor_window_image_width will be a multiple of 4 
%   (i.e., every cell of your local SIFT-like feature will have an integer width and height).
% If you want to detect and describe features at multiple scales or
% particular orientations, then you can add input arguments.

% 'features' is the array of computed features. It should have the
%   following size: [length(x) x feature dimensionality] (e.g. 128 for
%   standard SIFT)

function [features] = get_features(image, x, y, feature_width)

% To start with, you might want to simply use normalized patches as your
% local feature. This is very simple to code and works OK. However, to get
% full credit you will need to implement the more effective SIFT descriptor
% (See Szeliski 4.1.2 or the original publications at
% http://www.cs.ubc.ca/~lowe/keypoints/)

% Your implementation does not need to exactly match the SIFT reference.
% Here are the key properties your (baseline) descriptor should have:
%  (1) a 4x4 grid of cells, each descriptor_window_image_width/4. 'cell' in this context
%    nothing to do with the Matlab data structue of cell(). It is simply
%    the terminology used in the feature literature to describe the spatial
%    bins where gradient distributions will be described.
%  (2) each cell should have a histogram of the local distribution of
%    gradients in 8 orientations. Appending these histograms together will
%    give you 4x4 x 8 = 128 dimensions.
%  (3) Each feature should be normalized to unit length
%
% You do not need to perform the interpolation in which each gradient
% measurement contributes to multiple orientation bins in multiple cells
% As described in Szeliski, a single gradient measurement creates a
% weighted contribution to the 4 nearest cells and the 2 nearest
% orientation bins within each cell, for 8 total contributions. This type
% of interpolation probably will help, though.

% You do not have to explicitly compute the gradient orientation at each
% pixel (although you are free to do so). You can instead filter with
% oriented filters (e.g. a filter that responds to edges with a specific
% orientation). All of your SIFT-like feature can be constructed entirely
% from filtering fairly quickly in this way.

% You do not need to do the normalize -> threshold -> normalize again
% operation as detailed in Szeliski and the SIFT paper. It can help, though.

% Another simple trick which can help is to raise each element of the final
% feature vector to some power that is less than one.

sigma = 1; %gaussian fall off filter for image magnitude

%blurring image with Gaussian
g1 = fspecial('gaussian',[size(image,1) size(image,2)],sigma);
image = conv2(image,g1,'same');

[rows cols] = size(image);
noFeatures = size(x,1);
features = zeros(noFeatures,128);
for k = 1:noFeatures
    
    %generating image patch with repeated main point
    %i.e. each of 4 4x4 cells contains the main point in one of its corners
    
    halfFSize = (feature_width/2-1);

    if(y(k)-halfFSize <= 0 || x(k)-halfFSize <= 0 ||y(k)+halfFSize>rows || x(k)+halfFSize>cols)
        continue;
    end
    imagePatch(1:8,1:8) = image(y(k)-halfFSize:y(k),x(k)-halfFSize:x(k));
    imagePatch(1:8,9:16) = image(y(k)-halfFSize:y(k),x(k):x(k)+halfFSize);
    imagePatch(9:16,1:8) = image(y(k):y(k)+halfFSize,x(k)-halfFSize:x(k));
    imagePatch(9:16,9:16) = image(y(k):y(k)+halfFSize,x(k):x(k)+halfFSize);
    
    [IGMag IGDir] = imgradient(imagePatch);
    
    %Gaussian Filtered
    g2 = fspecial('gaussian',[16 16], sigma);
    IGMag = conv2(IGMag,g2,'same');
    
    m = 1;
    patchHist = zeros(1,128);
    for j = 1:4:16
        for i = 1:4:16
            
            cellHist = zeros(1,8);
            
            for jj = j:j+3
                for ii = i:i+3
%                     fprintf('j= %d i = %d \n',jj , ii);
                    if(IGDir(jj,ii)>-180 && IGDir(jj,ii)<=-135)
                        cellHist(1,1) = cellHist(1,1)+IGMag(jj,ii);
                    elseif(IGDir(jj,ii)>-135 && IGDir(jj,ii)<=-90)
                        cellHist(1,2) = cellHist(1,2)+IGMag(jj,ii);
                    elseif(IGDir(jj,ii)>-90 && IGDir(jj,ii)<=-45)
                        cellHist(1,3) = cellHist(1,3)+IGMag(jj,ii);
                    elseif(IGDir(jj,ii)>-45 && IGDir(jj,ii)<=0)
                        cellHist(1,4) = cellHist(1,4)+IGMag(jj,ii);
                    elseif(IGDir(jj,ii)>0 && IGDir(jj,ii)<=45)
                        cellHist(1,5) = cellHist(1,5)+IGMag(jj,ii);
                    elseif(IGDir(jj,ii)>45 && IGDir(jj,ii)<=90)
                        cellHist(1,6) = cellHist(1,6)+IGMag(jj,ii);
                    elseif(IGDir(jj,ii)>90 && IGDir(jj,ii)<=135)
                        cellHist(1,7) = cellHist(1,7)+IGMag(jj,ii);
                    else
                        cellHist(1,8) = cellHist(1,8)+IGMag(jj,ii);
                    end
                end
            end
            
            patchHist(1,m:m+7) = cellHist;
            m = m + 8;
        end
    end
    
    %normalisation within each patch of 128 bins
    maxVal = max(patchHist);
    minVal = min(patchHist);
    diff = maxVal - minVal;
    
    for i = 1:128
       features(k,i) = (patchHist(1,i)-minVal)/diff;
    end   
    
    %clipping value to 0.2
    for i = 1:128
        if features(k,i) >0.2
            features(k,i) = 0.2;
        end
    end
    
    %normalising again
    for i = 1:128
        features(k,i) = features(k,i)*5;
    end
end






% Placeholder that you can delete. Empty features.
% features = zeros(size(x,1), 128);



end





