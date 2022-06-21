function [psnr_noisy]=Test_PSNR(X,Xest,max_value)
% computes error criteria   (function_Errors)


maxl2=max_value;
mse_noisy=mean((Xest(:)-X(:)).^2);
rmse_noisy=sqrt(mse_noisy);
psnr_noisy=20*log10(maxl2/rmse_noisy);
