clear all, close all, clc

n = 1000;
q = n/4;
X = zeros(n,n);
X(q:(n/2)+q,q:(n/2)+q) = 1;
subplot(2,2,1), imshow(X);

Y = imrotate(X,10,'bicubic'); % rotate 10 degree
Y = Y-Y(1,1);
nY = size(Y,1);
startind = floor((nY-n)/2);
Xrot = Y(startind:startind+n-1, startind:startind+n-1);
subplot(2,2,2), imshow(Xrot);

[U1,S1,V1] = svd(X);
[U2,S2,V2] = svd(Xrot);

subplot(2,2,3), semilogy(diag(S1),'-ko','LineWidth',2)
ylim([1.e-16 1.e4]), grid on
set(gca,'YTick', [1.e-16 1.e-12 1.e-8 1.e-4 1.e4]);
set(gca,'XTick', [0 250 500 750 1000]);
set(gca, 'FontSize', 15)

subplot(2,2,4), semilogy(diag(S2),'-ko','LineWidth',2)
ylim([1.e-16 1.e4]), grid on
set(gca,'YTick', [1.e-16 1.e-12 1.e-8 1.e-4 1.e4]);
set(gca,'XTick', [0 250 500 750 1000]);
set(gca, 'FontSize', 15)

set(gcf, 'Position', [1400 100 2400 1200])

%%
clear all, close all, clc
n = 1000;
X = zeros(n,n);
X(n/4:3*n/4, n/4:3*n/4)=1;

[U,S,V] = svd(X);
subplot(1,2,1)
imagesc(X), hold on;
cm = colormap(jet(13));
semilogy(diag(S),'-o','color',cm(1,:)), hold on, grid on

nAngles = 12;  % sweep through 12 angles, from 0:4:44
Xrot = X;
for j=2:nAngles
    Y = imrotate(X,(j-1)*4,'bicubic'); % rotate (j-1)*4
    startind = floor((size(Y,1)-n)/2);
    Xrot1 = Y(startind:startind+n-1, startind:startind+n-1);
    Xrot2 = Xrot1 - Xrot1(1,1);    
    Xrot2 = Xrot2/max(Xrot2(:));
    Xrot(Xrot2>.5) = j;
    
    [U,S,V] = svd(Xrot1);
    subplot(1,2,1), imagesc(Xrot), colormap([1 1 1; cm])    
    subplot(1,2,2), semilogy(diag(S),'-o','color',cm(j,:))       
end
set(gcf, 'Position', [1400 100 2400 1200])