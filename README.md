 genemapper 
 
 A Matlab function to map the expression of genes onto the Human
 Connectome Project (HCP) average cortical surface (midthickness), and
 correlate with the HCP group average structural, functional, or
 graph-theory-derived maps (Froudist-wWals et al., 2023).
 
 Depends on Guillaume Flandin's gifti toolbox (included)
 http://www.artefact.tk/software/matlab/gifti/
 
 Inputs:
 mygene        - gene name from the list genenames 
                 (from the file genenames.mat)
                 Can be either a character array, such as 'DRD1'
                 or a cell. In the case of a cell, expression values will
                 be averaged across all listed genes e.g.
                 dopaminereceptors = {'DRD1','DRD2','DRD3','DRD4','DRD5}
 surfacetype   - surface for visualisation. Can be 'midthickness',
                 'inflated','flat','flat_no_labels' or 'none'. 
                 Default - 'midthickness'
 comparisonmap - Correlate your genemap with any of the following
                 'myelin' - the Human Connectome Project group
                 average myelin (s1200 release - MSMall registered)

                 'cortical_thickness' - the Human Connectome Project group
                 average cortical thickness (s1200 release - MSMall reg)

                 'tasks' - correlates your genemap with
                 each of the 86 task contrasts from the HCP s1200 release.

                 'tasks_sig_bonf' - displays statistically significant 
                 correlations between your genemap and activation maps, 
                 Bonferroni corrected for number of task contrast maps.

                 'tasks_sig_parbonf' - displays statistically significant 
                 correlations between your genemap and activation maps, 
                 using the less stringent partial Bonferroni correction
                 (Scholtens et al., 2014).  

                 Connectivity-based options, based on the the Human 
                 Connectome Project resting-state fMRI data, 
                 (812 subjects reconstructed with the r227 recon),
                 calculated on the positive functional connections.
                 Graph-theory metrics were calculated using the Brain
                 Connectivity Toolbox (Rubinov & Sporns, 2010).
       
                 'node_strength' - displays correlation between your
                 genemap and the node strength map

                 'part_coeff' - displays correlation between your
                 genemap and the participation coefficient map

                 'hubness' - displays correlation between your
                 genemap and the hubness metric, which is the loadings of
                 each area on the 1st principal component of the node
                 strength and participation coefficient data
                 (Froudist-Walsh et al., 2018)

                 'clustering_coeff' - displays correlation between your
                 genemap and the clustering coefficient.
 
                 'gradient1' - connectivity gradient 1 from Margulies et
                 al, 2016

                 'gradient2' - connectivity gradient 2 from Margulies et
                 al, 2016

                 'gradient3' - connectivity gradient 3 from Margulies et
                 al, 2016

                 'none' - perform no correlations.

                 Default: 'none'
 
 savegifti     - Optionally save gene expression map as a gifti surface
                 file in the working directory, for visualisation in
                 wb_view or other programs. 'yes' or 'no'. Default: 'no'

 Outputs: 
 genemap       - The map of your chosen gene, in gifti format (~32k
                 vertices)
 genevals      - a vector of gene expression values per brain region,
                 from the Glasser et al., 2016 parcellation, left 
                 hemisphere)
 r             - Spearman's correlation coefficient
 p             - uncorrected p-value from the correlation
 sig_tasks_list- list of significant task contrasts (available 
                 if 'tasks_sig_bonf'  or 'tasks_sig_parbonf' have been 
                 chosen).

 
 Examples: 
 Visualise expression of dopamine D1 receptor gene on the surface:
 [DRD5map, DRD5vals] = genemapper('DRD5');

 Visualise expression of serotonin HT1A receptor gene on the inflated 
 surface, correlate with HCP tasks, and output the significant task 
 contrasts following Bonferroni correction:
 [~,~,~,~,sig_tasks_list] = genemapper('HTR1A','inflated','tasks_sig_bonf')

 Visualise average expression of interneuron markers CALB1 and SST on an
 annotated flatmap, correlate with cortical thickness, and save the gene
 expression map as a gifti file for later visualisation in wb_view
 interneurons = {'CALB1','SST'}
 genemapper(interneurons,'flat','cortical_thickness','yes');

 Visualise average expression of the top 10 astrocyte markers (Cahoy et
 al., 2008), which had significant expression in the Allen Human Brain
 Atlas data (Hawrylycz et al., 2012), display on an inflated surface, and
 correlate with cortical thickness
 astrocytes = {'GFAP','AQP4','PLA2G7','SLC39A12','MLC1','DIO2',...
               'SLC14A1','ALDH1L1','ALDOC','TTPA'}
 genemapper(astrocytes,'inflated','cortical_thickness')

 Visualise average expression of the top 10 oligodendrocyte markers (Cahoy
 et al., 2008), which had significant expression in the Allen Human Brain
 Atlas data (Hawrylycz et al., 2012), display on an flat surface, and
 correlate with hubness
 oligodendrocytes = {'MOG','MOBP','ENPP6','CLDN11','MAG','PLEKHH1',...
                      'FA2H','SGK2','IL23A','MBP'}
 genemapper(oligodendrocytes,'flat','hubness')

 Note:
 This is inspired by the methods from Burt et al., BioRxiv, 2017.
 
 References:
 
 Paper describing this code:
 Froudist-Walsh S; T Xu; M Niu; L Rapan; D Margulies; K Zilles; XJ Wang+ 
 N Palomero-Gallagher+. “Gradients of receptor expression in the macaque neocortex”. 
 Nature Neuroscience (2023 – in press) 
 
 Correlating myelin maps with Allen Institute gene expression:
 Burt, Josh B., Murat Demirtas, William J. Eckner, Natasha M. Navejar, 
 Jie Lisa Ji, William J. Martin, Alberto Bernacchia, Alan Anticevic, and 
 John D. Murray. "Hierarchy of transcriptomic specialization across human 
 cortex captured by myelin map topography." bioRxiv (2017): 199703.

 Human Connectome Project 
 Parcellation:
 Glasser, Matthew F., Timothy S. Coalson, Emma C. Robinson, Carl D. Hacker
 John Harwell, Essa Yacoub, Kamil Ugurbil et al. "A multi-modal 
 parcellation of human cerebral cortex." Nature 536, no. 7615 (2016): 
 171-178.
 For a full list of relevant HCP references, see 
 https://www.humanconnectome.org/study/hcp-young-adult/document/hcp-citations
 
 Allen Human Brain Atlas
 Hawrylycz, Michael J., Ed S. Lein, Angela L. Guillozet-Bongaarts, 
 Elaine H. Shen, Lydia Ng, Jeremy A. Miller, Louie N. Van De Lagemaat et 
 al. "An anatomically comprehensive atlas of the adult human brain 
 transcriptome." Nature 489, no. 7416 (2012): 391-399.

 Partial Bonferroni correction:
 Scholtens, Lianne H., Ruben Schmidt, Marcel A. de Reus, and Martijn P. 
 van den Heuvel. "Linking macroscale graph analytical organization to 
 microscale neuroarchitectonics in the macaque connectome." Journal of 
 Neuroscience 34, no. 36 (2014): 12192-12205.

 Brain Connectivity Toolbox: 
 Rubinov, Mikail, and Olaf Sporns. "Complex 
 network measures of brain connectivity: uses and interpretations." 
 Neuroimage 52, no. 3 (2010): 1059-1069.

 Hubness:
 Froudist-Walsh, Sean, Philip GF Browning, James J. Young, Kathy L. Murphy,
 Rogier B. Mars, Lazar Fleysher, and Paula L. Croxson. "Macro-connectomics 
 and microstructure predict dynamic plasticity patterns in the non-human 
 primate brain." Elife 7 (2018): e34354.
 
 Gradients (of connectivity):
 Margulies, Daniel S., Satrajit S. Ghosh, Alexandros Goulas, Marcel 
 Falkiewicz, Julia M. Huntenburg, Georg Langs, Gleb Bezgin et al. 
 "Situating the default-mode network along a principal gradient of 
 macroscale cortical organization." Proceedings of the National Academy of
 Sciences 113, no. 44 (2016): 12574-12579.
 

 SEAN FROUDIST-WALSH (University of Bristol)
