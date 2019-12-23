clc;clear all;close all;
%Written By Pengwah Abu Bakr
%ID: 27195139

day_night = load ('day_nightresultsv2');
night = load ('nightresults.mat');
temp = [[night.results.phACMP.firstguess] [night.results.phBCMP.firstguess] [night.results.phCCMP.firstguess]];
NM(1) = mean(temp);
NV(1) = var(temp);
temp = [[day_night.results.phACMP.firstguess] [day_night.results.phBCMP.firstguess] [day_night.results.phCCMP.firstguess]];
DM(1) = mean(temp);
DV(1) = var(temp);

temp = [[night.results.phACMP.obj] [night.results.phBCMP.obj] [night.results.phCCMP.obj]];
NM(2) = mean(temp);
NV(2) = var(temp);
temp = [[day_night.results.phACMP.obj] [day_night.results.phBCMP.obj] [day_night.results.phCCMP.obj]];
DM(2) = mean(temp);
DV(2) = var(temp);

temp = [[night.results.phACMP.merProfobj] [night.results.phBCMP.merProfobj] [night.results.phCCMP.merProfobj]];
NM(3) = mean(temp);
NV(3) = var(temp);
temp = [[day_night.results.phACMP.merProfobj] [day_night.results.phBCMP.merProfobj] [day_night.results.phCCMP.merProfobj]];
DM(3) = mean(temp);
DV(3) = var(temp);

temp = [[night.results.phACMP.merProfVmag] [night.results.phBCMP.merProfVmag] [night.results.phCCMP.merProfVmag]];
NM(4) = mean(temp);
NV(4) = var(temp);
temp = [[day_night.results.phACMP.merProfVmag] [day_night.results.phBCMP.merProfVmag] [day_night.results.phCCMP.merProfVmag]];
DM(4) = mean(temp);
DV(4)= var(temp);

temp = [[night.results.phACMP.Vmag] [night.results.phBCMP.Vmag] [night.results.phCCMP.Vmag]];
NM(5) = mean(temp);
NV(5) = var(temp);
temp = [[day_night.results.phACMP.Vmag] [day_night.results.phBCMP.Vmag] [day_night.results.phCCMP.Vmag]];
DM(5) = mean(temp);
DV(5) = var(temp);

temp = [[night.results.phACMP.guess2] [night.results.phBCMP.guess2] [night.results.phCCMP.guess2]];
NM(6) = mean(temp);
NV(6) = var(temp);
temp = [[day_night.results.phACMP.guess2] [day_night.results.phBCMP.guess2] [day_night.results.phCCMP.guess2]];
DM(6) = mean(temp);
DV(6) = var(temp);
%PLOT FIGURE
figure;
plot(NM,'.','MarkerSize',24,'MarkerFaceColor',[0 0 0]);hold on
plot(DM,'*','MarkerSize',24);hold off
grid on
title('Mean Plot');legend('Night Data','Day Night Mixture')
xlabel('Type of error')
ylabel('Mean')
xticks([1:6])
xticklabels({'FirstGuess','Objective Val','ProftimesObj','ProftimesVmag','Vmag','Guess 2'})
xtickangle(45)
set(gca,'FontSize',14,'FontName','Times')

