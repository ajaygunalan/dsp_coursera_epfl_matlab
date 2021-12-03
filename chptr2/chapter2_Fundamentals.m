%% 2.2 Reading Images 
f = imread('cameraman.jpg');
size(f, 1)
whos f
%% 2.3 Displaying Images
%imshow(f), figure, 
%imshow(f, []), figure,
%imtool(f)
%% 2.4 Writing Images
imwrite(f, 'camNew.jpg')
%% 2.5 Data Classes
s = class(f);
%% 2.6 Image types
A = [1, 0; 0, 1];
islogical(A);
B = logical(A);
islogical(B);
%% 2.7 Converting between data classes
%c = double(f);
%class(c);
%f = [-0.5, 0.5; 0.75, 1.5];
%g = im2uint8(f);
%h = uint8([25 50; 128 200]);
%g = im2double(h);
g = imbinarize(f);
g1 = g(:,:,1);
imshow(g1)

%imshow(g1)


%% 2.8 Array Indexing
%% 2.9 Intro to MATLAB
%% 2.10 Plotting
%% 2.11 Interactive I/0
%%

