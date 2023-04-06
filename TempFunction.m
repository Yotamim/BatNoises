function TempFunction(audio_path, config, PLOT_FLAG)
relevant_band = config.bat_config.bat_pulse_freq+config.bat_config.bat_dynamic_range;

audio_info = audioinfo(audio_path);
fs = audio_info.SampleRate;
raw_wav = audioread(audio_path);

raw_wav = raw_wav-mean(raw_wav);
[baseband_audio, bb_fs, filtered_audio, center_freq] = ProcessSingleAudio(raw_wav, relevant_band, fs, config);

tx_rx_times_array = ActivityDetectorMain(filtered_audio, fs, config);
if size(tx_rx_times_array,1)<3
    return
end
[filter_spec, spec_freq_vec, spec_time_vec] = stft(filtered_audio, fs, FFTLength=4*config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
    OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);
PlotSpectogram(baseband_audio,filter_spec,bb_fs,spec_freq_vec,spec_time_vec, 1)
hold on; plot(tx_rx_times_array(:,1), zeros(size(tx_rx_times_array,1),1), '*b')
plot(tx_rx_times_array(:,2), zeros(size(tx_rx_times_array,1),1), '*k')
end