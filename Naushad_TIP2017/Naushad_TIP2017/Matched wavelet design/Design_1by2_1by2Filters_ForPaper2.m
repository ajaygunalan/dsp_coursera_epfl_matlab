function [hl,hh,fl,fh]=Design_1by2_1by2Filters_ForPaper2(x,d1)

%% Lazy filters
hl=[1 0]; z_hl=1;
hh=[1 0]; z_hh=2;
fl=[1 0]; z_fl=1;
fh=[0 1]; z_fh=1;

%% Predict Stage
[t,hh,z_hh,fl,z_fl]=PredictStage_1by2_1by2_ForPaper2(x,hl,z_hl,hh,z_hh,d1);

%% Update Stage
[s,hl,z_hl,fh,z_fh]=UpdateStage_1by2_1by2(x,t,hl,z_hl,hh,z_hh,fl,z_fl);
