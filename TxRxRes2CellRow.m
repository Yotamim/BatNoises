function cell_row = TxRxRes2CellRow(fft_data, dop_vals, dops_freqs, times, audio_path, peak_freqs, num_peaks)
cell_row = cell(1,5);
cell_row{1} = fft_data;
cell_row{2} = dop_vals;
cell_row{3} = dops_freqs;
cell_row{4} = times;
cell_row{5} = audio_path;
cell_row{6} = peak_freqs;
cell_row{7} = num_peaks;
end