function plotFig3(BSH,NORA3,NEWA,ERA5,zTarget)

[~,indZ_NORA] = min(abs(zTarget-NORA3.z));
[~,indZ_NEWA] = min(abs(zTarget-NEWA.z));
[~,indZ_BSH] = min(abs(zTarget-BSH.zU));

pd_NORA3 = fitdist(NORA3.U(indZ_NORA,:)','weibull');
pd_NEWA = fitdist(NEWA.U(indZ_NEWA,:)','weibull');
pd_BSH = fitdist(BSH.U(indZ_BSH,:)','weibull');

bindWidth= 0.5;

clf;close all;
figure('position',[500         300         798         538]);
tiledlayout(2,3,'tilespacing','none')

nexttile(2)
[h3,parmHat] = plotWindDistribution(BSH.U(indZ_BSH,:),[0 1 0],bindWidth);
legend off
label(['Weibull ($a = $ ',num2str(parmHat(1),3),', ','$b = $ ',num2str(parmHat(2),3),')'],0.03,0.97,'verticalalignment','top');
ylim([0,0.14])
xlim([0 30])
ylabel('pdf');
xlabel('')

nexttile(3)
[h1,parmHat] = plotWindDistribution(NORA3.U(indZ_NORA,:),[1 0 0],bindWidth);
label(['Weibull ($a = $ ',num2str(parmHat(1),3),', ','$b = $ ',num2str(parmHat(2),3),')'],0.03,0.97,'verticalalignment','top');
ylim([0,0.14])
xlim([0 30])
ylabel('')
xlabel('')

nexttile(5)
[h2,parmHat] = plotWindDistribution(NEWA.U(indZ_NORA,:),[0 0 1],bindWidth);
label(['Weibull ($a = $ ',num2str(parmHat(1),3),', ','$b = $ ',num2str(parmHat(2),3),')'],0.03,0.97,'verticalalignment','top');
ylim([0,0.14])
xlim([0 30])
ylabel('pdf');

nexttile(6)
[h4,parmHat] = plotWindDistribution(ERA5.U,[0 1 1],bindWidth);
label(['Weibull ($a = $ ',num2str(parmHat(1),3),', ','$b = $ ',num2str(parmHat(2),3),')'],0.03,0.97,'verticalalignment','top');
ylim([0,0.14])
xlim([0 30])
ylabel('')



nexttile(1,[2 1]);

U = BSH.U(indZ_BSH,:);
U(isnan(U)|isinf(U))=[];
u = linspace(min(U),max(U),100);
pd1 = fitdist(U(:),'kernel');
Y1 = pdf(pd1,u);
plot(u,Y1,'color',[0 1 0],'linewidth',2)
hold on

U = NORA3.U(indZ_NORA,:);
U(isnan(U)|isinf(U))=[];
u = linspace(min(U),max(U),100);
pd1 = fitdist(U(:),'kernel');
Y1 = pdf(pd1,u);
plot(u,Y1,'color',[1 0 0],'linewidth',2)
hold on

U = NEWA.U(indZ_NORA,:);
U(isnan(U)|isinf(U))=[];
u = linspace(min(U),max(U),100);
pd1 = fitdist(U(:),'kernel');
Y1 = pdf(pd1,u);
plot(u,Y1,'color',[0 0 1],'linewidth',2)
hold on

U = ERA5.U;
U(isnan(U)|isinf(U))=[];
u = linspace(min(U),max(U),100);
pd1 = fitdist(U(:),'kernel');
Y1 = pdf(pd1,u);
plot(u,Y1,'color',[0 1 1],'linewidth',2)
hold on
leg = legend('Measured (2009)','NORA3 (2009)','NEWA (2009)','ERA5 (1985-2015)');
set(leg,'interpreter','latex')
ylim([0,0.14])
xlim([0 30])
ylabel('pdf');


set(findall(gcf,'-property','FontSize'),'FontSize',12,'FontName','Times');

end