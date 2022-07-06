% function to remove block artifacts from the image. It performs averaging
% on the boundary of the blocks.
%%-----------------------------------------------------------------------%%
%%-----------------------------------------------------------------------%%
% %% output: OutImg-> image with reduced artifacts
% %% input:  Input-> input image with artifacts
%            boun-> number of pixels on boundary to perform averaging on
%            BlkLen-> length of an image block
%            n1,n2-> size of the image
%%-----------------------------------------------------------------------%%
%%-----------------------------------------------------------------------%%
function OutImg = RemoveBlockArtifacts(InImg,boun,BlkLen,n1,n2)
rec = InImg;        % intialize reconstructed/ output image
NoOfBlk1 = n1/BlkLen;  NoOfBlk2=n2/BlkLen;     % number of blocks along columns and rows
for i = 1:NoOfBlk1-1
    rec(BlkLen*i,:) = mean([rec(BlkLen*i-boun:BlkLen*i+boun,:)]);
    rec(BlkLen*i+1,:) = mean([rec(BlkLen*i-boun:BlkLen*i+boun,:)]);
end

for i = 1:NoOfBlk2-1
    rec(:,BlkLen*i) = (mean([(rec(:,BlkLen*i-boun:BlkLen*i+boun))']))';
    rec(:,BlkLen*i+1) = (mean([(rec(:,BlkLen*i-boun:BlkLen*i+boun))']))';
end
OutImg = rec;