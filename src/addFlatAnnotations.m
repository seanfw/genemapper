function addFlatAnnotations(font_size)
    annotations = {'occipital', 'lPFC', 'mPFC', 'mParietal', 'lParietal', 'temporal', 'insula'};
    % Define where the annotations should go on the flat map
    annotation_dims = [0.7 0.3 0.3 0.3; 
                   0.3 0.3 0.3 0.3;
                   0.32 0.45 0.3 0.3;
                   0.6 0.45 0.4 0.4;
                   0.55 0.25 0.3 0.3;
                   0.5 0.05 0.3 0.3;
                   0.37 0.15 0.3 0.2];

    for i = 1:length(annotations)
        a = annotation('textbox', annotation_dims(i,:), 'String', annotations{i}, 'FitBoxToText', 'on');
        a.FontSize = font_size;
    end
    
    text(0,0.5,'central sulcus','Rotation',75,'FontSize',14)

end