
function saveGeneMap(fileName, genemap)
    % The function saves the given gene correlation map as a gifti file
    %
    % Inputs:
    % fileName - gene name
    % genemap - gene correlation map to be saved

        save(genemap,sprintf('../results/%s_map.shape.gii',fileName),'Base64Binary');
        updateGiftiFileInformation(fileName);
end