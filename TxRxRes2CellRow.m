function cell_row = TxRxRes2CellRow(filtered_fft, dop_vals, dops_freqs, times, audio_path, ...
    peak_freqs, num_peaks, bb_fs, delay, dop, freq_xcor,freq_lags, peaks_beyond_max_peak, filter_echo, filter_tx, ...
    tx_freq_from_filtered_fft, tx_freq_from_filtered_tx_fft)

cell_row{1} = filtered_fft;
cell_row{2} = dop_vals;
cell_row{3} = dops_freqs;
cell_row{4} = times;
cell_row{5} = audio_path;
cell_row{6} = peak_freqs;
cell_row{7} = num_peaks;
cell_row{8} = bb_fs;
cell_row{9} = delay;
cell_row{10} = dop;
cell_row{11} = freq_xcor;
cell_row{12} = freq_lags;
cell_row{13} = peaks_beyond_max_peak;
cell_row{14} = filter_echo;
cell_row{15} = filter_tx;
cell_row{16} = tx_freq_from_filtered_fft;
cell_row{17} = tx_freq_from_filtered_tx_fft;
end