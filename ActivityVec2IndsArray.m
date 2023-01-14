function inds_array = ActivityVec2IndsArray(activity_vec, t)
inds_array = [];
temp_activity_vec = [0,activity_vec,0];

is_start = true;
cur_window_inds = [0,0];

for i = 1:length(temp_activity_vec)
    if is_start && temp_activity_vec(i) == 1
        is_start = false;
        cur_window_inds(1) = i;
    end
    if ~is_start && temp_activity_vec(i) == 0
        is_start = true;
        cur_window_inds(2) = i-1;
    end
    if cur_window_inds(2) ~= 0
        inds_array = vertcat(inds_array,cur_window_inds);
        cur_window_inds = [0,0];
    end
end
inds_array = inds_array-1;
end