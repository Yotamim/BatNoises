clear
base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\03-Mar-2023\";
fig_dir = base_res_path+"figs\";
if ~isfolder(fig_dir)
    mkdir(fig_dir)
end
% tx_thr = 75000;
% speed_thr = 2;
% delay_thr = 0.005;
load(base_res_path + "aggregate_results.mat")
dominant_doppler = all_rx_freqs(:,1);
[first_cont_inds, second_cont_inds] = GetContinuesInds(all_tx_time, all_wav_ind);

last_dopp = dominant_doppler(first_cont_inds);
last_tx = all_tx_freq(first_cont_inds);
last_speed = all_speeds(first_cont_inds);
last_delay = all_delays(first_cont_inds);

next_tx = all_tx_freq(second_cont_inds);
next_dop = dominant_doppler(second_cont_inds);
an = mldivide(next_tx,[ones(length(last_dopp),1),last_dopp,last_tx,last_speed,last_delay]);

aggregate_res_scatter_plots
aggregate_res_hist_plots
aggregate_res_2d_hist_plots

aggregate_res_cont_plots

