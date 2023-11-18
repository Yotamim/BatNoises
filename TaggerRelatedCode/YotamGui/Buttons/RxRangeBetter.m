function RxRangeBetter(obj, b)
fig_handle = get(obj, "Parent");
tag_table = get(fig_handle, "UserData");
tag_table.rx_range_better = true;
set(fig_handle, "UserData", tag_table);
end