function ClickOnDelaySpec(image_handle, event)

state = image_handle.UserData;

ax_handle = get(image_handle, "Parent");
fig_handle = get(ax_handle, "Parent");
all_children = get(fig_handle, "Children");
point = event.IntersectionPoint;
is_ax = false(size(all_children));
for ith_child = 1:length(all_children); is_ax(ith_child) = contains(class(all_children(ith_child)), "Axes"); end
all_axes = all_children(is_ax);


for ith_ax = 1:length(all_axes); if contains(all_axes(ith_ax).Title.String, "delay"); break; end; end

if isempty(state) 
    plot(point(1), point(2), "k*", Parent=all_axes(ith_ax), LineWidth=2)
    state = 1;
elseif state == 1
    plot(point(1), point(2), "k*", Parent=all_axes(ith_ax), LineWidth=2)
    state = 2;
elseif state == 2
    ClearAx(all_axes(ith_ax))
    plot(point(1), point(2), "k*", Parent=all_axes(ith_ax), LineWidth=2)
    state = 1;
end
set(image_handle, "UserData", state)
end



