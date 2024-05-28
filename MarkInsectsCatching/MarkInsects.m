function filter_spec = MarkInsects(audio_path, config)
audio_info = audioinfo(audio_path);
fs = audio_info.SampleRate;
raw_wav = audioread(audio_path);
raw_wav = raw_wav-mean(raw_wav);
relevant_band = config.bat_config.bat_pulse_freq+config.bat_config.bat_dynamic_range;
[~, ~, filtered_audio, ~] = ProcessSingleAudio(raw_wav, relevant_band, fs, config);
[filter_spec, spec_freq_vec, spec_time_vec] = stft(filtered_audio,...
    fs, FFTLength=config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
    OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);

cut_ind = fix(length(spec_time_vec)/2);
figure;
subplot(2,1,1)
clims = [max(pow2db(abs(filter_spec(:))))-30, max(pow2db(abs(filter_spec(:))))];
img = imagesc(spec_time_vec(1:cut_ind),spec_freq_vec, pow2db(abs(filter_spec(:,1:cut_ind))), clims);
colormap jet
set(gca, "YDir", "normal")
xlabel("time");
ylabel("freq");
ylim([6e4,8.5e4])

subplot(2,1,2)
clims = [max(pow2db(abs(filter_spec(:))))-30, max(pow2db(abs(filter_spec(:))))];
img = imagesc(spec_time_vec(cut_ind+1:end),spec_freq_vec, pow2db(abs(filter_spec(:,(cut_ind+1:end)))), clims);
colormap jet
set(gca, "YDir", "normal")
xlabel("time");
ylabel("freq");
ylim([6e4,8.5e4])
sgtitle(replace(audio_path, "_", " "))
move_fig_to_laptop_screen_home
end