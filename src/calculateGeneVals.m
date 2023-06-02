function genevals = calculateGeneVals(genes_parcels, gene_row, mygene)
    % Returns the expression values of the gene(s) specified by gene_row.
    if iscell(mygene)
        genevals = mean(genes_parcels(gene_row, :))';
    else
        genevals = genes_parcels(gene_row, :)';
    end
end