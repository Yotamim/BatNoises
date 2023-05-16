function AddTagedData(button_handle, event)
tags_folder = "C:\Users\yotam\Desktop\ProjectsData\tags";
fig_handle = get(button_handle, "Parent");
tag_table = get(fig_handle, "UserData");
next_tagged_call_num = length(dir(fullfile(tags_folder, "*.mat")));
assert(~exist(fullfile(tags_folder, "tagged_call_"+num2str(next_tagged_call_num))))
save(fullfile(tags_folder, "tagged_call_"+num2str(next_tagged_call_num)),"tag_table")
end