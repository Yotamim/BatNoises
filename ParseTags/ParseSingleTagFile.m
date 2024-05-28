function table_row = ParseSingleTagFile(ud_struct)

if isempty(ud_struct.alg_tx); ud_struct.alg_tx = -1; end
if isempty(ud_struct.alg_rx); ud_struct.alg_rx = -1; end
ud_struct.tag_table.audio_path = string(ud_struct.tag_table.audio_path);
add_table = table(ud_struct.alg_tx, ud_struct.alg_rx, -1, 'VariableNames',["alg_tx", "alg_rx", "tagger_time"]);
if isfield(ud_struct, "tag_start")
    add_table.tagger_time = ud_struct.tag_end-ud_struct.tag_start;
end

if iscell(ud_struct.tag_table.tx_freq)
   ud_struct.tag_table.tx_freq = -1;
end
if iscell(ud_struct.tag_table.rx_freq)
   ud_struct.tag_table.rx_freq = -1;
end
if iscell(ud_struct.tag_table.rx_max_freq)
   ud_struct.tag_table.rx_max_freq = -1;
end
if iscell(ud_struct.tag_table.delay_points)
   ud_struct.tag_table.delay_points = [-1, -1];
end

table_row = [ud_struct.tag_table,add_table];


return