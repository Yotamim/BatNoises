config = GetConfig();
tag_table = config.tagged_data_table;
methods_names = "";
is_rx_detected_table = array2table(zeros(size(methods_names)));
is_rx_detected_table = renamevars(is_rx_detected_table, is_rx_detected_table.Properties.VariableNames, methods_names);

for ith_tagged_row = randperm(height(tag_table))  
    disp(ith_tagged_row)
    row = tag_table(ith_tagged_row,:);
    
    relevant_band = config.bat_config.bat_pulse_freq+config.bat_config.bat_dynamic_range;
    audio_info = audioinfo(row.audio_path);
    fs = audio_info.SampleRate;
    raw_wav = audioread(row.audio_path);
    raw_wav = raw_wav-mean(raw_wav);

    [~, ~, filtered_audio, center_freq] = ProcessSingleAudio(raw_wav, relevant_band, fs, config);
    tagged_wav = filtered_audio(row.times(1)*fs:row.times(2)*fs);
    
    [tx_freq, smooth_fft] = GetTxFreq(tagged_wav, fs);

    [spec, freq_ax, time_ax] = stft(tagged_wav, fs,Window=hann(1024), FrequencyRange="onesided", OverlapLength=512);
    sum_of_spectogram = sum(abs(spec),2);
    [~,tx_from_spec_row_ind] = max(sum_of_spectogram);
    assert(abs(freq_ax_pb(tx_from_spec_ind)-tx_freq) < freq_ax_pb(2)-freq_ax_pb(1))
    
end

