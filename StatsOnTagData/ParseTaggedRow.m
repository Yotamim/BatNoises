function new_row = ParseTaggedRow(tag_row, empty_tag_table)

cur_vars = tag_row.Properties.VariableNames;
var_names = empty_tag_table.Properties.VariableNames;

for ith_var = 1:length(var_names)
    if any(contains(cur_vars, var_names{ith_var}))
        empty_tag_table.(var_names{ith_var}) = tag_row.(var_names{ith_var});
        if iscell(empty_tag_table.(var_names{ith_var}))
            if var_names{ith_var} == "tx_rx_end_times"
                empty_tag_table.(var_names{ith_var}) = [-1,-1];
            else 
                empty_tag_table.(var_names{ith_var}) = -1;
            end
        end
    else
        empty_tag_table.(var_names{ith_var}) = -1;
    end
end
new_row = empty_tag_table;
end