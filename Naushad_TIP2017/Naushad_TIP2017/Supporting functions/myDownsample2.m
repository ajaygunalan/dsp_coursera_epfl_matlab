%% This function downsamples the input signal in by n and give it to 
% out. Standard downsampling is followed
function out=myDownsample2(in,n)

out=in(1:n:end);