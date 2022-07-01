%Marcos Bolanos
%November 2011
%Compressive Sensing Example

%This very simple example of L1 minimization is reproduced for
%implementation on matlab. The original example was posted on Rip's Applied
%Mathematics Blog on March 28, 2011 entitled "Compressed Sensing: the L1
%norm finds sparse solutions". 

%One needs to download the L1-MAGIC package in order to perform the l1
%minimization on matlab.

%This example was very good for illustrating how L1 minimization can
%identify a sparse vector. Here x is the sparse vector. SamplingMat is the kxN
%incoherent matrix and y are the coefficients. The example shows how we can
%find the original x. xp should be approximately equal to x.

%% Points
% n is the length of the signal vector; In this case, 10.
% m is the length of the measurement vector; In this case, 250.
% SamplingMat is m by n.
% TransformDomain n by n.


s=RandStream('mt19937ar');
%RandStream.setDefaultStream(s);
reset(s);
%% 0. Load the image
%original sparse vector.
x=[0, 0, 0.319184, 0, 1.65857, 0, 0, 0, -1.0439, 0]'; %original sparse vector
%% 1. Design Sampling Matrix
 SamplingMat=randn(s,10,5);
 y=SamplingMat'*x;
 xp = l1eq_pd(x, SamplingMat', 1, y)     %l1 minimization using L1-MAGIC
 
 
figure
plot(x, 'g')
hold on
plot(xp, 'b--o')
 