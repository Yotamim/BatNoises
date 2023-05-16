function ClearAx(ax_h, complete_clear)

if nargin == 1
    complete_clear = false;
end

if complete_clear
    if contains(ax_h.Title.String, "fft")
        lines = get(ax_h,"Children");
        deletion_lines = false(size(lines));
        for ith_line = 1:length(lines)
            if length((lines(ith_line).XData))>100
                continue
            else
                deletion_lines(ith_line) = true;
            end
        end
        for ith_line = 1:length(lines); if deletion_lines(ith_line); delete(lines(ith_line)); end; end
    end

    if contains(ax_h.Title.String, "spectogram")
        lines = get(ax_h,"Children");
        deletion_lines = false(size(lines));
        for ith_line = 1:length(lines)
            if lines(ith_line).Type == "line"
                deletion_lines(ith_line) = true;
            end
        end
        for ith_line = 1:length(lines); if deletion_lines(ith_line); delete(lines(ith_line)); end; end
    end
    if contains(ax_h.Title.String, "delay")
        lines = get(ax_h,"Children");
        deletion_lines = false(size(lines));
        for ith_line = 1:length(lines)
            if lines(ith_line).Type == "line"
                deletion_lines(ith_line) = true;
            end
        end
        for ith_line = 1:length(lines); if deletion_lines(ith_line); delete(lines(ith_line)); end; end
    end
else
    if contains(ax_h.Title.String, "fft")
        lines = get(ax_h,"Children");
        deletion_lines = false(size(lines));
        for ith_line = 1:length(lines)
            if length((lines(ith_line).XData))>100 || lines(ith_line).LineStyle == "*"
                continue
            else
                deletion_lines(ith_line) = true;
            end
        end
        for ith_line = 1:length(lines); if deletion_lines(ith_line); delete(lines(ith_line)); end; end
    end

    if contains(ax_h.Title.String, "spectogram")
        lines = get(ax_h,"Children");
        deletion_lines = false(size(lines));
        for ith_line = 1:length(lines)
            if lines(ith_line).Type == "line"
                if lines(ith_line).LineStyle ~= "--"
                    deletion_lines(ith_line) = true;
                end
            end
        end
        for ith_line = 1:length(lines); if deletion_lines(ith_line); delete(lines(ith_line)); end; end
    end

    if contains(ax_h.Title.String, "delay")
        lines = get(ax_h,"Children");
        deletion_lines = false(size(lines));
        for ith_line = 1:length(lines)
            if lines(ith_line).Type == "line"
                deletion_lines(ith_line) = true;
            end
        end
        for ith_line = 1:length(lines); if deletion_lines(ith_line); delete(lines(ith_line)); end; end
    end
end

end