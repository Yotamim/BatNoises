function TaggerFigs(audio_path, audio_path_table, config)

audio_info = audioinfo(audio_path);
fs = audio_info.SampleRate;
raw_wav = audioread(audio_path);
raw_wav = raw_wav-mean(raw_wav);
relevant_band = config.bat_config.bat_pulse_freq+config.bat_config.bat_dynamic_range;

[baseband_audio, bb_fs, filtered_audio, center_freq] = ProcessSingleAudio(raw_wav, relevant_band, fs, config);

% [filter_spec, spec_freq_vec, spec_time_vec] = stft(filtered_audio, fs, FFTLength=4*config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
%         OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);

for ith_call = 1:5
    k = randi(height(audio_path_table));
    cur_row = audio_path_table(k ,:);
    cur_times = cur_row.times; 
    cur_baseband_audio = baseband_audio(bb_fs*cur_times(1):bb_fs*cur_times(2));
    freqs = linspace(-bb_fs/2, bb_fs/2, length(cur_baseband_audio));
    [filter_spec, spec_freq_vec, spec_time_vec] = stft(filtered_audio(fs*cur_times(1):fs*(cur_times(2)+0.02)),...
        fs, FFTLength=4*config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
        OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);


    figure;
    subplot(2,2,1)
    plot(freqs , fftshift(abs(fft(cur_baseband_audio))), "ButtonDownFcn", @ClickOnFFT)
    title("fft")
    xlim([-5000, 5000])
    hold on

    subplot(2,2,3)
    plot(freqs , movmean(fftshift(abs(fft(cur_baseband_audio))),5), "ButtonDownFcn", @ClickOnFFT)
    title("smooth fft")
    xlim([-5000, 5000])
    hold on

    subplot(2,2,2)
    clims = [max(pow2db(abs(filter_spec(:))))-30, max(pow2db(abs(filter_spec(:))))];
    img = imagesc(spec_time_vec,spec_freq_vec, pow2db(abs(filter_spec)), clims);
    set(img, "ButtonDownFcn", @ClickOnSpec)
    colormap jet
    set(gca, "YDir", "normal")
    
    xlabel("time");
    ylabel("freq");
    title("spectogram")
    ylim([7.5e4,8.3e4])
    hold on

    subplot(2,2,4)
    clims = [max(pow2db(abs(filter_spec(:))))-30, max(pow2db(abs(filter_spec(:))))];
    imagesc(spec_time_vec,spec_freq_vec, pow2db(abs(filter_spec)), clims)
    colormap jet
    set(gca, "YDir", "normal")
    xlabel("time");
    ylabel("freq");
    title("tag delay")
    ylim([7.5e4,8.3e4])
    hold on
    move_fig_to_laptop_screen_home

end

end

