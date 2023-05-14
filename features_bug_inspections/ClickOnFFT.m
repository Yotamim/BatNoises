function ClickOnFFT(obj, event)
ax_handle = get(obj, "Parent");

fig_handle = get(ax_handle, "Parent");
all_axes = get(fig_handle, "Children");
point = event.IntersectionPoint;

for ith_ax = 1:length(all_axes)
    ClearAx(all_axes(ith_ax))
end

[~,p_ind] = min(abs(obj.YData - point(2)));
x_to_plot = obj.XData(p_ind);

for ith_ax = 1:length(all_axes)
    if contains(all_axes(ith_ax).Title.String, "fft")
        [~,cp_ind] = min(abs(all_axes(ith_ax).Children.XData - x_to_plot));
        
        plot(all_axes(ith_ax).Children.XData(cp_ind), all_axes(ith_ax).Children.YData(cp_ind), 'om', Parent=all_axes(ith_ax))
    elseif contains(all_axes(ith_ax).Title.String, "spectogram")
        freq = x_to_plot+80000;
        xlims = get(all_axes(ith_ax), "XLim");

        plot(xlims, [freq,freq], 'k', LineWidth=1, Parent=all_axes(ith_ax))
    end
end

end

