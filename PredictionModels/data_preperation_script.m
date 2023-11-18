%% Load and prepare data

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
res_table_2_peaks.tx_diveded_by_rx = res_table_2_peaks.("tx_freq_from_filtered_tx_fft")./(res_table_2_peaks.("tx_freq_from_filtered_tx_fft")+res_table_2_peaks.("echo_doppler"));
all_tx_time = res_table_2_peaks.times(:,1);
