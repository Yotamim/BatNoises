close all
clear
analyzie_aggregate_results
bat_nums = [2,4,5];
n_windows = [2,3,4,5];
% 
res_table_2_peaks.dop_divided_by_speed = res_table_2_peaks.echo_doppler./res_table_2_peaks.speed;
res_table_2_peaks.speed_divided_by_dop = res_table_2_peaks.speed./res_table_2_peaks.echo_doppler;


what_featuers_to_use = {{"echo_doppler"}, ...
    {"echo_doppler", "speed"}, ...
    {"echo_doppler", "speed", "durations"},...
    {"echo_doppler", "speed", "durations","dop_divided_by_speed"},...
    {"echo_doppler", "speed", "durations","speed_divided_by_dop"}};
prediction_name = "tx_freq_diff";
all_mse_res = cell(1,length(bat_nums));
for bat_num = bat_nums
    bat_mse_res = cell(length(n_windows)+1, length(what_featuers_to_use)+1);
    bat_mse_res{1,1} = bat_num;
    for ith_window = 1:length(n_windows)
        bat_mse_res{ith_window+1,1} = ith_window;
        n_window = n_windows(ith_window);
        for jj = 1:length(what_featuers_to_use)
            jth_features_comb = what_featuers_to_use{jj};
            bat_mse_res{1, jj+1} = string(replace(join(string(jth_features_comb),", "), "_", " "));

            threshold_dict_sig = struct("tx_freq_from_filtered_tx_fft", [75000,81000], "rx_freq", [78000,82500], "durations", [0,0.15]);
            cont_inds_cell = GetNContinuesInds(all_tx_time,res_table_2_peaks.bat_num, n_window);
            inds_passing_thresholds = GetValidIndsForModelFromSignalPro(threshold_dict_sig, res_table_2_peaks);

            [X, y, var_names, cont_inds_as_rows_passing_thrsholds, vaild_inds, cur_bat_gps_match] = ...
                ContIndsAndFeatures2XData(res_table_2_peaks, threshold_dict_sig, cont_inds_cell,...
                jth_features_comb, n_window, bat_num, prediction_name);
            
            [pred_vals, coef_table,bic_val] =  GLMPredict(X(vaild_inds,:),y(vaild_inds));
            mse = vecnorm(pred_vals-y(vaild_inds))^2;


            var_names{end+1} = "target_tx";
            mse_linear = vecnorm(pred_vals-y(vaild_inds))^2/length(pred_vals);
            bat_mse_res{ith_window+1,jj+1} = mse_linear;
        end
    end
    all_mse_res{bat_nums == bat_num} = bat_mse_res;
end



