clc;clear all;close all;
%Written By Pengwah Abu BAkr Siddique
%ID: 27195139

day_night = load ('day_nightresultsv2');
night = load ('nightresults.mat');

Q = 2
TEST  = day_night.results.phB(Q).merProfobj;
Cluster = day_night.results.phBBACK(Q).A_iter;
ClusterD = day_night.results.phBBACK(Q).D_iter;
ClusterDreact = day_night.results.phBBACK(Q).Dreact_iter;
ClusterSiz = day_night.results.phBBACK(Q).recons_siz;
[M,ind] = min(TEST);

A = Cluster(ind,1:ClusterSiz(ind)^2);
A = reshape(A,[ClusterSiz(ind) ClusterSiz(ind)]);
G = graph(A);
idname = string(1:length(A)-1);
idname = ["S" idname];
h = plot(G,'NodeLabel',idname);
highlight(h,1,'NodeColor','r','MarkerSize',15,'NodeFontSize',12)
title('True Graph')

find(ClusterD(ind)<0)

%% Heat Map Plot of Resistance
D = ClusterD(ind,1:ClusterSiz(ind)^2);
D = reshape(D,[ClusterSiz(ind) ClusterSiz(ind)]);
figure;
h1= heatmap(D);
h1.Title = 'Heat Map for Resistance Matrix Phase B in Ohms'
h1.XLabel = 'Bus Number'
h1.YLabel = 'Bus Number'
h1.Colormap = jet;
set(gca,'FontSize',14,'FontName','Times New Roman')

Dreact = ClusterDreact(ind,1:ClusterSiz(ind)^2);
Dreact = reshape(Dreact,[ClusterSiz(ind) ClusterSiz(ind)]);
figure;
h1= heatmap(Dreact);
h1.Title = 'Heat Map for Reactance Matrix Phase B in Ohms'
h1.XLabel = 'Bus Number'
h1.YLabel = 'Bus Number'
h1.Colormap = jet;
set(gca,'FontSize',14,'FontName','Times New Roman')