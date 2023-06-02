function calculate_and_plot_correlation(map1, gene_data, xlabel_title, ylabel_title)
    [r, p] = corr(map1, gene_data,'type','s');
    figure('units','normalized','outerposition',[0.5 0.5 0.5 0.5])
    set(gcf,'color','w');
    scatter(map1, gene_data, 'k', 'filled');
    lsline;
    xlabel(xlabel_title,'FontSize',20);
    ylabel(ylabel_title,'FontSize',20);
    dim = [0.6 .5 .3 .3];
    str = sprintf('r = %0.2f, p = %0.8f', r, round(p,8));
    a = annotation('textbox',dim,'String',str,'FitBoxToText','on');
    a.FontSize = 24;
end