figure;
plot(NV,'.','MarkerSize',24);hold on
plot(DV,'*','MarkerSize',24);hold off
grid on
title('Variance Plot');legend('Night Data','Day Night Mixture')
xlabel('Type of error')
ylabel('Variance')
xticks([1:6])
xticklabels({'FirstGuess','Objective Val','ProftimesObj','ProftimesVmag','Vmag','Guess 2'})
xtickangle(45)
set(gca,'FontSize',14,'FontName','Times')
% for phase = 1:3
%     switch (phase)
%         case(1)
%             N.M_FG(phase) = mean([night.results.phACMP.firstguess]);
%             N.V_FG(phase) = var([night.results.phACMP.firstguess]);
%             D.MD_FG(phase) = mean([day_night.results.phACMP.firstguess]);
%             D.VD_FG(phase) = var([day_night.results.phACMP.firstguess]);
%
%             N.M_OBJ(phase) = mean([night.results.phACMP.obj]);
%             N.V_OBJ(phase) = var([night.results.phACMP.obj]);
%             D.MD_OBJ(phase) = mean([day_night.results.phACMP.obj]);
%             D.VD_OBJ(phase) = var([day_night.results.phACMP.obj]);
%
%             N.M_POBJ(phase) = mean([night.results.phACMP.merProfobj]);
%             N.V_POBJ(phase) = var([night.results.phACMP.merProfobj]);
%             D.MD_POBJ(phase) = mean([day_night.results.phACMP.merProfobj]);
%             D.VD_POBJ(phase) = var([day_night.results.phACMP.merProfobj]);
%
%             N.M_PVMAG(phase) = mean([night.results.phACMP.merProfVmag]);
%             N.V_PVMAG(phase) = var([night.results.phACMP.merProfVmag]);
%             D.MD_PVMAG(phase) = mean([day_night.results.phACMP.merProfVmag]);
%             D.VD_PVMAG(phase) = var([day_night.results.phACMP.merProfVmag]);
%
%             N.M_VMAG(phase) = mean([night.results.phACMP.Vmag]);
%             N.V_VMAG(phase) = var([night.results.phACMP.Vmag]);
%             D.MD_VMAG(phase) = mean([day_night.results.phACMP.Vmag]);
%             D.VD_VMAG(phase) = var([day_night.results.phACMP.Vmag]);
%
%             N.M_SG(phase) = mean([night.results.phACMP.guess2]);
%             N.V_SG(phase) = var([night.results.phACMP.guess2]);
%             D.MD_SG(phase) = mean([day_night.results.phACMP.guess2]);
%             D.VD_SG(phase) = var([day_night.results.phACMP.guess2]);
%         case(2)
%             N.M_FG(phase) = mean([night.results.phBCMP.firstguess]);
%             N.V_FG(phase) = var([night.results.phBCMP.firstguess]);
%             D.MD_FG(phase) = mean([day_night.results.phBCMP.firstguess]);
%             D.VD_FG(phase) = var([day_night.results.phBCMP.firstguess]);
%
%             N.M_OBJ(phase) = mean([night.results.phBCMP.obj]);
%             N.V_OBJ(phase) = var([night.results.phBCMP.obj]);
%             D.MD_OBJ(phase) = mean([day_night.results.phBCMP.obj]);
%             D.VD_OBJ(phase) = var([day_night.results.phBCMP.obj]);
%
%             N.M_POBJ(phase) = mean([night.results.phBCMP.merProfobj]);
%             N.V_POBJ(phase) = var([night.results.phBCMP.merProfobj]);
%             D.MD_POBJ(phase) = mean([day_night.results.phBCMP.merProfobj]);
%             D.VD_POBJ(phase) = var([day_night.results.phBCMP.merProfobj]);
%
%             N.M_PVMAG(phase) = mean([night.results.phBCMP.merProfVmag]);
%             N.V_PVMAG(phase) = var([night.results.phBCMP.merProfVmag]);
%             D.MD_PVMAG(phase) = mean([day_night.results.phBCMP.merProfVmag]);
%             D.VD_PVMAG(phase) = var([day_night.results.phBCMP.merProfVmag]);
%
%             N.M_VMAG(phase) = mean([night.results.phBCMP.Vmag]);
%             N.V_VMAG(phase) = var([night.results.phBCMP.Vmag]);
%             D.MD_VMAG(phase) = mean([day_night.results.phBCMP.Vmag]);
%             D.VD_VMAG(phase) = var([day_night.results.phBCMP.Vmag]);
%
%             N.M_SG(phase) = mean([night.results.phBCMP.guess2]);
%             N.V_SG(phase) = var([night.results.phBCMP.guess2]);
%             D.MD_SG(phase) = mean([day_night.results.phBCMP.guess2]);
%             D.VD_SG(phase) = var([day_night.results.phBCMP.guess2]);
%         case(3)
%             N.M_FG(phase) = mean([night.results.phCCMP.firstguess]);
%             N.V_FG(phase) = var([night.results.phCCMP.firstguess]);
%             D.MD_FG(phase) = mean([day_night.results.phCCMP.firstguess]);
%             D.VD_FG(phase) = var([day_night.results.phCCMP.firstguess]);
%
%             N.M_OBJ(phase) = mean([night.results.phCCMP.obj]);
%             N.V_OBJ(phase) = var([night.results.phCCMP.obj]);
%             D.MD_OBJ(phase) = mean([day_night.results.phCCMP.obj]);
%             D.VD_OBJ(phase) = var([day_night.results.phCCMP.obj]);
%
%             N.M_POBJ(phase) = mean([night.results.phCCMP.merProfobj]);
%             N.V_POBJ(phase) = var([night.results.phCCMP.merProfobj]);
%             D.MD_POBJ(phase) = mean([day_night.results.phCCMP.merProfobj]);
%             D.VD_POBJ(phase) = var([day_night.results.phCCMP.merProfobj]);
%
%             N.M_PVMAG(phase) = mean([night.results.phCCMP.merProfVmag]);
%             N.V_PVMAG(phase) = var([night.results.phCCMP.merProfVmag]);
%             D.MD_PVMAG(phase) = mean([day_night.results.phCCMP.merProfVmag]);
%             D.VD_PVMAG(phase) = var([day_night.results.phCCMP.merProfVmag]);
%
%             N.M_VMAG(phase) = mean([night.results.phCCMP.Vmag]);
%             N.V_VMAG(phase) = var([night.results.phCCMP.Vmag]);
%             D.MD_VMAG(phase) = mean([day_night.results.phCCMP.Vmag]);
%             D.VD_VMAG(phase) = var([day_night.results.phCCMP.Vmag]);
%
%             N.M_SG(phase) = mean([night.results.phCCMP.guess2]);
%             N.V_SG(phase) = var([night.results.phCCMP.guess2]);
%             D.MD_SG(phase) = mean([day_night.results.phCCMP.guess2]);
%             D.VD_SG(phase) = var([day_night.results.phCCMP.guess2]);
%     end
% end