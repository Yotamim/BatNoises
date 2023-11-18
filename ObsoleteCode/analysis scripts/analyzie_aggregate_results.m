clear
base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\08-Apr-2023\";
fig_dir = base_res_path+"figs\";
if ~isfolder(fig_dir)
    mkdir(fig_dir)
end
load(base_res_path + "agg_res_table.mat")
res_table_2_peaks = res_table(res_table.num_peaks == 2,:);
res_table_1_peak = res_table(res_table.num_peaks == 1,:);
res_table_others = res_table(res_table.num_peaks >= 3,:);
static_freq_struct = GetStaticFreq(res_table_1_peak);
static_frq_col = zeros(height(res_table_2_peaks),1);
for i = [2,4,5]
    static_frq_col(res_table_2_peaks.bat_num == i) = static_freq_struct.("bat"+num2str(i)) ;
end
res_table_2_peaks.static_tx_freq = static_frq_col;

dominant_doppler = res_table_2_peaks.rx_freq;
all_tx_time = res_table_2_peaks.times(:,1);
all_tx_var = res_table_2_peaks.tx_var(:,1);
all_tx_7db = res_table_2_peaks.five_times_span_tx(:,1);
all_tx_10db = res_table_2_peaks.ten_times_span_tx(:,1);

all_rx_var = res_table_2_peaks.rx_var(:,1);
all_rx_7db = res_table_2_peaks.five_times_span_rx(:,1);
all_rx_10db = res_table_2_peaks.ten_times_span_rx(:,1);

all_tx_freq = res_table_2_peaks.tx_freq_from_filtered_tx_fft;
all_speeds = res_table_2_peaks.speed;
all_delays = res_table_2_peaks.delay;
all_durations = res_table_2_peaks.durations;
diff_to_closest_gps = res_table_2_peaks.diff_from_closest_gps;

[first_cont_inds, second_cont_inds] = GetContinuesInds(all_tx_time);


last_dopp = dominant_doppler(first_cont_inds);
last_tx = all_tx_freq(first_cont_inds);
last_speed = all_speeds(first_cont_inds);
last_delay = all_delays(first_cont_inds);
last_rx_var = all_rx_var(first_cont_inds);
last_speed_diff_gps = diff_to_closest_gps(first_cont_inds);

next_tx = all_tx_freq(second_cont_inds);
next_dop = dominant_doppler(second_cont_inds);
next_speed = all_speeds(second_cont_inds);
next_speed_diff_gps = diff_to_closest_gps(second_cont_inds);

n_window = 2; 
cont_inds_cell = GetNContinuesInds(all_tx_time,res_table_2_peaks.bat_num, n_window);
% GLMPredict(X_data, y)

% aggregate_res_scatter_plots
% aggregate_res_hist_plots
% aggregate_res_2d_hist_plots
% aggregate_res_cont_plots
aggregate_res_cont_plots_per_bat
    



