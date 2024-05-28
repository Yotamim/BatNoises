
base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\08-Apr-2023\";
load(base_res_path + "agg_res_table.mat")

% load("C:\Users\yotam\Desktop\MatlabProjects\BatNoises\MarkInsectsCatching\only_perches.mat");res_table = res_table_interesting;
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
strings_mvment = res_table_2_peaks.movement_type;
strings_mvment = replace(string(strings_mvment),"fields", "field");
strings_mvment = replace(string(strings_mvment),"trees", "woods");
res_table_2_peaks.movement_type = strings_mvment;
movtypenum = zeros(size(strings_mvment));
movtypenum(strings_mvment == "woods") = 1;
movtypenum(strings_mvment == "field") = 2;
movtypenum(strings_mvment == "water") = 3;
movtypenum(strings_mvment == "hunting") = 4;
res_table_2_peaks.movement_type_num = movtypenum;
res_table_2_peaks.target_divided_by_rx = res_table_2_peaks.("desired_rx_freq")./(res_table_2_peaks.("tx_freq_from_filtered_tx_fft")+res_table_2_peaks.("echo_doppler"));
res_table_2_peaks.tx_diveded_by_tx = res_table_2_peaks.("tx_freq_from_filtered_tx_fft")./(res_table_2_peaks.("tx_freq_from_filtered_tx_fft")+res_table_2_peaks.("echo_doppler"));


all_tx_time = res_table_2_peaks.times(:,1);
threshold_dict_sig = struct("tx_freq_from_filtered_tx_fft", [77000,81000], "rx_freq", [78500,82000], "durations", [0,0.15]);

% features_lsboost_sss = {{"echo_doppler","tx_freq_from_filtered_tx_fft", "desired_rx_freq","diff_from_desired", "movement_type_num"}};
features_lsboost_sss = {{"echo_doppler","tx_freq_from_filtered_tx_fft", "speed"}};
prediction_name = "tx_freq";

n_windows = 3;
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
% 
% X_table.alpha1 = X_table.("desired_rx_freq-1")./(X_table.("tx_freq_from_filtered_tx_fft-1")+X_table.("echo_doppler-1"));
% X_table.alpha2 = X_table.("desired_rx_freq-2")./(X_table.("tx_freq_from_filtered_tx_fft-2")+X_table.("echo_doppler-2"));


% R_table = X_table(X_table.("movement_type_num-1") == 2,:);

% figure;
% histogram(X_table.("echo_doppler-1")+X_table.("tx_freq_from_filtered_tx_fft-1"))
% for i = 1:100
%     k = randi(height(X_table));
%     row = [X_lsboost(k,:),y(k)];
%     des = row(1)+row(2)-row(3);
%     plot(row([1,4,7]), "o-"); hold on; plot(row([1,4])+row([2,5]), "*-"); plot([1,2,3],[des ,des ,des ])
%     hold off
% end
% x_1 = X_table(X_table.("tx_freq_from_filtered_tx_fft-1") > 7.7e4 & X_table.("tx_freq_from_filtered_tx_fft-1") > 7.8e4,:);

% figure; scatter(X_table.("tx_freq_diff"), X_table.("echo_doppler-1"),'.')
% 
% 
% aa = cov(X_table.("echo_doppler-1"), X_table.("echo_doppler-1"));
% bb = cov(X_table.("tx_freq_diff"), X_table.("tx_freq_diff"));
% 
% cov(X_table.("tx_freq_diff")/sqrt(bb(1)), X_table.("echo_doppler-1")/sqrt(aa(1)))
% 
% 
% eig(corrcoef(X_table.("tx_freq_diff"), X_table.("echo_doppler-1")))
% X1 = X_table(X_table.("echo_doppler-1")>2500, :);
% figure;
% Hist2dAsImage(alpha1 , alpha2, [80,80], 1, 1)
% figure;
% scatter(X_table.("tx_freq_diff") , dt01,".")
% axis equal
% grid on
% figure;
% scatter(alpha1, alpha2,".")
% axis equal
% grid on
% figure;
% scatter(X_table.("diff_from_desired-1")./X_table.("speed-1"), X_table.("tx_freq_diff"), ".")
% figure;
% scatter(X_table.("echo_doppler-1"), X_table.("diff_from_desired-1"), ".")
% figure;
% Hist2dAsImage(X_table.("echo_doppler-2"), X_table.(prediction_name), [80,80], 1, 1)
% figure;
% Hist2dAsImage(X_table.("speed-1"), X_table.("echo_doppler-1"), [80,80], 1, 1)
% xlabel("tx_freq_diff")
% ylabel("echo_doppler-1")