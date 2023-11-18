function ClickOnOther(obj, event)
ax_handle = get(obj, "Parent");

fig_handle = get(ax_handle, "Parent");
all_children = get(fig_handle, "Children");
point = event.IntersectionPoint;
is_ax = false(size(all_children));
for ith_child = 1:length(all_children); is_ax(ith_child) = contains(class(all_children(ith_child)), "Axes"); end
all_axes = all_children(is_ax);


[~,p_ind] = min(abs(obj.YData - point(2)));
y_to_plot = obj.YData(p_ind);


for ith_ax = 1:length(all_axes)
    if contains(all_axes(ith_ax).Title.String, "fft")
        wanted_line = false(size(all_axes(ith_ax).Children));
        for ith_line = 1:length(all_axes(ith_ax).Children)
            wanted_line(ith_line) = all_axes(ith_ax).Children(ith_line).Marker == ".";
        end
        [~,cp_ind] = min(abs(all_axes(ith_ax).Children(wanted_line).XData - y_to_plot+80000));

        plot(all_axes(ith_ax).Children(wanted_line).XData(cp_ind), all_axes(ith_ax).Children(wanted_line).YData(cp_ind), 'om', Parent=all_axes(ith_ax))
    elseif contains(all_axes(ith_ax).Title.String, "other")
        freq = y_to_plot;
        xlims = get(all_axes(ith_ax), "XLim");
        plot(xlims, [freq,freq], 'k', LineWidth=1, Parent=all_axes(ith_ax))
    end
end

if length(get(ax_handle, "Children")) == 4
    ax_to_clean = false(size(all_axes));
    for ith_ax = 1:length(all_axes); ax_to_clean(ith_ax) = contains(all_axes(ith_ax).Title.String, "fft") || contains(all_axes(ith_ax).Title.String, "other"); end
    axes_to_clean = all_axes(ax_to_clean);
    for ith_ax = 1:length(axes_to_clean)
        ClearAx(axes_to_clean(ith_ax))
    end
end

end

