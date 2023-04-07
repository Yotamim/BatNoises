function tx_rx_times_final = SplitUnitedTxRx(data,fs, in_wav_s_time, in_wav_e_time, config)


smooth_energy_vec = movmad(abs(data), ceil(config.other_config.max_duration_from_histogram*fs)/20);
tvec = (0:(length(smooth_energy_vec)-1))/fs;

low_energy_inds = find(smooth_energy_vec/max(smooth_energy_vec)<0.08);
inds_of_jump = find(diff(low_energy_inds)/fs>config.other_config.max_duration_from_histogram/60);


temp_activity_inds = size(length(inds_of_jump),2);
for i = 1:length(inds_of_jump)
    temp_activity_inds(i,1) = low_energy_inds(inds_of_jump(i));
    temp_activity_inds(i,2) = low_energy_inds(inds_of_jump(i)+1);
end
mid_silence_windows = [];
for i = 1:size(temp_activity_inds,1)-1
    mid_silence_windows = [mid_silence_windows;ceil((temp_activity_inds(i+1,1)+temp_activity_inds(i,2))/2)];
end

tx_rx_inds = zeros(size(temp_activity_inds));
tx_rx_inds(1,1) = 1;
tx_rx_inds(end,2) = length(data);
for i = 1:length(mid_silence_windows)
    tx_rx_inds(i,2) = mid_silence_windows(i);
    tx_rx_inds(i+1,1) = mid_silence_windows(i);
end
if 0
    try
        figure; ax1 = subplot(1,2,1);
        plot(tvec, smooth_energy_vec/max(smooth_energy_vec));hold on
        plot(tvec(low_energy_inds), smooth_energy_vec(low_energy_inds)/max(smooth_energy_vec), "ob")

        plot(tvec(temp_activity_inds(:,1)), smooth_energy_vec(temp_activity_inds(:,1))/max(smooth_energy_vec), "*k")
        plot(tvec(temp_activity_inds(:,2)), smooth_energy_vec(temp_activity_inds(:,2))/max(smooth_energy_vec), "*k")

        plot(tvec(tx_rx_inds(:,1)), smooth_energy_vec(tx_rx_inds(:,1))/max(smooth_energy_vec), "sm")
        plot(tvec(tx_rx_inds(:,2)), smooth_energy_vec(tx_rx_inds(:,2))/max(smooth_energy_vec), "sm")
        ax2 = subplot(1,2,2);
        [spec, f_axis_spec, t_axis_spec] = stft(data, fs, FFTLength=4*config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
            OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);
        imim = pow2db(abs(spec));
        climsss = [max(imim(:))-30, max(imim(:))];
        imagesc(t_axis_spec,f_axis_spec, imim ,climsss )
        colormap jet
        set(gca, "YDir", "normal")
        xlabel("time");
        ylabel("freq");
        spec_lim = get(gca,"XLim");
        title("spectogram")
        linkaxes([ax1,ax2], "x")
    catch
        ax2 = subplot(1,2,2);
        [spec, f_axis_spec, t_axis_spec] = stft(data, fs, FFTLength=4*config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
            OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);
        imim = pow2db(abs(spec));
        climsss = [max(imim(:))-30, max(imim(:))];
        imagesc(t_axis_spec,f_axis_spec, imim ,climsss )
        colormap jet
        set(gca, "YDir", "normal")
        xlabel("time");
        ylabel("freq");
        spec_lim = get(gca,"XLim");
        title("no splits")
        linkaxes([ax1,ax2], "x")
    end
end
tx_rx_times = (tx_rx_inds-1)/fs;
long_wnough_new_times = false(size(tx_rx_times,1),1);
further_split_new_times = false(size(tx_rx_times,1),1);
for i = 1:length(long_wnough_new_times)
    long_wnough_new_times(i) = AssertActivityIsLongEnough(tx_rx_times(i,1), tx_rx_times(i,2),...
        config.other_config.min_duration_from_histogram);
    further_split_new_times(i) = ~AssertActivityIsShortEnough(tx_rx_times(i,1), tx_rx_times(i,2),...
        config.other_config.max_duration_from_histogram);
end
tx_rx_times_final = tx_rx_times(long_wnough_new_times,:);
if any(further_split_new_times) && length(further_split_new_times)>1
    for i = 1:length(further_split_new_times)
        if further_split_new_times(i)
            cur_in_wav_s_time = tx_rx_times(i,1);
            cur_in_wav_e_time = tx_rx_times(i,2);
            cur_data = data(cur_in_wav_s_time<=tvec & tvec<=cur_in_wav_e_time);
            mo_splits = SplitUnitedTxRx(cur_data,fs, cur_in_wav_s_time, cur_in_wav_e_time, config);
            tx_rx_times_final = [tx_rx_times_final;mo_splits];
        end
    end
end
tx_rx_times_final = tx_rx_times_final+in_wav_s_time;
[~, inds_unq] = unique(tx_rx_times_final(:,1));
tx_rx_times_final = tx_rx_times_final(inds_unq,:);

end
