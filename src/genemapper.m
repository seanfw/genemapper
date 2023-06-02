function [genemap, genevals, r, p, sig_tasks_list] = genemapper(mygene, surfacetype, comparisonmap, savegifti)
% genemapper This function creates a gene expression map for a given gene or list of genes,
% optionally compares it to another map, and optionally saves the output as a gifti file.
%
% == Inputs ==
% mygene: A string or cell array of strings specifying the gene(s) to map. 
% Each string should match a gene name in the loaded gene expression dataset.
%
% surfacetype: (Optional) A string specifying the surface type. Default is 'midthickness'. 
% Options are: 'midthickness','inflated','flat','flat_no_labels','none'. This parameter
% controls the type of surface that is used for displaying the gene expression map.
%
% comparisonmap: (Optional) A string specifying another cortical map to compare with the gene expression map. 
% Default is 'none'. Options are: 'myelin', 'cortical_thickness', 'tasks', 'tasks_sig_bonf', 
% 'tasks_sig_parbonf', 'node_strength_pos', 'node_strength_neg','part_coeff', 'hubness', 
% 'clustering_coeff','gradient1', 'gradient2', 'gradient3', 'none'. This parameter controls which 
% comparison map is used, if any.
%
% savegifti: (Optional) A string indicating whether to save the gene expression map as a gifti file. 
% Default is 'no'. If 'yes', the function saves the gene expression map as a gifti file.
%
% == Outputs ==
% genemap: A structure representing the gene expression map. The cdata field contains the 
% expression values for each vertex in the surface.
%
% genevals: The raw expression values of the gene(s) across all parcels. 
%
% r: Correlation coefficients for the comparison with another cortical map (if requested). 
% 
% p: p-values for the correlations.
%
% sig_tasks_list: Names of the tasks that showed significant correlation with the gene expression 
% (only applicable if comparisonmap is 'tasks', 'tasks_sig_bonf', or 'tasks_sig_parbonf').
%
% == Example ==
% [genemap, genevals, r, p, sig_tasks_list] = genemapper('DISC1', 'midthickness', 'myelin', 'yes');
%
% == Dependencies ==
% This function relies on the following custom functions:
% loadData(), findGeneRow(), calculateGeneVals(), saveGeneMap(), plotSurfaceType(), 
% addFlatAnnotations(), calculate_and_plot_correlation().
%
% == Errors ==
% This function will return an error if the inputs are not valid, such as a non-existing gene name 
% or an invalid surface type.


%% load data

datafile = '../data/gene_connectivity_data.mat';
data = loadData(datafile);


%% Set default options
narginchk(1, 4);
if nargin < 2
    surfacetype = 'midthickness';
end
if nargin < 3
    comparisonmap = 'none';
end
if nargin < 4
    savegifti =  'no';
end

%% Check inputs are valid

% Validate mygene
if ~(ischar(mygene) || (iscell(mygene) && all(cellfun(@ischar, mygene))))
    error('mygene must be a string or cell of strings');
end

% Validate surfacetype
validSurfaces = {'midthickness','inflated','flat','flat_no_labels','none'};
if ~ischar(surfacetype) || ~ismember(surfacetype, validSurfaces)
    error('surfacetype must be a string and one of the following: %s', strjoin(validSurfaces, ', '));
end

% Validate comparisonmap
validComparisonMaps = {'myelin', 'cortical_thickness', 'tasks', 'tasks_sig_bonf', 'tasks_sig_parbonf', 'node_strength_pos', 'node_strength_neg','part_coeff', 'hubness', 'clustering_coeff','gradient1', 'gradient2', 'gradient3', 'none'};
if ~ischar(comparisonmap) || ~ismember(comparisonmap, validComparisonMaps)
    error('comparisonmap must be a string and one of the following: %s', strjoin(validComparisonMaps, ', '));
end

% Validate savegifti
if ~ischar(savegifti) || ~ismember(savegifti, {'yes', 'no'})
    error('savegifti must be a string and either "yes" or "no"');
end

%% Main script



% Process gene expression data
genemap = data.myelin;
genemap.cdata = zeros(length(genemap.cdata), 1);
gene_row = findGeneRow(mygene, data.gene_symbol_unique);
genevals = calculateGeneVals(data.genes_parcels, gene_row, mygene);

% Map gene expression data to parcels
for current_parcel = 1:data.num_parcels
    vertices_in_parcel = find(data.MMP.cdata == data.parcel_numbers(current_parcel));
    genemap.cdata(vertices_in_parcel) = mean(data.genes_parcels(gene_row, current_parcel));
end

% Optionally save gene expression map as a gifti file
if strcmp(savegifti, 'yes')
    
    if iscell(mygene)
        file_name = inputname(1);
    else 
        file_name = mygene;
    end
    saveGeneMap(file_name, genemap);
end


