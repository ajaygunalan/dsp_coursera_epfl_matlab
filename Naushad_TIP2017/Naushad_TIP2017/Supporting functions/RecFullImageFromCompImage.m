% This function reconstruct full image block from compressively sensed image
% block.
%%-----------------------------------------------------------------------%%
%%-----------------------------------------------------------------------%%
% %% output: recImg-> full reconstructed image block
%            tim-> time taken in reconstruction of the block
% %% input:  A-> operator 'A' as mentioned in paper
%            y-> compressive measurements of the block
%            Wt-> wavelet transpose (or operator 'phi' in paper)
%            n1,n2-> size of the image
%%-----------------------------------------------------------------------%%
%%-----------------------------------------------------------------------%%
function [recImg,tim] = RecFullImageFromCompImage(A,y,Wt,n1,n2)

options.verbosity = 0;
tic;
zrec = spgl1(A,double(y),[],[],[],options);        % Solve CS problem using 'spgl1' solver
% recImg = reshape(Wt*(zrec,1),n1,n2);
recImg = reshape(Wt*zrec,n1,n2);
tim = toc;