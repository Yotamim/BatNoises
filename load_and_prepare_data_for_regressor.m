clear
base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\08-Apr-2023\";
fig_dir = base_res_path+"figs\";
if ~isfolder(fig_dir)
    mkdir(fig_dir)
end
load(base_res_path + "agg_res_table.mat")
res_table_2_peaks = res_table(res_table.num_peaks == 2,:);
res_table_1_peak = res_table(res_table.num_peaks == 1,:);
static_freq_struct = GetStaticFreq(res_table_1_peak);
desired_rx_freq = zeros(height(res_table_2_peaks),1);
for i = [2,4,5]
    desired_rx_freq(res_table_2_peaks.bat_num == i) = mean(res_table_2_peaks(res_table_2_peaks.bat_num == i,:).rx_freq);
end

res_table_2_peaks.desired_rx_freq = desired_rx_freq;
res_table_2_peaks = renamevars(res_table_2_peaks, "ten_times_span_rx", "max_doppler");
res_table_2_peaks.above_desired_rx = res_table_2_peaks.rx_freq>=res_table_2_peaks.desired_rx_freq;
res_table_2_peaks.diff_from_desired = res_table_2_peaks.rx_freq-res_table_2_peaks.desired_rx_freq;

all_tx_time = res_table_2_peaks.times(:,1);
threshold_dict_sig = struct("tx_freq_from_filtered_tx_fft", [75000,81000], "rx_freq", [78000,82500], "durations", [0,0.15]);

features_lsboost_sss = {{"tx_freq_from_filtered_tx_fft", "echo_doppler", "diff_from_desired"}};
prediction_name = "tx_freq_diff";

n_windows = 5;
bat_nums = 5;

for ith_window = 1:length(n_windows)
    for jj = 1:length(features_lsboost_sss)
        for bat_num = bat_nums
            n_window = n_windows(ith_window);
            features_lsboost = features_lsboost_sss{jj};

            cont_inds_cell = GetNContinuesInds(all_tx_time,res_table_2_peaks.bat_num, n_window);
            [X_lsboost, y_lsboost, var_names, cont_inds_as_rows_passing_thrsholds, vaild_inds, cur_bat_gps_match] = ...
                ContIndsAndFeatures2XData(res_table_2_peaks, threshold_dict_sig, cont_inds_cell,...
                features_lsboost, n_window, bat_num, prediction_name);
            vaild_inds = vaild_inds(:,1);
            y = y_lsboost(:,1);
            
            var_names{end+1} = prediction_name;
            X_table = array2table([X_lsboost(vaild_inds,:),y(vaild_inds,:)],'VariableNames',string(var_names(2:end).'));
        end
    end
end


x_1 = X_table(X_table.("tx_freq_from_filtered_tx_fft-1") > 7.7e4 & X_table.("tx_freq_from_filtered_tx_fft-1") > 7.8e4,:);