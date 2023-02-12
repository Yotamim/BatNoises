function res_cell_per_audio = MainSingleAudioFile(audio_path, config, PLOT_FLAG)

audio_info = audioinfo(audio_path);
fs = audio_info.SampleRate;

raw_wav = audioread(audio_path);
[raw_spec, spec_freq_vec, spec_time_vec] = stft(raw_wav, fs, FFTLength=config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
    OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);
% PlotSpectogram(raw_wav,raw_spec,fs,spec_freq_vec,spec_time_vec)

relevant_band = config.bat_config.bat_pulse_freq+config.bat_config.bat_dynamic_range;

filtered_audio = bandpass(raw_wav, relevant_band, fs);
[filter_spec, spec_freq_vec, spec_time_vec] = stft(filtered_audio, fs, FFTLength=4*config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
    OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);
% PlotSpectogram(filtered_audio,filter_spec,fs,spec_freq_vec,spec_time_vec)

cur_activity_vec = GetTxRxWindows(filter_spec);
tx_rx_inds_array = ActivityVec2IndsArray(cur_activity_vec, spec_time_vec);
tx_rx_times_array = spec_time_vec(tx_rx_inds_array);

[baseband_audio, bb_fs] = ProcessSingleAudio(raw_wav, relevant_band, fs, config);
[bb_spec, spec_freq_vec_bb, spec_time_vec_bb] = stft(baseband_audio, bb_fs, FFTLength=config.spec_config.fft_length,FrequencyRange="centered",...
    OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);
% PlotSpectogram(real(baseband_audio),bb_spec,bb_fs,spec_freq_vec_bb,spec_time_vec_bb)


if PLOT_FLAG == 0
    %     PlotSpectogram(filtered_audio,filter_spec,fs,spec_freq_vec,spec_time_vec)
    %     hold on; plot(tx_rx_times_array(:), zeros(size(tx_rx_times_array(:))), '*')
    %     plot((0:length(baseband_audio)-1)*1/bb_fs, real(baseband_audio)+0.1)
    %     plot(tx_rx_times_array(:), 0.1+zeros(size(tx_rx_times_array(:))), '*')
    [filter_spec, spec_freq_vec, spec_time_vec] = stft(filtered_audio, fs, FFTLength=4*config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
        OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);
    PlotSpectogram(baseband_audio,filter_spec,bb_fs,spec_freq_vec,spec_time_vec)
    hold on; plot(tx_rx_times_array(:), zeros(size(tx_rx_times_array(:))), '*')

end

res_cell_per_audio = {};
for ith_tx_rx = 1:size(tx_rx_times_array ,1)
    if tx_rx_times_array(ith_tx_rx, 2)-tx_rx_times_array(ith_tx_rx, 1) >= config.other_config.min_duration_from_histogram
        [current_dop_vals, cur_dops_freqs, cur_fft] = FindDopplerFromSpec(baseband_audio(tx_rx_times_array(ith_tx_rx, 1)*bb_fs:tx_rx_times_array(ith_tx_rx, 2)*bb_fs), bb_fs);
        [~,peak_inds] = findpeaks(current_dop_vals/max(current_dop_vals),"MinPeakHeight", 0.075 , Annotate="extents");
        peak_freqs = cur_dops_freqs(peak_inds);
        num_peaks = length(peak_inds);

        cur_row = TxRxRes2CellRow(cur_fft, current_dop_vals, cur_dops_freqs, tx_rx_times_array(ith_tx_rx,:), audio_path, peak_freqs, num_peaks);
        res_cell_per_audio = vertcat(res_cell_per_audio, cur_row);
    end
end

end