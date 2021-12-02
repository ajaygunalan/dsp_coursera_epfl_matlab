% 2.2 Reading Images %
f = imread('cameraman.jpg');
size(f, 1)
whos f
% 2.3 Displaying Images %
imshow(f), figure, 
imshow(f, [])