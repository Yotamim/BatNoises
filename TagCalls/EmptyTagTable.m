function empty_tag_table = EmptyTagTable()
var_names = ["tx_freq", "rx_freq", "tx_rx_end_times","new_detection_lims", "detection_problem",...
    "no_echo", "weird", "rx_range_better", "audio_path", "times"];
empty_tag_table = cell2table(cell(1,length(var_names)));
empty_tag_table = renamevars(empty_tag_table, empty_tag_table.Properties.VariableNames,...
    var_names);
end