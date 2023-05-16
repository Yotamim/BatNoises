function DrawDetectedRx(all_ax, ind_detected_rx)

for ith_ax = 1:length(all_ax)
    if contains(all_ax(ith_ax).Title.String, "fft") && contains(all_ax(ith_ax).Title.String, "smooth fft")
        lines = get(all_ax(ith_ax),"Children");
        for ith_line = 1:length(lines)
            if length(lines(ith_line).XData)>100
                freqs = lines(ith_line).XData;
                call_fft = lines(ith_line).YData;
                smooth_fft = movmean(call_fft, 5);
            end
        end
    end
end

for ith_ax = 1:length(all_ax)
    if contains(all_ax(ith_ax).Title.String, "smooth fft")
        plot(freqs(ind_detected_rx), smooth_fft(ind_detected_rx), "om", Parent=all_ax(ith_ax))
        continue
    end
    if contains(all_ax(ith_ax).Title.String, "fft")
        plot(freqs(ind_detected_rx), call_fft(ind_detected_rx), "om", Parent=all_ax(ith_ax))
        continue
    end
    if contains(all_ax(ith_ax).Title.String, "spectogram")
                plot([all_ax(ith_ax).XLim], [freqs(ind_detected_rx),freqs(ind_detected_rx)]+80000, "k", Parent=all_ax(ith_ax));
    end
end

end