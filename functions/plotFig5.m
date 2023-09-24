function plotFig5(BSH,NORA3,NEWA,zTarget)


%% Find nearest location to 101 m
[diffZ2,indZ_BSH] = min(abs(zTarget-BSH.zTemp));

%% Interpolate NORA3 temperature at 101 m 
% NROA3 data are provided on pressure level, converted into height level.
% The height levels are different every hours
% At each time step, we need thus to interpolate th temperature profile to
% the target height
% 
% This operation is not necessary for NWEA as the temperarure data is
% already provided at 100 m 

T_NORA3_100m = zeros(1,numel(BSH.time));
for ii=1:numel(BSH.time)
    x = NORA3.zT(:,ii);
    y = NORA3.T(:,ii);
    
    indZ = find(x<1400); % Only consider ehgith below 1400 m
    y = [NORA3.T0(ii);y(indZ)]; % add surface temperature from NORA3 to the profile
    x = [0;x(indZ)];  
    % use a polynomial fit to NORA3 temperature profile  
    [p,S,mu] = polyfit(x,y,min(3,numel(y)-1)); 
    T_NORA3_100m(ii) = polyval(p,BSH.zTemp(indZ_BSH),S,mu);
%     dummy = polyval(p,linspace(x(1),x(end),100),S,mu);
end



figure
tiledlayout(1,2,'tilespacing','tight')
nexttile
plot(BSH.Temp(indZ_BSH,:),T_NORA3_100m,'r.');
Nsamples = num2str(numel(find(~isnan(BSH.Temp(indZ_BSH,:).*T_NORA3_100m))));
axis equal
xlim([270 300]);
ylim([270 300])
hold on
plot([270 300],[270 300],'k')
grid on
xlabel('Temperature @ 101 m -- FINO1 (K)')
ylabel('Temperature  @ 101 m -- NORA3 (K)')
set(gcf,'color','w')
label(['N = ',Nsamples],0.03,0.77);
mdl = fitlm(BSH.Temp(indZ_BSH,:),T_NORA3_100m);
R2= mdl.Rsquared.Ordinary;
label(['$R^2 = ',num2str(round(R2*1000)/1000),'$'],0.03,0.95,'verticalalignment','top','fontsize',12,'Color','red');


nexttile

plot(BSH.Temp(indZ_BSH,:),NEWA.T,'b.');
Nsamples = num2str(numel(find(~isnan(BSH.Temp(indZ_BSH,:).*T_NORA3_100m))));
axis equal
xlim([270 300]);
ylim([270 300])
hold on
plot([270 300],[270 300],'k')
grid on
xlabel('Temperature @ 101 m -- FINO1 (K)')
ylabel('Temperature  @ 101 m -- NEWA (K)')
set(gcf,'color','w')
label(['N = ',Nsamples],0.03,0.77);
mdl = fitlm(BSH.Temp(indZ_BSH,:),NEWA.T);
R2 = mdl.Rsquared.Ordinary;
label(['$R^2 = ',num2str(round(R2*1000)/1000),'$'],0.03,0.95,'verticalalignment','top','fontsize',12,'Color','blue');

set(findall(gcf,'-property','FontSize'),'FontSize',10,'FontName','Times')

fprintf(['Temperature bias between BSH and NEWA: ',num2str(nanmedian(-BSH.Temp(indZ_BSH,:)+NEWA.T(:)'),3),' \n']);
fprintf(['Temperature bias between BSH and NORA3: ',num2str(nanmedian(-BSH.Temp(indZ_BSH,:)+T_NORA3_100m(:)'),3),' \n']);



end