function SingleWavTagging(audio_path, audio_path_table, config)

audio_info = audioinfo(audio_path);
fs = audio_info.SampleRate;
raw_wav = audioread(audio_path);
raw_wav = raw_wav-mean(raw_wav);
relevant_band = config.bat_config.bat_pulse_freq+config.bat_config.bat_dynamic_range;

[baseband_audio, bb_fs, filtered_audio, center_freq] = ProcessSingleAudio(raw_wav, relevant_band, fs, config);


move_to_next_wav = false;

while ~move_to_next_wav
    move_to_next_call = false;
    close
    k = randi(height(audio_path_table));
    cur_row = audio_path_table(k ,:);
    cur_times = cur_row.times;
    cur_baseband_audio = baseband_audio(bb_fs*cur_times(1):bb_fs*cur_times(2));
    freqs = linspace(-bb_fs/2, bb_fs/2, length(cur_baseband_audio));
    [filter_spec, spec_freq_vec, spec_time_vec] = stft(filtered_audio(fs*cur_times(1):fs*(cur_times(2)+0.02)),...
        fs, FFTLength=4*config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
        OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);
    call_fft = fftshift(abs(fft(cur_baseband_audio)));
    movmean_fft = movmean(call_fft,5);
    figure;
    tag_table = EmptyTagTable();
    tag_table.audio_path = audio_path;
    tag_table.times = cur_times;
    if cur_row.num_peaks == 2
        detected_tx = cur_row.tx_freq_from_filtered_tx_fft-80000;
        [~, min_ind_tx] = min(abs(detected_tx-freqs));
        detected_rx = cur_row.rx_freq-80000;
        [~, min_ind_rx] = min(abs(detected_rx-freqs));
    else
        min_ind_tx = [];
        min_ind_rx = [];
    end

    set(gcf, "UserData", tag_table)
    subplot(2,2,1)
    clims = [max(pow2db(abs(filter_spec(:))))-30, max(pow2db(abs(filter_spec(:))))];
    img = imagesc(spec_time_vec,spec_freq_vec, pow2db(abs(filter_spec)), clims);
    set(img, "ButtonDownFcn", @ClickOnOther)
    colormap jet
    set(gca, "YDir", "normal")
    xlabel("time");
    ylabel("freq");
    title("other")
    ylim([7.5e4,8.3e4])
    hold on

    subplot(2,2,3)
    plot(freqs , movmean_fft, ".-", "ButtonDownFcn", @ClickOnFFT)
    title("smooth fft")
    xlim([-5000, 5000])
    hold on
    if ~isempty(min_ind_tx); plot(freqs(min_ind_tx), movmean_fft(min_ind_tx), "om"); end
    
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
    if ~isempty(min_ind_tx); plot([0,max(spec_time_vec)], [detected_tx,detected_tx]+80000, "k"); end
    
    subplot(2,2,4)
    clims = [max(pow2db(abs(filter_spec(:))))-30, max(pow2db(abs(filter_spec(:))))];
    img1 = imagesc(spec_time_vec,spec_freq_vec, pow2db(abs(filter_spec)), clims);
    set(img1, "ButtonDownFcn", @ClickOnDelaySpec)
    colormap jet
    set(gca, "YDir", "normal")
    xlabel("time");
    ylabel("freq");
    title("tag delay")
    ylim([6e4,10e4])
    hold on
        
    uicontrol("Style","pushbutton","String", "HardReset", "Callback", @HardClearGui); 
    uicontrol("Style","pushbutton","String", "tx_freq", "Callback", @SaveTxTag, "UserData",{true, min_ind_rx}); 
    uicontrol("Style","pushbutton","String", "rx_freq", "Callback", @SaveRxTag); 
    uicontrol("Style","pushbutton","String", "delay", "Callback", @SaveDelay); 
    uicontrol("Style","pushbutton","String", "remark_detection", "Callback", @ReMarkDetection); 
    uicontrol("Style","pushbutton","String", "tx_range", "Callback", @TxRange); 
    uicontrol("Style","pushbutton","String", "rx_range", "Callback", @RxRange); 
    uicontrol("Style","pushbutton","String", "SaveTag", "Callback", @AddTagedData); 
    uicontrol("Style","pushbutton","String", "ShowTags", "Callback", @ShowTags); 
    uicontrol("Style","radiobutton","String", "DetectionProb", "Callback", @DetectionProb); 
    uicontrol("Style","radiobutton","String", "RxRange", "Callback", @RxRangeBetter); 
    uicontrol("Style","radiobutton","String", "NoEcho", "Callback", @NoEcho); 
    uicontrol("Style","radiobutton","String", "Weird", "Callback", @Weird); 
    next_call_h = uicontrol("Style","radiobutton","String", "MoveToNextCall"); 
    next_wav_h = uicontrol("Style","radiobutton","String", "MoveToNextWav"); 
    first_button_pos = [1780         450         100          20];
    first_button_pos = [1880         650         100          20];
    first_button_pos = [1430         350         100          20];

    SetButtonsPositions(gcf,first_button_pos)
    move_fig_to_laptop_screen_home
    while ~move_to_next_call && ~move_to_next_wav 
        pause(0.5)
        move_to_next_call = get(next_call_h, "Value");
        move_to_next_wav = get(next_wav_h, "Value");
    end
end

end



