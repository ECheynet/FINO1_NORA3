function plotFig4(BSH,NORA3,NEWA,ERA5,zTarget)

[~,indZ_BSH] = min(abs(zTarget-BSH.zDir));
% indU =find(time_BSH<datetime(2009,06,01,0,0,0));
indU = find(BSH.U(indZ_BSH,:)>0);


dummyDir_NORA3 = interp1(NORA3.z,NORA3.D(:,indU),BSH.zDir(indZ_BSH));
dummyDir_NEWA = interp1(NORA3.z,NEWA.D(:,indU),BSH.zDir(indZ_BSH));

theta = 0:1:360;
clear leg

% clf;close all
figure
h = polaraxes;

biasDir_NORA3 = median(circ_dist(pi/180*BSH.Dir(indZ_BSH,indU)',pi/180*dummyDir_NORA3'),'omitnan')*180/pi;
biasDir_NEWA = median(circ_dist(pi/180*BSH.Dir(indZ_BSH,indU)',pi/180*dummyDir_NEWA'),'omitnan')*180/pi;

% pd = fitdist(BSH.Dir(indZ_BSH,:)','kernel');
% rho = pdf(pd,theta);
[rho] = circ_ksdensity(BSH.Dir(indZ_BSH,indU)', theta, 'msni');
polarplot(theta*pi/180,rho,'color',[0 0 0],'linewidth',1.1)
hold on
leg{1} = ['Measured (2009)'];

% pd = fitdist(BSH.Dir(indZ_BSH,:)','kernel');
% rho = pdf(pd,theta);
% polarplot(theta*pi/180,rho,'color',[0 0 0])
% hold on
% leg{1} = ['BSH (2009)'];

rho = circ_ksdensity(dummyDir_NORA3', theta, 'msni');
polarplot(theta*pi/180,rho,'color',[1 0 0],'linewidth',1.1)
hold on
leg{2} = ['NORA3 (2009)'];


% pd = fitdist(NEWA.D(indZ_NORA,:)','kernel');
% rho = pdf(pd,theta);
rho = circ_ksdensity(dummyDir_NEWA', theta, 'msni');
polarplot(theta*pi/180,rho,'color',[0 0 1],'linewidth',1.1)
hold on
leg{3} = ['NEWA (2009)'];

% pd = fitdist(ERA5.D,'kernel');
% rho = pdf(pd,theta);

if abs(zTarget-100)<10,
    rho = circ_ksdensity(ERA5.D, theta, 'msni');
    polarplot(theta*pi/180,rho,'color',[0 1 1],'linewidth',1.1)
    hold on
    leg{4} = ['ERA5 (1985-2015)'];
end
l =legend(leg{:});
l.Position = [0.60 0.6280 0.3125 0.1940];
% leg = legend([h1,h2,h3],['NORA3 ( $a = $ ', num2str(parmHat1(1),3),', ','$b = $',num2str(parmHat1(2),3),')'],...
%     ['NEWA ( $a = $ ',num2str(parmHat2(1),3),', ','$b = $ ',num2str(parmHat2(2),3),')'],...
%     ['NORA3 ( $a = $ ',num2str(parmHat3(1),3),', ','$b = $ ',num2str(parmHat3(2),3),')']);
% set(leg,'interpreter','latex')
set(findall(gcf,'-property','FontSize'),'FontSize',14,'FontName','Times')
set(gcf,'color','w')
h.ThetaZeroLocation = 'top';
h.ThetaDir = 'clockwise';

rlim([0 6e-3])
label(['z = ' num2str(BSH.zDir(indZ_BSH)),' m'],0.7,0.3,'verticalalignment','top','fontsize',14,'Color','black');

fprintf([' circular distance between BSH and NORA3 is % 1.2f \n'],biasDir_NORA3);
fprintf([' circular distance between BSH and NEWA is % 1.2f \n'], biasDir_NEWA);

end