%% Nomalize each vector to unit
[nSmp,nFea] = size(fea);
for i = 1:nSmp
     fea(i,:) = fea(i,:) ./ max(1e-12,norm(fea(i,:)));
end
%% Scale the features (pixel values) to [0,1]
maxValue = max(max(fea));
fea = fea/maxValue;
%% For entire database
clear all;
clc;
load('YaleB_32x32.mat')
% contains variables 'fea' and 'gnd'. Each row of 'fea' is a face; 'gnd' is the label
faceW = 32;
faceH = 32;
numPerLine = 11;
ShowLine = 2;

Y = zeros(faceH*ShowLine,faceW*numPerLine);
for i=0:ShowLine-1
   for j=0:numPerLine-1
     Y(i*faceH+1:(i+1)*faceH,j*faceW+1:(j+1)*faceW) = reshape(fea(i*numPerLine+j+1,:),[faceH,faceW]);
   end
end
imagesc(Y);colormap(gray);


%% For training database
load('10Train/1.mat')
fea_Train = fea(trainIdx,:);
fea_Test = fea(testIdx,:);

gnd_Train = gnd(trainIdx);
gnd_Test = gnd(testIdx);
%%
