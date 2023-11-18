function new_row = ParseTaggedRow(tag_struct, empty_tag_table)
tag_row = tag_struct.tag_table;
cur_vars = tag_row.Properties.VariableNames;
var_names = empty_tag_table.Properties.VariableNames;
empty_tag_table.time_to_tag = -1;

for ith_var = 1:length(var_names)
    if any(contains(cur_vars, var_names{ith_var}))
        empty_tag_table.(var_names{ith_var}) = tag_row.(var_names{ith_var});
        if iscell(empty_tag_table.(var_names{ith_var}))
            if var_names{ith_var} == "delay_points"
                empty_tag_table.(var_names{ith_var}) = [-1,-1];
            else
                empty_tag_table.(var_names{ith_var}) = -1;
            end

        end
    end
end

new_row = empty_tag_table;
new_row.audio_path = string(new_row.audio_path);
if ~isempty(tag_struct.alg_tx)
    new_row.alg_tx = tag_struct.alg_tx+80000;
    new_row.alg_rx = tag_struct.alg_rx+80000;
else
    new_row.alg_tx = -1;
    new_row.alg_rx = -1;
end
if isfield(tag_struct, "tag_start")
    new_row.time_to_tag = tag_struct.tag_end - tag_struct.tag_start;
end
end