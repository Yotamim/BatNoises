function cont_inds_cell = GetNContinuesInds(times, bat_inds, n_window)


wind = zeros(n_window,1);
wind(1) = 1;
wind(n_window) = -1;
thresh = (n_window-1)*0.15;
inds_of_end_of_wavs = find(diff(times)<0 & diff(bat_inds) == 0);
inds_of_end_of_wavs = [inds_of_end_of_wavs; length(times)];
cur_start_wav = 1;

cont_inds_cell = cell(1,n_window);
for i = 1:length(inds_of_end_of_wavs)
    cur_end_wav = inds_of_end_of_wavs(i);
    cur_wavfile_times = times(cur_start_wav:cur_end_wav);
    conv_diff = conv(cur_wavfile_times, wind, "valid");
    if ~isempty(conv_diff)
        base_log_vec = [conv_diff<thresh; false(n_window-1,1)];
        for ith_ind_of_cont = 1:n_window
            cont_inds_cell{ith_ind_of_cont} = [cont_inds_cell{ith_ind_of_cont};circshift(base_log_vec,ith_ind_of_cont-1)];
        end
    else
        for ith_ind_of_cont = 1:n_window
            cont_inds_cell{ith_ind_of_cont} = [cont_inds_cell{ith_ind_of_cont};false(length(cur_wavfile_times),1)];
        end
    end
    cur_start_wav = cur_end_wav+1;

end
for i = 1:length(cont_inds_cell)
    cont_inds_cell{i} = logical(cont_inds_cell{i});
end

end

