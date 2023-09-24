function plotFig2(BSH,NORA3,NEWA,zTarget)
ll= 1;


figure
tiledlayout(1,2,'tilespacing','tight')
for ii=1:numel(zTarget)
    [diffZ,indZ_BSH] = min(abs(zTarget(ii)-BSH.zU));
    if diffZ<5
        
        dummyU_NORA3 = interp1(NORA3.z,NORA3.U,BSH.zU(indZ_BSH),'pchip');
        dummyU_NEWA = interp1(NORA3.z,NEWA.U,BSH.zU(indZ_BSH),'pchip');
        
        nexttile
        plot(BSH.U(indZ_BSH,:),dummyU_NORA3,'r.');
        hold on
        plot(BSH.U(indZ_BSH,:),dummyU_NEWA,'b.');
        %         plot(BSH.U(indZ,:),0.5*(NEWA.U(ii,:) + NORA3.U(ii,:)),'g.');
        axis equal
        xlim([0 30]);
        ylim([0 30])
        hold on
        plot([0 30],[0 30],'k')
        label(['z = ' num2str(BSH.zU(indZ_BSH)),' m'],0.03,0.97,'verticalalignment','top','fontsize',8,'Color','black');
        
        clear R2
        mdl = fitlm(BSH.U(indZ_BSH,:),dummyU_NORA3);
        R2.NORA3 = mdl.Rsquared.Ordinary;
        mdl = fitlm(BSH.U(indZ_BSH,:),dummyU_NEWA);
        R2.NEWA = mdl.Rsquared.Ordinary;
        
        str = num2str(round(R2.NORA3*100)/100);
        if numel(str)<4, str = [str,'0']; end
        label(['$R^2 = ',str,'$'],0.03,0.87,'verticalalignment','top','fontsize',8,'Color','red');
        
        str = num2str(round(R2.NEWA*100)/100);
        if numel(str)<4, str = [str,'0']; end
        label(['$R^2 = ',str,'$'],0.03,0.77,'verticalalignment','top','fontsize',8,'Color','blue');
        
        ll=ll+1;
        if ll==2,leg = legend(gca,'NORA3','NEWA','location','southeast');  end
        %         leg.Position = [0.7 0.91 0.1332 0.0498];
        
        xlabel('$\overline{u}$ (ms$^{-1}$)  -- Measured','interpreter','latex');
        ylabel('$\overline{u}$ (ms$^{-1}$)  -- Modelled','interpreter','latex');
        
       
        
    end
end
set(findall(gcf,'-property','FontSize'),'FontSize',10,'FontName','Times')
set(gcf,'color','w')

end