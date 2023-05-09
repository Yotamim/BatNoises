function cur_row = ProcessSingleTxRx(single_trx_bb, single_trx_pb_filt, bb_fs, fs, center_freq, times, audio_path, config)

[current_dop_vals, cur_dops_freqs] = FindDopplerFromSpec(single_trx_bb, bb_fs);
[~,peak_inds] = findpeaks(current_dop_vals/max(current_dop_vals),"MinPeakHeight", config.peak_detectors_config.min_peak_height_initial_dop);
current_dop_vals_for_res = current_dop_vals;
peak_freqs = cur_dops_freqs(peak_inds);
peak_freqs_vals = current_dop_vals(peak_inds);
num_peaks = length(peak_inds);
while length(peak_freqs_vals) > 1 && peak_freqs_vals(1)<max(peak_freqs_vals)
    current_dop_vals(cur_dops_freqs <= peak_freqs(1)) = 0;
    [~,peak_inds] = findpeaks(current_dop_vals/max(current_dop_vals),"MinPeakHeight", config.peak_detectors_config.min_peak_height_initial_dop);

    peak_freqs = cur_dops_freqs(peak_inds);
    peak_freqs_vals = current_dop_vals(peak_inds);
    num_peaks = length(peak_inds);
end

cur_filtered_fft = fftshift(fft(single_trx_pb_filt));
cur_raw_smooth_fft = movmean(abs(cur_filtered_fft),5);
[~,tx_freq_from_raw_fft_ind] = max(cur_raw_smooth_fft);
n_points = length(cur_filtered_fft);
f_vec = linspace(-n_points/2, (n_points-1)/2, n_points).'*fs/n_points;
tx_freq_from_raw_fft = abs(f_vec(tx_freq_from_raw_fft_ind));

if length(peak_freqs) == 2
    [start_time_tx,start_time_echo,freq_xcor,freq_lags, filt_echo, filt_tx, tx_freq_from_filtered_tx_fft,...
        filtered_echo, filtered_tx, smooth_tx_fft_var, smooth_echo_fft_var] = ...
        Proccess2MainFreqsCall(peak_freqs, single_trx_pb_filt, fs, center_freq, config);

    delay = start_time_echo-start_time_tx;
    [~, dop_ind] = max(freq_xcor);
    dop = freq_lags(dop_ind)*fs/length(single_trx_pb_filt);
    filter_echo = [filt_echo.StopbandFrequency1,filt_echo.StopbandFrequency2];
    filter_tx = [filt_tx.StopbandFrequency1,filt_tx.StopbandFrequency2];
    
    [~,max_freq_xcor_ind] = max(freq_xcor);
    echo_doppler = freq_lags(max_freq_xcor_ind)*fs/length(single_trx_pb_filt);
    
    
else
    delay = NaN;
    dop = NaN;
    echo_doppler = NaN;
    filter_echo = NaN;
    filter_tx = NaN;
    tx_freq_from_filtered_tx_fft = NaN;
    filtered_echo = NaN;
    filtered_tx = NaN;
    smooth_tx_fft_var = NaN;
    smooth_echo_fft_var = NaN;
end

cur_row = TxRxRes2CellRow(current_dop_vals_for_res, cur_dops_freqs, times, audio_path,...
    peak_freqs, num_peaks, fs, delay, dop, echo_doppler, filter_echo, filter_tx, tx_freq_from_raw_fft,...
    tx_freq_from_filtered_tx_fft, filtered_tx, filtered_echo, smooth_tx_fft_var, smooth_echo_fft_var);

end



