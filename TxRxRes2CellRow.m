function cell_row = TxRxRes2CellRow(dop_vals, dops_freqs, times, audio_path)
cell_row = cell(1,4);
cell_row{1} = dop_vals;
cell_row{2} = dops_freqs;
cell_row{3} = times;
cell_row{4} = audio_path;

end