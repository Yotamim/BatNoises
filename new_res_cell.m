clear
base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\08-Apr-2023\";
load(base_res_path + "agg_res_table.mat")
config = GetConfig();
res_table_no_garbage = res_table(res_table.durations > 0.03, :);

for ith_row = 1:height(res_table_no_garbage)
    new_row = cell2table(cell(1,7));
    new_row = renamevars(new_row, new_row.Properties.VariableNames, ...
        ["call_fft","filter_spec","spec_freq_vec","spec_time_vec","bb_fs","times","audio_path"]);
    try
        cur_row = res_table_no_garbage(ith_row, :);
        cur_times = cur_row.times;
        audio_path = cur_row.audio_path;
        if ith_row>1 && cur_row.audio_path ==  res_table_no_garbage(ith_row-1, :).audio_path
            disp(cur_row.audio_path)
        else
            relevant_band = config.bat_config.bat_pulse_freq+config.bat_config.bat_dynamic_range;
            audio_info = audioinfo(audio_path);
            fs = audio_info.SampleRate;
            raw_wav = audioread(audio_path);
            raw_wav = raw_wav-mean(raw_wav);
            [baseband_audio, bb_fs, filtered_audio, center_freq] = ProcessSingleAudio(raw_wav, relevant_band, fs, config);
        end

        cur_baseband_audio = baseband_audio(bb_fs*cur_times(1):bb_fs*cur_times(2));
        fft_freqs = linspace(-bb_fs/2, bb_fs/2, length(cur_baseband_audio));
        [filter_spec, spec_freq_vec, spec_time_vec] = stft(filtered_audio(fs*cur_times(1):fs*(cur_times(2)+0.02)),...
            fs, FFTLength=4*config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
            OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);
        call_fft = fftshift(abs(fft(cur_baseband_audio)));

        new_row.call_fft = {call_fft(abs(fft_freqs)<5000)};
        new_row.filter_spec = {abs(filter_spec(spec_freq_vec-60000 >0 & spec_freq_vec-85000 <0, :))};
        new_row.spec_freq_res = {spec_freq_vec(2)-spec_freq_vec(1)};
        new_row.spec_time_res = {spec_time_vec(2)-spec_time_vec(1)};
        new_row.bb_fs = {bb_fs};
        new_row.times = {cur_times};
        new_row.audio_path = {audio_path};
    catch
        new_row.audio_path = audio_path;
        new_row.times = cur_times;
    end
    save_name = split(audio_path, "\");
    save_name = replace(save_name{end}, ".wav", "__"+num2str(cur_times(1))+"__"+num2str(cur_times(2)))+".mat";
    save_folder = "C:\Users\yotam\Desktop\ProjectsData\spec_and_ffts";
    save(fullfile(save_folder,save_name) ,"new_row")
end

