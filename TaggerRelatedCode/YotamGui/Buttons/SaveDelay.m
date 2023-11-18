function SaveDelay(button_handle, event)


fig_handle = get(button_handle, "Parent");
all_children = get(fig_handle, "Children");
is_ax = false(size(all_children));
for ith_child = 1:length(all_children); is_ax(ith_child) = contains(class(all_children(ith_child)), "Axes"); end
all_ax = all_children(is_ax);

is_delay_spec = false(size(all_ax));
for ith_ax = 1:length(all_ax); is_delay_spec(ith_ax) = (contains(all_ax(ith_ax).Title.String, "delay")); end
spec_ax = all_ax(is_delay_spec);

lines = get(spec_ax, "Children");

delay_vec = zeros(1,2);
k = 1;
for ith_line = 1:length(lines)
    if lines(ith_line).Type == "line"
        delay_vec(k) = lines(ith_line).XData(1);
        k = k+1;
    end
end
tag_table = get(fig_handle, "UserData");
tag_table.tx_rx_end_times = sort(delay_vec);
set(fig_handle, "UserData", tag_table);

end