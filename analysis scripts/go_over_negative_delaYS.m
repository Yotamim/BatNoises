clear
base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\03-Mar-2023\";


load(base_res_path + "aggregate_results.mat")
cn = ColumnNames2Inds();
config = GetConfig;
neg_del_inds = find(all_delays<0);

for ggg_neg_delay = 1:length(neg_del_inds)
    ith_neg_delay = neg_del_inds(randi(length(neg_del_inds)));
%     ith_neg_delay = neg_del_inds(ggg_neg_delay);
    cur_wav_res_path = map_wav_ind_to_path{all_wav_ind(ith_neg_delay)};
    cur_tx = all_tx_time(ith_neg_delay);
    load(cur_wav_res_path)
    if contains(cur_wav_res_path, "5")
        wav_string = replace(cur_wav_res_path, "_with_gps_5.mat", ".wav");
    else
        wav_string = replace(cur_wav_res_path, "_with_gps.mat", ".wav");
    end
    wav_string = replace(wav_string, "\MatlabProjects\BatNoises\results\03-Mar-2023\", "\ProjectsData\data\");

    raw_wav = audioread(wav_string);
    relevant_band = config.bat_config.bat_pulse_freq+config.bat_config.bat_dynamic_range;
    audio_info = audioinfo(wav_string);
    fs = audio_info.SampleRate;
    [baseband_audio, bb_fs, filtered_audio, center_freq] = ProcessSingleAudio(raw_wav, relevant_band, fs, config);

    tx_times = vertcat(res_cell_per_audio{:,cn.times});
    cur_row_ind = find(tx_times(:,1) == cur_tx );
    cur_row = res_cell_per_audio(cur_row_ind,:);
    cur_audio = filtered_audio(fs*cur_row{cn.times}(1):fs*cur_row{cn.times}(2));
    
    ProcessSingleTxRx(baseband_audio(bb_fs*cur_row{cn.times}(1):bb_fs*cur_row{cn.times}(2)), ...
        cur_audio, bb_fs, fs, center_freq, cur_row{cn.times}, wav_string, config)
    close all
    
end

