function AddTagedData(button_handle, event)
tags_folder = "C:\Users\yotam\Desktop\ProjectsData\tags";
fig_handle = get(button_handle, "Parent");
tag_table = get(fig_handle, "UserData");
next_tagged_call_num = length(dir(fullfile(tags_folder, "*.mat")));
assert(~exist(fullfile(tags_folder, "tagged_call_"+num2str(next_tagged_call_num))))
save(fullfile(tags_folder, "tagged_call_"+num2str(next_tagged_call_num)),"tag_table")
disp(fullfile(tags_folder, "tagged_call_"+num2str(next_tagged_call_num)))

all_children = get(fig_handle, "Children");
for ith_child = 1:length(all_children)
    if contains(class(all_children(ith_child)), "UIControl") && contains(all_children(ith_child).String, "MoveToNextCall")
        set(all_children(ith_child), "Value", true)
    end
end
end