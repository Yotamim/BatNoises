function struct_coll_names = ColumnNames2Inds(cell_of_names)

if nargin == 0
    cell_of_names = {"dop_vals", "dops_freqs", "times", "audio_path", ...
    "peak_freqs", "num_peaks", "fs", "delay", "dop", "echo_doppler", "filter_echo", "filter_tx", ...
    "tx_freq_from_filtered_fft", "tx_freq_from_filtered_tx_fft", "filtered_tx", "filtered_echo",...
    "speed","closest_gps_time", "diff_from_closest_gps", "tx_var", "rx_var", "five_times_span_tx",...
    "ten_times_span_tx", "five_times_span_rx", "ten_times_span_rx"}; %"smooth_tx_fft_var", "smooth_echo_fft_var"};
end

   
for i = 1:length(cell_of_names)
    struct_coll_names.(cell_of_names{i}) = i;
end
 
end