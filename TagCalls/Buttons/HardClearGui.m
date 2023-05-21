function HardClearGui(button_handle,event)

fig_handle = get(button_handle, "Parent");
complete_clear = true;
all_children = get(fig_handle, "Children");

is_ax = false(size(all_children));
for ith_child = 1:length(all_children); is_ax(ith_child) = contains(class(all_children(ith_child)), "Axes"); end
all_axes = all_children(is_ax);
for ith_ax = 1:length(all_axes)
    ClearAx(all_axes(ith_ax), complete_clear)
end

tag_table = get(fig_handle, "UserData");
path = tag_table.audio_path;
times = tag_table.times;
tag_table = EmptyTagTable();
tag_table.audio_path = path;
tag_table.times = times;
tag_table.rx_freq = 0;
tag_table.tx_rx_end_times = 0;
set(fig_handle, "UserData", tag_table);
end
