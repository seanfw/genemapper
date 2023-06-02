function updateGiftiFileInformation(filename)
    fid = fopen(sprintf('../results/%s_map.shape.gii',filename));
    data = textscan(fid, '%s', 'Delimiter', '\n', 'CollectOutput', true);
    fclose(fid);
    
    for I = 1:length(data{1})
        tf = strcmp(data{1}{I}, '<Value><![CDATA[S1200_MyelinMap_BC_MSMAll]]></Value>'); % search for this string in the array
        if tf == 1
            data{1}{I} = sprintf('<Value><![CDATA[%s_mRNA]]></Value>',filename); % replace with this string
        end
    end

    fid = fopen(sprintf('../results/%s_map.shape.gii',filename), 'w');
    for I = 1:length(data{1})
        fprintf(fid, '%s\n', char(data{1}{I}));
    end
    fclose(fid);
end