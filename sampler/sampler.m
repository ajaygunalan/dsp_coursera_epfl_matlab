%% Improfile
% https://in.mathworks.com/help/images/ref/improfile.html
clear all;
clc;
% Read an image into the workspace, and display it.
I = imread('barbara.png');
imshow(I);
hold on;
% Specify x- and y-coordinates that define connected line segments.
x = [19 427 416 77];
y = [96 462 37 33];
% Display a 3-D plot of the pixel values of these line segments.
improfile(I,x,y),grid on;
%% How to get INTENSITY along a spcific curve?
% https://in.mathworks.com/matlabcentral/answers/112348-how-to-get-intensity-along-a-spcific-curve
clear all;
clc;
im = imread('barbara.png');
% manually create a circle
figure;
imshow(im);
h = imellipse();
% create a mask out of it
mask = createMask(h);
figure;
imshow(mask);
% thin it down 
thinmask = bwmorph(mask,'remove',inf);
figure;
imshow(thinmask);
% extract all pixels along this profile
profile = im(thinmask); % logical indexing
profile = I(thinmask); % logical indexing
plot(profile);
%% Along user defined curve
% https://in.mathworks.com/matlabcentral/answers/543278-interactive-pixel-extraction-from-an-image-along-custom-line
clear all;
clc;
I = imread('barbara.png');
imshow(I);
roi = drawline('Color','r'); 
% now draw line interactively
%
% Read out the X and Y coordinates of the start and end points
line_xs = [roi.Position(1,1), roi.Position(2,1)]
line_ys = [roi.Position(1,2), roi.Position(2,2)];
% extract pixel values along line
pixvals = improfile(I,line_xs,line_ys);
figure 
plot(pixvals,1:length(pixvals),'k'), axis tight, title('pixel values')
xlabel('pixel greyscale values')
ylabel('relative position from linestart (0) to lineend')
%% ROI using polyline
% https://in.mathworks.com/help/images/ref/images.roi.polyline.html
clear all;
clc;
I = imread('barbara.png');
imshow(I);
h = images.roi.Polyline(gca,'Position',[100 150; 200 250; 300 350; 150 450]);
%%




