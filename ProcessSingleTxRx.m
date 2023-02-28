function cur_row = ProcessSingleTxRx(single_trx_bb, single_trx_pb_filt, bb_fs, fs, center_freq, times, audio_path, config)


[current_dop_vals, cur_dops_freqs, cur_fft] = FindDopplerFromSpec(single_trx_bb, bb_fs);
[~,peak_inds] = findpeaks(current_dop_vals/max(current_dop_vals),"MinPeakHeight", config.peak_detectors_config.min_peak_height_initial_dop);

peak_freqs = cur_dops_freqs(peak_inds);
num_peaks = length(peak_inds);

if length(peak_freqs) == 2
    half_freq_range = abs(diff(peak_freqs)*0.4);
    tx_freq_range = [peak_freqs(1)-half_freq_range, peak_freqs(1)+half_freq_range]+center_freq;
    echo_freq_range = [peak_freqs(2)-half_freq_range, peak_freqs(2)+half_freq_range]+center_freq;
    

    [time_xcor,time_lags,freq_xcor,freq_lags, filt_echo, filt_tx]= FilterEchoAndCorr(single_trx_pb_filt, fs, ...
        tx_freq_range, echo_freq_range, true, false);
    [~, delay_ind] = max(time_xcor);
    delay = time_lags(delay_ind)/fs;

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
end

cur_row = TxRxRes2CellRow(cur_fft, current_dop_vals, cur_dops_freqs, times, ...
    audio_path, peak_freqs, num_peaks, bb_fs, delay, dop, freq_xcor, freq_lags, peaks_beyond_max_peak, ...
    filter_echo, filter_tx);

end



