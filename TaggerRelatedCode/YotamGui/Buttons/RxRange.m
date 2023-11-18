function RxRange(button_handle, event)

fig_handle = get(button_handle, "Parent");
all_children = get(fig_handle, "Children");
is_ax = false(size(all_children));
for ith_child = 1:length(all_children); is_ax(ith_child) = contains(class(all_children(ith_child)), "Axes"); end
all_ax = all_children(is_ax);

is_spec = false(size(all_ax));
for ith_ax = 1:length(all_ax); is_spec(ith_ax) = (contains(all_ax(ith_ax).Title.String, "other")); end
spec_ax = all_ax(is_spec);

lines = get(spec_ax, "Children");

for ith_line = 1:length(lines)
    if lines(ith_line).Type == "line" && lines(ith_line).LineStyle ~= "--"
        rx_range = lines(ith_line).YData(1);
        set(lines(ith_line), "LineStyle","--")
    end
end

rx_range = [];
for ith_line = 1:length(lines)
    if lines(ith_line).Type == "line" && lines(ith_line).LineStyle == "--"
        rx_range = [rx_range, lines(ith_line).YData(1)];
    end
end


tag_table = get(fig_handle, "UserData");
tag_table.rx_frange = rx_range;
set(fig_handle, "UserData", tag_table);

for ith_ax = 1:length(all_ax)
    ClearAx(all_ax(ith_ax))
end

end