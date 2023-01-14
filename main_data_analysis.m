close all; clear; clc
data_main_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\data";
all_data_folders = dir(data_main_path);

spec_config = GetSpecConfiguration;

for ith_folder = 3:length(all_data_folders)
    ith_folder_full_path = [all_data_folders(ith_folder).folder,'\', all_data_folders(ith_folder).name];
    all_audios_in_folder = dir(ith_folder_full_path);
    for jth_audio = 3:length(all_audios_in_folder)
        jth_audio_path = [ith_folder_full_path, '\', all_audios_in_folder(jth_audio).name];

        jth_info = audioinfo(jth_audio_path);
        fs = jth_info.SampleRate;
        jth_wav = audioread(jth_audio_path);
        
        filtered_audio = bandpass(jth_wav, [60*1e3,90*1e3], fs);
        % can be centered and downsampled here
        [raw_spec,~,~,~] = PlotSpectogram(jth_wav, fs, spec_config.fft_length, ...
            spec_config.freq_range, spec_config.overlap, spec_config.window, false);
        
        [wav_spec, time_vec, freqs, fig_handle] = PlotSpectogram(filtered_audio, fs, spec_config.fft_length, ...
            spec_config.freq_range, spec_config.overlap, spec_config.window, false);
        
        cur_activity_vec = GetTxRxWindows(wav_spec, filtered_audio, time_vec, freqs, fs, raw_spec, jth_wav);
        tx_rx_inds_array = ActivityVec2IndsArray(cur_activity_vec, time_vec);
        for ith_tx_rx = 1:size(tx_rx_inds_array,1)
            if tx_rx_inds_array(ith_tx_rx, 2)-tx_rx_inds_array(ith_tx_rx, 1) >= 4
                
            end

        end
    end
end


