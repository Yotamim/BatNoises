join_tag_data_and_res
joined_table = tag_table;
bat_nums = [2,5];
bat_num = 5;

n_window = 2;
bat_table = joined_table(joined_table.bat_num == bat_num & (joined_table.rx_freq_tagged-joined_table.tx_freq_tagged)>200,:);

all_tx_times = bat_table.times(bat_table.tx_freq_tagged ~= -1,1);
bat_inds = bat_table.bat_num(bat_table.tx_freq_tagged ~= -1);
bat_table.diff_from_closest_gps = (1:height(bat_table)).';
bat_table = renamevars(bat_table, "tx_freq_tagged","tx_freq_from_filtered_tx_fft");

bat_table.delay_diff = abs(bat_table.delay_points(:,1)-bat_table.delay_points(:,2));
threshold_dict_sig = struct("tx_freq_from_filtered_tx_fft", [75000,85000], "rx_freq_tagged", [75000,85000], "delay_diff", [0.001, 0.1]);
features_lsboost = {"tx_freq_from_filtered_tx_fft", "rx_freq_tagged", "rx_max_freq", "delay_diff"};
prediction_name = "tx_freq_diff";

cont_inds_cell = GetNContinuesInds(all_tx_times,bat_inds , n_window);
[X_lsboost, y_lsboost, var_names, cont_inds_as_rows_passing_thrsholds, vaild_inds, cur_bat_gps_match] = ...
    ContIndsAndFeatures2XData(bat_table, threshold_dict_sig, cont_inds_cell,...
    features_lsboost, n_window, bat_num, prediction_name);
vaild_inds = vaild_inds(:,1);
y = y_lsboost(:,1);

var_names{end+1} = prediction_name;
X_table = array2table([X_lsboost(vaild_inds,:),y(vaild_inds,:)],'VariableNames',string(var_names(2:end).'));

X_table.("echo_doppler") = X_table.("rx_freq_tagged-1")-X_table.("tx_freq_from_filtered_tx_fft-1");
X_table.("echo_doppler_max") = X_table.("rx_max_freq-1")-X_table.("tx_freq_from_filtered_tx_fft-1");
X_table = [X_table(:,1:end-3), X_table(:,end-1:end), X_table(:,end-2)];
% figure; histogram(X_table.("delay_diff-1"),50)
% figure; 
% for i = 1:length(X_table.Properties.VariableNames)-1
%     nexttile
%     inds = X_table.(X_table.Properties.VariableNames{i}) ~= -1;
% %     Hist2dAsImage(X_table.(X_table.Properties.VariableNames{i})(inds), X_table.(prediction_name)(inds), [50,50], 1, 1)
%     scatter(X_table.(X_table.Properties.VariableNames{i})(inds), X_table.(prediction_name)(inds),".")
% %     b = get(get(gca, "Title"), "String");
% %     a = replace(X_table.Properties.VariableNames{i}, "_", " ")+" \n "+b{1};
%     title(replace(X_table.Properties.VariableNames{i}, "_", " "))
% end
