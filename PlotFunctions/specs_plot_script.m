if config.plot_config.plot_raw_spec_and_wav
    [raw_spec, raw_spec_freq_vec, raw_spec_time_vec] = stft(raw_wav, fs, FFTLength=config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
        OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);
    PlotSpectogram(raw_wav,raw_spec,fs,raw_spec_freq_vec,raw_spec_time_vec)
end

if config.plot_config.plot_bb_spec_and_raw_wav
    [bb_spec, spec_freq_vec_bb, spec_time_vec_bb] = stft(baseband_audio, bb_fs, FFTLength=config.spec_config.fft_length,FrequencyRange="centered",...
    OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);
    PlotSpectogram(raw_wav,bb_spec,fs,spec_freq_vec_bb,spec_time_vec_bb)
end

if config.plot_config.plot_filtered_spec_bb_audio_and_detection
    [filter_spec, spec_freq_vec, spec_time_vec] = stft(filtered_audio, fs, FFTLength=4*config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
        OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);
    PlotSpectogram(baseband_audio,filter_spec,bb_fs,spec_freq_vec,spec_time_vec)
    hold on; plot(tx_rx_times_array(:), zeros(size(tx_rx_times_array(:))), '*')
end
