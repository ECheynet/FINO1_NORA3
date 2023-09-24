function [h1,parmHat1] = plotWindDistribution(U,COLOR,bindWidth)


% U = newU_NORA3(indZ_NORA,:);
U(isnan(U)|isinf(U))=[];
maxU = nanmax(U);

h1 = [];

% vbins = 0:bindWidth:ceil(maxU);
% h1 = histogram(U(:), vbins,'Normalization','pdf');
% h1.FaceColor = COLOR;
% h1.FaceAlpha = 0.3;
% hold on

u = linspace(min(U),max(U),100);
pd1 = fitdist(U(:),'kernel');
Y1 = pdf(pd1,u);
plot(u,Y1,'color',COLOR,'linewidth',2)
hold on


xlabel('$\overline{u}$ (m s$^{-1}$)','interpreter','latex'); 
ylabel('Probability densiy function');
parmHat1 = wblfit(U(:));
y = wblpdf(0:0.1:ceil(max(maxU)),parmHat1(1),parmHat1(2));
plot(0:0.1:ceil(max(maxU)),y,'color','k','linewidth',2)
set(gcf,'color','w')




end

