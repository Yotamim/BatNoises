function [X, y, var_names, cont_inds_as_rows_passing_thrsholds, vaild_inds, cur_bat_gps_match] = ...
    ContIndsAndFeatures2XData(res_table_2_peaks, threshold_dict_sig, cont_inds_cell, ...
    features_to_use, n_window, bat_num, prediction_name)

inds_passing_thresholds = GetValidIndsForModelFromSignalPro(threshold_dict_sig, res_table_2_peaks);

var_names = {"bias"};
X = [];
cur_bat_gps_match = [];
inds_mat = [cont_inds_cell{:}];
cont_inds_as_rows = [];
for ii = 1:size(inds_mat,2)
    cont_inds_as_rows = [cont_inds_as_rows, find(inds_mat(:,ii))];
end
inds_passing_thresholds_bat = inds_passing_thresholds & res_table_2_peaks.bat_num == bat_num;
cont_rows_passing_thrsholds = sum(inds_passing_thresholds_bat(cont_inds_as_rows),2) == n_window;
cont_inds_as_rows_passing_thrsholds = cont_inds_as_rows(cont_rows_passing_thrsholds,:);
for ith_ind = 1:size(cont_inds_as_rows_passing_thrsholds,2)-1
    for k = 1:length(features_to_use)
        X = [X, res_table_2_peaks(cont_inds_as_rows_passing_thrsholds(:,ith_ind),:).(features_to_use{k})];
        var_names{end+1} = features_to_use{k}+num2str(-n_window+ith_ind);
    end
    cur_bat_gps_match = [cur_bat_gps_match,abs(res_table_2_peaks(cont_inds_as_rows_passing_thrsholds(:,ith_ind),:).diff_from_closest_gps)];
end
if prediction_name == "tx_freq_diff"
    y = res_table_2_peaks(cont_inds_as_rows_passing_thrsholds(:,end),:).tx_freq_from_filtered_tx_fft -...
    res_table_2_peaks(cont_inds_as_rows_passing_thrsholds(:,end-1),:).tx_freq_from_filtered_tx_fft;
elseif prediction_name == "tx_freq"
    y = res_table_2_peaks(cont_inds_as_rows_passing_thrsholds(:,end),:).tx_freq_from_filtered_tx_fft;
end
y = [y, res_table_2_peaks(cont_inds_as_rows_passing_thrsholds(:,end-1),:).tx_freq_from_filtered_tx_fft];
% y = res_table_2_peaks(cont_inds_as_rows_passing_thrsholds(:,end),:).tx_freq_from_filtered_tx_fft;

y_speed = res_table_2_peaks(cont_inds_as_rows_passing_thrsholds(:,end),:).speed;
y_gps_match = abs(res_table_2_peaks(cont_inds_as_rows_passing_thrsholds(:,end),:).diff_from_closest_gps);
if any(cellfun(@(x) contains(x, "speed"), features_to_use))
    X = [X,y_speed];
    var_names{end+1} = "speed-0";
    cur_bat_gps_match = [cur_bat_gps_match,y_gps_match];
    vaild_inds = max(cur_bat_gps_match,[],2)<10 & sum(isnan(X),2) == 0;
else
    vaild_inds = true(size(y));
end


end