function empty_tag_table = EmptyTagTable()
empty_tag_table = cell2table(cell(1,5));
empty_tag_table = renamevars(empty_tag_table, empty_tag_table.Properties.VariableNames,...
    ["tx_freq", "rx_freq", "tx_rx_end_times", "audio_path", "times"]);
end