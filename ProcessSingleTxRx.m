function cur_row = ProcessSingleTxRx(single_trx_bb, single_trx_pb_filt, bb_fs, fs, center_freq, times, audio_path, config)


[current_dop_vals, cur_dops_freqs, ~] = FindDopplerFromSpec(single_trx_bb, bb_fs);
[~,peak_inds] = findpeaks(current_dop_vals/max(current_dop_vals),"MinPeakHeight", config.peak_detectors_config.min_peak_height_initial_dop);

peak_freqs = cur_dops_freqs(peak_inds);
num_peaks = length(peak_inds);

cur_filtered_fft = fftshift(fft(single_trx_pb_filt));
cur_raw_smooth_fft = movmean(abs(cur_filtered_fft),5);
[~,tx_freq_from_raw_fft_ind] = max(cur_raw_smooth_fft);
n_points = length(cur_filtered_fft);
f_vec = linspace(-n_points/2, (n_points-1)/2, n_points).'*fs/n_points;
tx_freq_from_raw_fft = abs(f_vec(tx_freq_from_raw_fft_ind));

if length(peak_freqs) == 2
    half_freq_range = abs(diff(peak_freqs)*0.4);
    tx_freq_range = [peak_freqs(1)-config.bat_config.chirp_range, peak_freqs(1)+half_freq_range]+center_freq;
    echo_freq_range = [peak_freqs(2)-half_freq_range+center_freq, peak_freqs(2)+half_freq_range+center_freq];
    
    [start_time_tx,start_time_echo,freq_xcor,freq_lags, filt_echo, filt_tx, tx_freq_from_filtered_tx_fft] = ...
        FilterEchoAndCorr(single_trx_pb_filt, fs, tx_freq_range, echo_freq_range, false, false, config);

    delay = start_time_echo-start_time_tx;
    [~, dop_ind] = max(freq_xcor);
    dop = freq_lags(dop_ind)*fs/length(single_trx_pb_filt);
    filter_echo = [filt_echo.StopbandFrequency1,filt_echo.StopbandFrequency2];
    filter_tx = [filt_tx.StopbandFrequency1,filt_tx.StopbandFrequency2];
    
    [~,dop_inds] = findpeaks(freq_xcor/max(freq_xcor), ...
        "MinPeakHeight", config.peak_detectors_config.min_peak_height_secondary_dop, ...
        "MinPeakDistance",config.peak_detectors_config.min_peaks_freq_dist_secondary_dop*length(single_trx_pb_filt)/fs, ...
        "MinPeakProminence", config.peak_detectors_config.min_peaks_prominance_secondary_dop);

    [~,first_echo_ind] = max(freq_xcor(dop_inds));
    peaks_beyond_max_peak = freq_lags(dop_inds(first_echo_ind:end))*fs/length(single_trx_pb_filt);
else
    delay = NaN;
    dop = NaN;
    freq_xcor = NaN;
    freq_lags = NaN;
    peaks_beyond_max_peak = NaN;
    filter_echo = NaN;
    filter_tx = NaN;
    tx_freq_from_filtered_tx_fft = NaN;
end

cur_row = TxRxRes2CellRow(cur_filtered_fft, current_dop_vals, cur_dops_freqs, times, ...
    audio_path, peak_freqs, num_peaks, bb_fs, delay, dop, freq_xcor, freq_lags, peaks_beyond_max_peak, ...
    filter_echo, filter_tx, tx_freq_from_raw_fft, tx_freq_from_filtered_tx_fft);

end



