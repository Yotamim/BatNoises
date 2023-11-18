function DetectionProb(obj,b)
fig_handle = get(obj, "Parent");
tag_table = get(fig_handle, "UserData");
tag_table.detection_problem = true;
set(fig_handle, "UserData", tag_table);
end

