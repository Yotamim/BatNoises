function cell_row = TxRxRes2CellRow(dop_vals, dops_freqs, times, audio_path, ...
    peak_freqs, num_peaks, fs, delay, dop, echo_doppler, filter_echo, filter_tx, ...
    tx_freq_from_raw_fft, tx_freq_from_filtered_tx_fft, filtered_tx, filtered_echo,...
    smooth_tx_fft_var, smooth_echo_fft_var)
i = 1;
cell_row{i} = dop_vals; i = i+1;
cell_row{i} = dops_freqs; i = i+1;
cell_row{i} = times; i = i+1;
cell_row{i} = audio_path; i = i+1;
cell_row{i} = peak_freqs; i = i+1;
cell_row{i} = num_peaks; i = i+1;
cell_row{i} = fs; i = i+1;
cell_row{i} = delay; i = i+1;
cell_row{i} = dop; i = i+1;
cell_row{i} = echo_doppler; i = i+1;
cell_row{i} = filter_echo; i = i+1;
cell_row{i} = filter_tx; i = i+1;
cell_row{i} = tx_freq_from_raw_fft; i = i+1;
cell_row{i} = tx_freq_from_filtered_tx_fft; i = i+1;
cell_row{i} = filtered_tx; i = i+1;
cell_row{i} = filtered_echo; i = i+1;
end