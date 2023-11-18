function features_to_format = FormatFeatures(features_to_format, prediction_name)
mark_for_del = [];
for j = 1:length(features_to_format)
    if contains(features_to_format{j}, "tx_freq_from_filtered_tx_fft"); features_to_format{j} = replace(features_to_format{j}, "tx_freq_from_filtered_tx_fft","tx freq"); end
    if contains(features_to_format{j}, "movement_type"); features_to_format{j} = replace(features_to_format{j}, "_"," "); end
    if contains(features_to_format{j}, "echo_doppler"); features_to_format{j} = replace(features_to_format{j}, "echo_doppler","measured doppler difference"); end
    if contains(features_to_format{j}, "target_divided_by_rx"); features_to_format{j} = replace(features_to_format{j}, "target_divided_by_rx","(target freq)/(recived freq)"); end
    if contains(features_to_format{j}, "diff_from_desired"); features_to_format{j} = replace(features_to_format{j}, "diff_from_desired","recived freq-target freq"); end
    if contains(features_to_format{j}, "movement_type"); mark_for_del = [mark_for_del, j];  end
    if contains(features_to_format{j}, prediction_name); mark_for_del = [mark_for_del, j];  end
end
features_to_format(mark_for_del) = [];
end