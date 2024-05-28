tags_of_perching_hunting = readtable("C:\Users\yotam\Desktop\MatlabProjects\BatNoises\MarkInsectsCatching\perching_hunting.xlsx");
spec_config.window = hann(256);
spec_config.overlap = 0;
spec_config.freq_range = "onesided";
spec_config.fft_length = 2048;

for ith_wav_file = 1:height(tags_of_perching_hunting)
    cur_wav_file = tags_of_perching_hunting.wav_full_path{ith_wav_file};
    wav = audioread(cur_wav_file);
    wav_info = audioinfo(cur_wav_file);

    filtered_audio = bandpass(wav, [6e4, 9e4], wav_info.SampleRate);
    [filter_spec, spec_freq_vec, spec_time_vec] = stft(filtered_audio, wav_info.SampleRate, FFTLength=4*spec_config.fft_length,FrequencyRange=spec_config.freq_range,...
    OverlapLength=spec_config.overlap, Window=spec_config.window);

    PlotSpectogram([], filter_spec, wav_info.SampleRate, spec_freq_vec, spec_time_vec, 1)

end