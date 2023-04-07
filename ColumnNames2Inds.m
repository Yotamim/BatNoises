function struct_coll_names = ColumnNames2Inds(cell_of_names)

if nargin == 0
    cell_of_names = {"dop_vals", "dops_freqs", "times", "audio_path", ...
    "peak_freqs", "num_peaks", "bb_fs", "delay", "dop", "echo_doppler", "filter_echo", "filter_tx", ...
    "tx_freq_from_filtered_fft", "tx_freq_from_filtered_tx_fft", "filtered_tx", "filtered_echo",
    "smooth_tx_fft_var", "smooth_echo_fft_var"};
end

for i = 1:length(cell_of_names)
    struct_coll_names.(cell_of_names{i}) = i;
end

end