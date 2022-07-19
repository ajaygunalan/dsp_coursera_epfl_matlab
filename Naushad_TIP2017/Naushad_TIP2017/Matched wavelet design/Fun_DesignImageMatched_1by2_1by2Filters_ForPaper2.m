function [hc,h1c,hr,h1r]=Fun_DesignImageMatched_1by2_1by2Filters_ForPaper2(img,h,h1)

%% Make filters with columns
ev_col=img(:,2:2:end);            % image with even columns
flipped_ev_col=flipud(ev_col);     % image with inverted even columns
col_img=img;
col_img(:,2:2:end)=flipped_ev_col;

d1_col=myConv(col_img(:),h1,1);
d1_col=myDownsample2(d1_col,2);
[hc,h1c,fc,f1c]=Design_1by2_1by2Filters_ForPaper2(col_img(:),d1_col);

%% Make filters with rows
ev_row=img(2:2:end,:);                % image with even rows
flipped_ev_row=(flipud(ev_row'))';     % image with inverted even rows
row_img=img;
row_img(2:2:end,:)=flipped_ev_row;
row_imgC=row_img';                     % Row image for computation

d1_row=myConv(row_imgC(:),h1,1);
d1_row=myDownsample2(d1_row,2);
[hr,h1r,fr,f1r]=Design_1by2_1by2Filters_ForPaper2(row_imgC(:),d1_row);