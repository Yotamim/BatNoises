function NoEcho(obj,b)
fig_handle = get(obj, "Parent");
tag_table = get(fig_handle, "UserData");
tag_table.no_echo = true;
set(fig_handle, "UserData", tag_table);
end