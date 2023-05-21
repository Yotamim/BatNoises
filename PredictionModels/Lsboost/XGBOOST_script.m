% close all
clear
base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\08-Apr-2023\";

load(base_res_path + "agg_res_table.mat")
res_table_2_peaks = res_table(res_table.num_peaks == 2,:);
res_table_1_peak = res_table(res_table.num_peaks == 1,:);
% static_freq_struct = GetStaticFreq(res_table_1_peak);
desired_rx_freq = zeros(height(res_table_2_peaks),1);
for i = [2,4,5]
    desired_rx_freq(res_table_2_peaks.bat_num == i) = mean(res_table_2_peaks(res_table_2_peaks.bat_num == i,:).rx_freq);
end
res_table_2_peaks.desired_rx_freq = desired_rx_freq;
res_table_2_peaks = renamevars(res_table_2_peaks, "ten_times_span_rx", "max_doppler");
res_table_2_peaks.above_desired_rx = res_table_2_peaks.rx_freq>=res_table_2_peaks.desired_rx_freq;
res_table_2_peaks.diff_from_desired = res_table_2_peaks.rx_freq-res_table_2_peaks.desired_rx_freq;

all_tx_time = res_table_2_peaks.times(:,1);
n_windows = [2,3,4,5];
threshold_dict_sig = struct("tx_freq_from_filtered_tx_fft", [75000,81000], "rx_freq", [78000,82500], "durations", [0,0.15]);

features_lsboost_sss = {...
    {"tx_freq_from_filtered_tx_fft", "echo_doppler", "diff_from_desired"}};
% ,...
%     {"echo_doppler", "max_doppler"},...
%     {"echo_doppler", "durations"},...
%     {"echo_doppler", "durations", "speed"},...
%     };
prediction_name = "tx_freq_diff";
bat_nums = [2,4,5];
% all_mse_res = cell(length(n_windows)+1, length(features_lsboost_sss)+1);
% all_mse_res{ith_window+1,1} = ith_window;
% all_mse_res{1, jj+1} = string(replace(join(string(features_lsboost),", "), "_", " "));
% all_mse_res{ith_window+1,jj+1} = mse_lsboost;

for ith_window = 1:length(n_windows)
    for jj = 1:length(features_lsboost_sss)
        figure;
        for bat_num = bat_nums
            n_window = n_windows(ith_window);
            features_lsboost = features_lsboost_sss{jj};

            cont_inds_cell = GetNContinuesInds(all_tx_time,res_table_2_peaks.bat_num, n_window);
            [X_lsboost, y_lsboost, var_names, cont_inds_as_rows_passing_thrsholds, vaild_inds, cur_bat_gps_match] = ...
                ContIndsAndFeatures2XData(res_table_2_peaks, threshold_dict_sig, cont_inds_cell,...
                features_lsboost, n_window, bat_num, prediction_name);
            vaild_inds = vaild_inds(:,1);
            if prediction_name == "tx_freq_diff"
                y = y_lsboost(:,1);
            else
                y = y_lsboost(:,2);
            end
            var_names{end+1} = prediction_name;
            X_table = array2table([X_lsboost(vaild_inds,:),y(vaild_inds,:)],'VariableNames',string(var_names(2:end).'));
            p = 0.75;
            perm_inds = randperm(height(X_table));
            train_inds = perm_inds(1:ceil(length(perm_inds)*p));
            test_inds = perm_inds(ceil(length(perm_inds)*p)+1:end);
            mdl_lsboost = fitrensemble(X_table(train_inds,:), var_names{end});
            pred_y_LSBOOST_test = predict(mdl_lsboost,X_table(test_inds,:));
            pred_y_LSBOOST_train = predict(mdl_lsboost,X_table(train_inds,:));

            y_test = X_table.(prediction_name)(test_inds,:);
            subplot(2,3,find(bat_num == bat_nums))
            scatter(y_test, y_test-pred_y_LSBOOST_test, ".");
%             xlim = get(gca, "XLim");
%             ylim = get(gca, "YLim");
%             hold on; plot(xlim(1):xlim(2), xlim(1):xlim(2), "m")
            title("val vs error bat"+num2str(bat_num))

            subplot(2,3,find(bat_num == bat_nums)+3)
            scatter(y_test, pred_y_LSBOOST_test, ".");
            xlim = get(gca, "XLim");
            ylim = get(gca, "YLim");
            hold on; plot(xlim(1):xlim(2), xlim(1):xlim(2), "m")
            title("val vs pred bat"+num2str(bat_num))

            subplot(3,3,find(bat_num == bat_nums)+6)
            scatter(X_table.(prediction_name)(train_inds,:), X_table.(prediction_name)(train_inds,:)-pred_y_LSBOOST_test, ".");
            title("val vs error bat"+num2str(bat_num))


        end
        sgtitle(replace(join(string(features_lsboost), " "), "_", " ")+" "+num2str(mean(abs(y_test-pred_y_LSBOOST_test))))
    end
    
end
