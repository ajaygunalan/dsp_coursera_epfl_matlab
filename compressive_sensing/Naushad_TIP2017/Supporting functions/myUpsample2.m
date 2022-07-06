%% This function upsample the input signal in by n. Standard upsampling 
% is followed
function out=myUpsample2(in,n)

temp=zeros(n*length(in),1);
temp(1:n:end)=in;
out=temp;