function tx_rx_times_array  = ActivityDetectorMain(filtered_audio, fs, config)

[filter_spec, ~, spec_time_vec] = stft(filtered_audio, fs, FFTLength=4*config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
    OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);

cur_activity_vec = GetBinaryActivityVec(filter_spec, config.plot_config.activity_detector_plots);
tx_rx_inds_array = ActivityVec2IndsArray(cur_activity_vec, spec_time_vec);
tx_rx_times_array = spec_time_vec(tx_rx_inds_array);

end