function WorkOnRawWav(wav_data, fs, config, filter_audio, inds1, inds2)

cut_wav_data = wav_data(inds1:inds2);

relevant_band = config.bat_config.bat_pulse_freq+config.bat_config.bat_dynamic_range;

filtered_audio = bandpass(cut_wav_data, relevant_band , fs);
ProcessSingleTxRx(hilbert(cut_wav_data), fs, config)
ProcessSingleTxRx(hilbert(filter_audio(inds1:inds2)), fs, config)

ProcessSingleTxRx(filter_audio(), fs, config)

figure; plot(filter_audio(inds1:inds2))


end