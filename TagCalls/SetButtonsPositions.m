function SetButtonsPositions(fig_handle, first_button_pos)
next_button_pos = 20;
all_children = get(fig_handle, "Children");
pos = first_button_pos;
for ith_child = 1:length(all_children)
    if contains(class(all_children(ith_child)), "UIControl") 
        set(all_children(ith_child), "Position", pos)
        pos(2) = pos(2)+next_button_pos;
    end
end
