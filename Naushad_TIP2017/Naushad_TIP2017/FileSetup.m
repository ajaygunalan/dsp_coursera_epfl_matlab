root = fileparts(which(mfilename));
fprintf('Adding folder: ''%s'' to path \n ','Supporting functions')
addpath([root filesep 'Supporting functions']);

fprintf('Adding folder: ''%s'' to path \n ','Images_for_experints')
addpath([root filesep 'Images_for_experiments']);

fprintf('Adding folder: ''%s'' to path \n ','Matched wavelet design')
addpath([root filesep 'Matched wavelet design']);