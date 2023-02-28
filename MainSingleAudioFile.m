function res_cell_per_audio = MainSingleAudioFile(audio_path, config, PLOT_FLAG)

relevant_band = config.bat_config.bat_pulse_freq+config.bat_config.bat_dynamic_range;

audio_info = audioinfo(audio_path);
fs = audio_info.SampleRate;
raw_wav = audioread(audio_path);

[baseband_audio, bb_fs, filtered_audio, center_freq] = ProcessSingleAudio(raw_wav, relevant_band, fs, config);

tx_rx_times_array = ActivityDetectorMain(filtered_audio, fs, config);

specs_plot_script

res_cell_per_audio = {};
for ith_tx_rx = 1:size(tx_rx_times_array ,1)
    s_time = tx_rx_times_array(ith_tx_rx, 1);
    e_time = tx_rx_times_array(ith_tx_rx, 2);
    if AssertActivityIsLongEnough(s_time, e_time, config.other_config.min_duration_from_histogram)
        cur_row = ProcessSingleTxRx( ...
            baseband_audio(s_time*bb_fs:e_time*bb_fs), ...
            filtered_audio(s_time*fs:e_time*fs), ...
            bb_fs, fs, center_freq, [s_time, e_time], audio_path, config);
        res_cell_per_audio = vertcat(res_cell_per_audio, cur_row);
    end
end

end