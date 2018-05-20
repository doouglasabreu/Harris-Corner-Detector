% Local Feature Stencil Code
% Written by James Hays for CS 143 @ Brown / CS 4476/6476 @ Georgia Tech

% 'features1' and 'features2' are the n x feature dimensionality features
%   from the two images.
% If you want to include geometric verification in this stage, you can add
% the x and y locations of the features as additional inputs.
%
% 'matches' is a k x 2 matrix, where k is the number of matches. The first
%   column is an index in features1, the second column is an index
%   in features2. 
% 'Confidences' is a k x 1 matrix with a real valued confidence for every
%   match.
% 'matches' and 'confidences' can empty, e.g. 0x2 and 0x1.
function [matches, confidences] = match_features(features1, features2,x1,y1,x2,y2)

% This function does not need to be symmetric (e.g. it can produce
% different numbers of matches depending on the order of the arguments).

% To start with, simply implement the "ratio test", equation 4.18 in
% section 4.1.3 of Szeliski. For extra credit you can implement various
% forms of spatial verification of matches.
threshold = 0.7;

%calculating matrix of all distance between features (SSD)

distMat = zeros(size(features1,1),size(features2,1));
for j=1:size(features1,1)
    for i=1:size(features2,1)
        
       dist = abs(features1(j,:)-features2(i,:));
       distMat(j,i) = sum(dist);
    end
end


%matching features

%getting the index of the closest and 2nd closest match (min dist) feature 
%for each feature
s1 = size(features1,1);
s2 = size(features2,1);
dist = zeros(s1,1);

ratio = zeros(s1,1);
val = zeros(s1,s2);
index = zeros(s1,s2);


for j = 1:size(features1,1)
    [val(j,:) index(j,:)] = sort(distMat(j,:),'ascend');
    
    %Calculation of Euclidean Distance for Geometric Verification
    dist(j) = sqrt((x1(j) - x2(index(j,1)))^2 + (y1(j) - y2(index(j,1)))^2);
    %Calculation of Nearest Neighbour Distance Ratio
    %Denominator = max of the distance and 0.0000001 to prevent any
    %unexpected incidences where the value of the denominator is 0;
    ratio(j,1) = val(j,1)/max(val(j,2),0.00000001);
end


i=1;
matches = zeros(1,2);
confidences = zeros(1,1);
for j = 1:size(ratio,1)
    
    if(ratio(j,1)<threshold)
        if dist(j,1) < 100
            matches(i,1) = j;
            matches(i,2) = index(j,1);
            confidences(i,1) = 1/ratio(j,1);
            i = i+1;
        end
    end
end





% Sort the matches so that the most confident onces are at the top of the
% list. You should not delete this, so that the evaluation
% functions can be run on the top matches easily.
[confidences, ind] = sort(confidences, 'descend');
matches = matches(ind,:);