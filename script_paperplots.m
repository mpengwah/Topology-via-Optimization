clc;clear all;close all;
%Written BY Pengwah Abu Bakr Siddique
%ID: 27195139

t = 0:.1:4*pi;
y = sin(t);
figure('Units','inches','Position',[5 5 4 2],'PaperPositionMode','auto')
plot(t,y)

%axis modifications
axis([0 t(end) -1.5 1.5])
set(gca,'Units','normalized','YTick',-1.5:.5:1.5,'XTick',0:t(end)/4:t(end),...
    'Position',[.15 .2 .75 .7],'FontUnits','points','FontWeight',...
    'normal','FontSize',9,'FontName','Times New Roman')

ylabel({'$y(t)$'},'FontUnits','points','interpreter','latex','FontSize',9,...
    'FontName','Times New Roman')
xlabel('Time(s)','FontUnits','points','FontSize',7,...
    'FontName','Times New Roman','FontWeight','normal')

legend({'$y=\sin(t)$'},'interpreter','latex',...
'FontSize',7,'FontName','Times','Location','NorthEast')

title('Sinsoidal function','FontUnits','points','FontWeight','normal',...
    'FontSize',7,'FontName','Times')
set(gcf,'PaperUnits','inches', 'PaperSize', [4 2]);
print('myplot','-dpdf','-r0')