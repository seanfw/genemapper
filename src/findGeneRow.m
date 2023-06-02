function gene_row = findGeneRow(mygene, gene_symbol_unique)
% Returns the row number(s) in gene_symbol_unique corresponding to mygene.
    if iscell(mygene)
        gene_row = nan(length(mygene), 1);
        for current_gene = 1:length(mygene)
            gene_row(current_gene) = find(strcmp(mygene{current_gene}, gene_symbol_unique), 1);
        end
    else
        gene_row = find(strcmp(mygene, gene_symbol_unique), 1);
    end
end
