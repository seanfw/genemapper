function plotSurfaceType(surfaceType, genemap, cortex_no_medial_wall, mygene,figure_params,colormap_choice,font_size,title_font_size,titleString)
    figure(figure_params{:});
    colormap(colormap_choice);
    set(gcf,'color','w');    
    plot(surfaceType,genemap);
    colorbar;
    caxis([min(genemap.cdata(cortex_no_medial_wall)),max(genemap.cdata(cortex_no_medial_wall))]);

    title(titleString,'FontSize',title_font_size);  
    set(gca, 'FontSize', font_size);
end