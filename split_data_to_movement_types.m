% close all
clear
analyzie_aggregate_results
bat_nums = [2,4,5];
bat_nums = 5;
n_windows = [2,3,4,5];
n_windows = 3;
ststst = GetStaticFreq(res_table_1_peak);
res_table_2_peaks = renamevars(res_table_2_peaks, "ten_times_span_rx", "max_doppler");
desired_rx_freq = zeros(height(res_table_2_peaks),1);
for i = [2,4,5]
    desired_rx_freq(res_table_2_peaks.bat_num == i) = mean(res_table_2_peaks(res_table_2_peaks.bat_num == i,:).rx_freq);
end
res_table_2_peaks.desired_rx_freq = desired_rx_freq;
res_table_2_peaks.above_desired_rx = res_table_2_peaks.rx_freq>=res_table_2_peaks.desired_rx_freq;
res_table_2_peaks.diff_from_desired = res_table_2_peaks.rx_freq-res_table_2_peaks.desired_rx_freq;


jth_features_comb = {"echo_doppler", "tx_freq_from_filtered_tx_fft", "diff_from_desired"};
%, "closest_gps_time", "diff_from_closest_gps"};
prediction_name = "tx_freq";
for n_window = n_windows
    threshold_dict_sig = struct("tx_freq_from_filtered_tx_fft", [75000,81000], "rx_freq", [76000,84000], "durations", [0,0.15]);
    cont_inds_cell = GetNContinuesInds(all_tx_time,res_table_2_peaks.bat_num, n_window);
    inds_passing_thresholds = GetValidIndsForModelFromSignalPro(threshold_dict_sig, res_table_2_peaks);

    
    for bat_num = bat_nums
        [X, y, var_names, cont_inds_as_rows_passing_thrsholds, vaild_inds, cur_bat_gps_match] = ...
            ContIndsAndFeatures2XData(res_table_2_peaks, threshold_dict_sig, cont_inds_cell,...
            jth_features_comb, n_window, bat_num, prediction_name);
%         MarkEchoTypeThings(X,n_window, jth_features_comb)
        vaild_inds = vaild_inds(:,1);
        y_for_plot = sum(y,2);

    end
end
% echo = X(:,[1,4,7,10]);
% tx = X(:,[1,4,7,10]+1);
% diff_from = X(:,[1,4,7,10]+2);
echo = X(:,[1,4]);
tx = [X(:,[1,4]+1)];
diff_from = X(:,[1,4]+2);
compensation = diff(tx,[],2);
above_desired = double(diff_from(:,1:end-1)>=0);
figure; histogram(compensation)
figure; histogram(diff_from(:,1))

compensation_down = double(diff(tx,[],2)<0);

above_desired(above_desired == 0)  = -1;
compensation_down(compensation_down == 0)  = -1;

corr(above_desired,compensation_down)
tp = sum(above_desired&compensation_down);
fn = sum(~above_desired&~compensation_down);

sum(tx_compensation>=0 & diff_from>=0)



rx = echo+tx;

figure;
move_fig_to_laptop_screen_home
ind = randi(length(rx));
plot(tx(ind ,:), "*-");hold on
plot(rx(ind ,:), "o-")
plot((1:n_window-1), ones(1,4)*mean(res_table_2_peaks(res_table_2_peaks.bat_num == bat_num,:).rx_freq))
ylim([7.7e4,8.1e4]);
title(ind)
hold off

