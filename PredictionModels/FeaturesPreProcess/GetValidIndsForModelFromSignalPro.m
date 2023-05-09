function inds_passing_thresholds = GetValidIndsForModelFromSignalPro(threshold_dict, res_table_2_peaks)
inds_passing_thresholds = true(height(res_table_2_peaks),1);
fnames = fieldnames(threshold_dict);
for jth_name = 1:length(fnames)
    limss = threshold_dict.(fnames{jth_name});
    inds_passing_thresholds = inds_passing_thresholds & ...
    limss(1)<=res_table_2_peaks.(fnames{jth_name}) & ...
    res_table_2_peaks.(fnames{jth_name})<=limss(2);
end

end