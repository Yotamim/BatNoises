function PlotPipeCheckForAudio(audio_path, audio_path_table, config)

audio_info = audioinfo(audio_path);
fs = audio_info.SampleRate;
raw_wav = audioread(audio_path);
raw_wav = raw_wav-mean(raw_wav);
relevant_band = config.bat_config.bat_pulse_freq+config.bat_config.bat_dynamic_range;

[baseband_audio, bb_fs, filtered_audio, center_freq] = ProcessSingleAudio(raw_wav, relevant_band, fs, config);

[filter_spec, spec_freq_vec, spec_time_vec] = stft(filtered_audio, fs, FFTLength=4*config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
        OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);

fig1 = figure;
clims = [max(pow2db(abs(filter_spec(:))))-30, max(pow2db(abs(filter_spec(:))))];
img = imagesc(spec_time_vec,spec_freq_vec, pow2db(abs(filter_spec)), clims);
% set(img, "UserData", audio_path_table)
% set(img,"ButtonDownFcn", @ClickOnACall)
colormap jet
fig1.Children.YDir = "normal";
xlabel("time");
ylabel("freq");
title("spectogram")


yylims = [7.5e4,8.5e4];
hold on

for ith_row = 1:height(audio_path_table)
    rr = audio_path_table(ith_row,:);
    if rr.num_peaks == 2
        line_type = "-o";
    else
        line_type = "--";
    end
    plot([rr.times(1),rr.times(1)],yylims, "g"+line_type ,LineWidth=2.5)
    plot([rr.times(2),rr.times(2)],yylims, "m"+line_type,LineWidth=2.5)
    plot(rr.times, [rr.raw_tx, rr.raw_tx], "k--",LineWidth=2)
    if ~isnan(rr.tx_freq_from_filtered_tx_fft)
        plot(rr.times, [rr.tx_freq_from_filtered_tx_fft, rr.tx_freq_from_filtered_tx_fft], "k-o",LineWidth=2)
        plot(rr.times, [rr.rx_freq, rr.rx_freq], "r-o",LineWidth=2)
    end
    
end
xlim(ones(1,2)*[randi(floor(audio_info.Duration))]+[0,0.25])

ylim(yylims)
move_fig_to_laptop_screen_home
end