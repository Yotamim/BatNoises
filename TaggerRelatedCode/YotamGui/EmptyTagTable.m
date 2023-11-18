function empty_tag_table = EmptyTagTable()
var_names = ["tx_freq", "rx_freq", "rx_max_freq","delay_points", "limits_detection_problem",...
    "no_echo", "alg_tx", "alg_rx", "time_to_tag","audio_path", "times"];
empty_tag_table = cell2table(cell(1,length(var_names)));
empty_tag_table = renamevars(empty_tag_table, empty_tag_table.Properties.VariableNames,...
    var_names);
end