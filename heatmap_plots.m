clc;clear all;close all;
%Written By Pengwah Abu Bakr Siddique
%ID: 27195139
%% DAY AND NIGHT 
%%PHASE A
load day_nightresultsv2

[r,c] = size(results.phABACK);
for i = 1:c
    temp = results.phABACK(i);
    [VARstruct.variance_mea,VARstruct.ind,VARstruct.D_discrete] = variance_calc(temp);
    figure;
    [h] = plot_heatmap(VARstruct);
end

%% PHASE B
[r,c] = size(results.phBBACK);
for i = 1:c
    temp = results.phBBACK(i);
    [VARstruct.variance_mea,VARstruct.ind,VARstruct.D_discrete] = variance_calc(temp);
    figure;
    [h] = plot_heatmap(VARstruct);
end
%% PHASE C
[r,c] = size(results.phCBACK);
for i = 1:c
    temp = results.phCBACK(i);
    [VARstruct.variance_mea,VARstruct.ind,VARstruct.D_discrete] = variance_calc(temp);
    figure;
    [h] = plot_heatmap(VARstruct);
end

%% NIGHT DATA
%% Phase A
clc;clear all;
load nightresults
[r,c] = size(results.phABACK);
for i = 1:c
    temp = results.phABACK(i);
    [VARstruct.variance_mea,VARstruct.ind,VARstruct.D_discrete] = variance_calc(temp);
    figure;
    [h] = plot_heatmap(VARstruct);
end

%% PHASE B
[r,c] = size(results.phBBACK);
for i = 1:c
    temp = results.phBBACK(i);
    [VARstruct.variance_mea,VARstruct.ind,VARstruct.D_discrete] = variance_calc(temp);
    figure;
    [h] = plot_heatmap(VARstruct);
end
%% PHASE C
[r,c] = size(results.phCBACK);
for i = 1:c
    temp = results.phCBACK(i);
    [VARstruct.variance_mea,VARstruct.ind,VARstruct.D_discrete] = variance_calc(temp);
    figure;
    [h] = plot_heatmap(VARstruct);
end