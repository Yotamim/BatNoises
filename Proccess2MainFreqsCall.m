function [start_time_tx,start_time_echo,freq_xcor,freq_lags, filt_echo, filt_tx, tx_freq_from_filtered_tx_fft, ...
     filtered_echo, filtered_tx, smooth_tx_fft_var, smooth_echo_fft_var] = ...
    Proccess2MainFreqsCall(peak_freqs, single_trx_pb_filt, fs, center_freq, config)

half_freq_range = abs(diff(peak_freqs)*0.4);
tx_freq_range = [peak_freqs(1)-config.bat_config.chirp_range, peak_freqs(1)+half_freq_range]+center_freq;
echo_freq_range = [peak_freqs(2)-half_freq_range+center_freq, peak_freqs(2)+half_freq_range+center_freq];

[start_time_tx,start_time_echo,freq_xcor,freq_lags, filt_echo, filt_tx, tx_freq_from_filtered_tx_fft,... 
    filtered_echo, filtered_tx, smooth_tx_fft_var, smooth_echo_fft_var] = ...
    FilterEchoAndCorr(single_trx_pb_filt, fs, tx_freq_range, echo_freq_range, false, false, config);





end