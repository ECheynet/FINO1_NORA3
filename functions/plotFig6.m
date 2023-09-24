function plotFig6(BSH,NORA3,NEWA,SST_GHRSST,SST_BSH,zTarget)

[~,indZ_BSH] = min(abs(BSH.zTemp-zTarget));
[~,indZ_RH]  = min(abs(BSH.zHum-zTarget));

T_NORA3_100m = zeros(1,numel(BSH.time));
for ii=1:numel(BSH.time)
    x = NORA3.zT(:,ii);
    y = NORA3.T(:,ii);
    indZ0 = find(x<1400); % Only consider ehgith below 1400 m
    y = [NORA3.T0(ii);y(indZ0)]; % add surface temperature from NORA3 to the profile
    x = [0;x(indZ0)];  
    % use a polynomial fit to NORA3 temperature profile  
    [p,S,mu] = polyfit(x,y,min(3,numel(y)-1)); 
    T_NORA3_100m(ii) = polyval(p,BSH.zTemp(indZ_BSH),S,mu);
%     dummy = polyval(p,linspace(x(1),x(end),100),S,mu);
end

[~,indZ_Temp] = min(abs(BSH.zTemp-zTarget));
[~,indZ_RH]  = min(abs(BSH.zHum-zTarget));
[N_squared_BSH,N_BSH] = getBVF(BSH.Temp(indZ_Temp,:),SST_BSH,...
    BSH.zTemp(indZ_Temp),0,NORA3.P0,'RH1',BSH.RH(indZ_RH,:)*0,'RH0',0);

[N_squared_NORA3,N_NORA3] = getBVF(T_NORA3_100m,SST_GHRSST,zTarget,0,...
    NORA3.P0,'RH1',0,'RH0',0);
[N_squared_NEWA,N_NEWA] = getBVF(NEWA.T,SST_GHRSST, zTarget,0,...
    NORA3.P0,'RH1',0,'RH0',0);

n = linspace(-0.08,0.08,300);

pd = fitdist(N_BSH(:),'kernel','width',0.002);
pdf_N_BSH = pdf(pd,n);
pdf_N_BSH = pdf_N_BSH./sum(pdf_N_BSH);


pd = fitdist(N_NORA3(:),'kernel','width',0.002);
pdf_N_NORA3= pdf(pd,n);
pdf_N_NORA3 = pdf_N_NORA3./sum(pdf_N_NORA3);

pd = fitdist(N_NEWA(:),'kernel','width',0.002);
pdf_N_NEWA = pdf(pd,n);
pdf_N_NEWA = pdf_N_NEWA./sum(pdf_N_NEWA);


figure
plot(n,pdf_N_BSH,'k')
hold on
plot(n,pdf_N_NORA3,'r')
plot(n,pdf_N_NEWA,'b')
legend('BSH','NORA3','NEWA')
xlim([-0.08,0.08])
set(gcf,'color','w')
ylabel('Probabiltiy')
xlabel('$N$ (s$^{-1}$)','interpreter','latex')
set(findall(gcf,'-property','FontSize'),'FontSize',12,'FontName','Times')

end