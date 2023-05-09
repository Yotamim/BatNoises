function res_cell_per_audio = MainSingleAudioFile(audio_path, config, PLOT_FLAG)

relevant_band = config.bat_config.bat_pulse_freq+config.bat_config.bat_dynamic_range;

audio_info = audioinfo(audio_path);
fs = audio_info.SampleRate;
raw_wav = audioread(audio_path);
raw_wav = raw_wav-mean(raw_wav);

[baseband_audio, bb_fs, filtered_audio, center_freq] = ProcessSingleAudio(raw_wav, relevant_band, fs, config);

tx_rx_times_array = ActivityDetectorMain(filtered_audio, fs, config);
if tx_rx_times_array(1,1) == 0
    tx_rx_times_array(1,1) = 1/fs;
end

specs_plot_script

res_cell_per_audio = {};
tx_rx_time_array_with_spltis = [];
for ith_tx_rx = 1:size(tx_rx_times_array ,1)
    s_time = tx_rx_times_array(ith_tx_rx, 1);
    e_time = tx_rx_times_array(ith_tx_rx, 2);
    if ~AssertActivityIsLongEnough(s_time, e_time, config.other_config.min_duration_from_histogram)
        continue
    end
    if AssertActivityIsShortEnough(s_time, e_time, config.other_config.max_duration_from_histogram)
        tx_rx_time_array_with_spltis = [tx_rx_time_array_with_spltis; [s_time, e_time]];
    else
        new_tx_rx_rows = SplitUnitedTxRx(filtered_audio(fs*s_time:fs*e_time), fs, s_time, e_time, config);
        assert(size(new_tx_rx_rows, 2) == 2)
        tx_rx_time_array_with_spltis = [tx_rx_time_array_with_spltis; new_tx_rx_rows];
    end
end

for ith_tx_rx = 1:size(tx_rx_time_array_with_spltis,1)
    
    s_time = tx_rx_time_array_with_spltis(ith_tx_rx, 1);
    e_time = tx_rx_time_array_with_spltis(ith_tx_rx, 2);
    cur_row = ProcessSingleTxRx( ...
        baseband_audio(s_time*bb_fs:e_time*bb_fs), ...
        filtered_audio(s_time*fs:e_time*fs), ...
        bb_fs, fs, center_freq, [s_time, e_time], audio_path, config);
    res_cell_per_audio = vertcat(res_cell_per_audio, cur_row);
    
end



end