%% Plot
if ~strcmp(surfacetype, 'none') % skip plotting if surfacetype is 'none'

    % Define some constants at the beginning
    colormap_choice = 'hot';
    font_size = 12;
    title_font_size = 20;
    
    if iscell(mygene)
        plot_title = sprintf('%s gene expression',inputname(1));
    else
        plot_title = sprintf('%s gene expression',mygene);
    end
    % mask out medial wall
    genemap.cdata(data.medial_wall) = genemap.cdata(data.medial_wall)-100;


    % Define the figure parameters
    figure_params = {'units','normalized','outerposition',[0 0.5 0.5 0.5]};
    
    % surfacetype-specific plot and settings
    switch surfacetype
        case 'inflated'
            plotSurfaceType(data.HCPave_inflated, genemap, data.cortex_no_medial_wall, mygene,figure_params,colormap_choice,font_size,title_font_size,plot_title);
        case 'flat'
            plotSurfaceType(data.HCPave_flat, genemap, data.cortex_no_medial_wall, mygene,figure_params,colormap_choice,font_size,title_font_size,plot_title);
            addFlatAnnotations(font_size);
        case 'flat_no_labels'
            plotSurfaceType(data.HCPave_flat, genemap, data.cortex_no_medial_wall, mygene,figure_params,colormap_choice,font_size,title_font_size,plot_title);
        case 'midthickness'
            plotSurfaceType(data.HCPave_midthickness, genemap, data.cortex_no_medial_wall, mygene,figure_params,colormap_choice,font_size,title_font_size,plot_title);
    end
    
end
 
%% compare with other cortical maps
if ~strcmp(comparisonmap, 'none') % skip plotting if surfacetype is 'none'
    if length(gene_row) > 1
        gene_data = mean(data.genes_parcels(gene_row,:))';
    else
        gene_data = data.genes_parcels(gene_row,:)';
    end

    if iscell(mygene)
        ylabel_title = sprintf('%s gene expression', inputname(1));
    else
        ylabel_title = sprintf('%s gene expression', mygene);
    end

    if strcmp(comparisonmap,'myelin')
        calculate_and_plot_correlation(data.myelin_parcels_mean, gene_data, 'myelin', ylabel_title);

    elseif strcmp(comparisonmap,'gradient1')
        calculate_and_plot_correlation(data.gradient1_parcels_mean, gene_data, 'gradient 1', ylabel_title);

    elseif strcmp(comparisonmap,'gradient2')
        calculate_and_plot_correlation(data.gradient2_parcels_mean, gene_data, 'gradient 2', ylabel_title);

    elseif strcmp(comparisonmap,'gradient3')
        calculate_and_plot_correlation(data.gradient3_parcels_mean, gene_data, 'gradient 3', ylabel_title);
    
    elseif strcmp(comparisonmap,'cortical_thickness')
        calculate_and_plot_correlation(data.cortical_thickness_parcels_mean, gene_data, 'cortical thickness', ylabel_title);
    
    elseif strcmp(comparisonmap,'node_strength_pos')
        calculate_and_plot_correlation(data.node_strength_pos', gene_data, 'node strength (pos)', ylabel_title);
    
    elseif strcmp(comparisonmap,'node_strength_neg')
        calculate_and_plot_correlation(data.node_strength_neg', gene_data, 'node strength (neg)', ylabel_title);
      
    elseif strcmp(comparisonmap,'part_coeff')
        calculate_and_plot_correlation(data.part_coeff_pos, gene_data, 'participation coefficient', ylabel_title);
    
    elseif strcmp(comparisonmap,'clustering_coeff')
        calculate_and_plot_correlation(data.clustering_coef_pos, gene_data, 'clustering coefficient', ylabel_title);
         
    elseif strcmp(comparisonmap,'hubness')
        calculate_and_plot_correlation(data.hubness_pos, gene_data, 'hubness', ylabel_title);
                
        
    elseif strcmp(comparisonmap,'tasks') || strcmp(comparisonmap,'tasks_sig_bonf') || strcmp(comparisonmap,'tasks_sig_parbonf')
        [r,p] = corr(data.tasks_parcels_mean, gene_data,'type','s');
        num_tasks = length(r);
        bonf_p = min(p*num_tasks,1);
        
        if strcmp(comparisonmap,'tasks_sig_parbonf')
            [COEFF, SCORE, LATENT, TSQUARED, EXPLAINED] = pca(data.tasks_parcels_mean);
            num_indep_contrasts = find(cumsum(EXPLAINED)>95,1);
            par_bonf_p = min(p*num_indep_contrasts,1);
            sig_tasks_list = data.task_list_combined(find(par_bonf_p<0.05));
        else
            sig_tasks_list = data.task_list_combined(find(bonf_p<0.05));
        end
        
        sig_tasks = find(bonf_p<0.05);
        num_sig_tasks = length(sig_tasks);

        if num_sig_tasks>0
            fHand = figure('units','normalized','outerposition',[0.5 0 0.5 1]);
            set(gcf,'color','w');
            aHand = axes('parent', fHand);
            hold(aHand, 'on')
            for current_task = 1:num_sig_tasks
                barh(current_task, r(sig_tasks(current_task)));
            end
            title(sprintf('%s gene-task correlations',ylabel_title),'FontSize',20); 
            set(gca,'ytick',1:num_sig_tasks)
            set(gca,'yticklabel',data.task_list_combined(sig_tasks))
            xlabel('Correlation Coefficient')
        end
    end
end




end
