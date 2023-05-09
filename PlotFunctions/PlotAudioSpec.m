function PlotAudioSpec(audio_path, config)

raw_wav = audioread(audio_path);
relevant_band = [config.bat_config.bat_pulse_freq-config.bat_config.chirp_range, config.bat_config.bat_pulse_freq+5000];
audio_info = audioinfo(audio_path);
fs = audio_info.SampleRate;

[baseband_audio, bb_fs, filtered_audio, center_freq] = ProcessSingleAudio(raw_wav, relevant_band, fs, config);
[filter_spec, spec_freq_vec, spec_time_vec] = stft(filtered_audio, fs, FFTLength=4*config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
    OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);
PlotSpectogram(baseband_audio,filter_spec,bb_fs,spec_freq_vec,spec_time_vec, 1)


end