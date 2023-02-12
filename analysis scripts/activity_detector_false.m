clear;
base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\08-Feb-2023\";
all_res_folders = dir(base_res_path);
config.bat_config = GetBatConfig;
config.spec_config = GetSpecConfiguration();

relevant_band = config.bat_config.bat_pulse_freq+config.bat_config.bat_dynamic_range;
% figure;
k = 5;
normal_peak_dur = [];
abnormal_peak_dur = [];
for ith_folder = 3:length(all_res_folders)
    if ~all_res_folders(ith_folder).isdir
        continue
    end
    cur_folder = base_res_path+all_res_folders(ith_folder).name+"\";
    cur_files = dir(cur_folder);
    for ith_file = 3:length(cur_files)
        cur_audio_name = cur_files(ith_file).name;
        if contains(cur_audio_name, "peaks_peaks")
            res_cell_per_audio = load(cur_folder+cur_audio_name);
            res_cell_per_audio = res_cell_per_audio.res_cell_per_audio;
            abnormal_peak_num = res_cell_per_audio(cellfun(@(x) x>2, res_cell_per_audio(:,6)), :);
            tx_start_times = cellfun(@(x) x(1), abnormal_peak_num(:,3));
            tx_end_times = cellfun(@(x) x(2), abnormal_peak_num(:,3));
            audio_path = res_cell_per_audio{1,4};
            audio_info = audioinfo(audio_path);
            fs = audio_info.SampleRate;
            raw_wav = audioread(audio_path);
            filtered_audio = bandpass(raw_wav, relevant_band, fs);
            [filter_spec, spec_freq_vec, spec_time_vec] = stft(filtered_audio, fs, FFTLength=4*config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
                        OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);
            
            normal_peak_num = res_cell_per_audio(cellfun(@(x) x<=k, res_cell_per_audio(:,6)), :);
            temp_peak_dur = vertcat(normal_peak_num{:,3});
            normal_peak_dur = [normal_peak_dur;temp_peak_dur(:,2)-temp_peak_dur(:,1)];
            
            abnormal_peak_num1 = res_cell_per_audio(cellfun(@(x) x>k, res_cell_per_audio(:,6)), :);
            temp1_peak_dur = vertcat(abnormal_peak_num1{:,3});
            abnormal_peak_dur = [abnormal_peak_dur;temp1_peak_dur(:,2)-temp1_peak_dur(:,1)];
%             PlotSpectogram(filtered_audio,filter_spec,fs,spec_freq_vec,spec_time_vec)
%             ttt = vertcat(res_cell_per_audio{:,3});
%             hold on; plot(ttt(:), zeros(size(ttt(:))), 'k*')
%             for i = 1:length(abnormal_peak_num)
%                set(gca, "XLim", [tx_start_times(i), tx_end_times(i)]) 
%             end
       end
    end
end

a = 1
figure; histogram(normal_peak_dur,100); hold on;
histogram(abnormal_peak_dur,100);





