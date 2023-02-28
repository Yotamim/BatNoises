function struct_coll_names = ColumnNames2Inds(cell_of_names)

if nargin == 0
    cell_of_names = {"fft_data", "dop_vals", "dops_freqs", "times", "audio_path", ...
        "peak_freqs", "num_peaks", "bb_fs", "delay", "dop", "freq_xcor","freq_lags", "peaks_beyond_max_peak",...
        "filter_echo", "filter_tx"};
end

for i = 1:length(cell_of_names)
    struct_coll_names.cell_of_names{i} = i;
end

end