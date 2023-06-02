function [loadedData] = loadData(genemapsfile, connectivityfile)
    % Load data
    try
        loadedData = load(genemapsfile);
    catch ME
        error('Error loading data: %s', ME.message);
    end
end