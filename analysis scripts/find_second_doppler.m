clear;close all
base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\25-Feb-2023\";
all_res_folders = dir(base_res_path);
config = GetConfig;

cn = ColumnNames2Inds();
relevant_band = config.bat_config.bat_pulse_freq+config.bat_config.bat_dynamic_range;
bat_pulse_freq = config.bat_config.bat_pulse_freq;
center_freq = mean(relevant_band);

for ith_folder = 3:length(all_res_folders)
    if ~all_res_folders(ith_folder).isdir
        continue
    end
    cur_folder = base_res_path+all_res_folders(ith_folder).name+"\";
    cur_files = dir(cur_folder);
    for ith_file = 3:length(cur_files)
        cur_audio_mat = cur_files(ith_file).name;
        res_cell_per_audio = load(cur_folder+cur_audio_mat);
        res_cell_per_audio = res_cell_per_audio.res_cell_per_audio;

        audio_name = res_cell_per_audio{1,cn.audio_path};
        audio = audioread(audio_name);
        fs = audioinfo(audio_name).SampleRate;
        filtered_audio = bandpass(audio, relevant_band, fs);

        for ith_row = 1:length(res_cell_per_audio)
            cur_res_row = res_cell_per_audio(ith_row ,:);
            data = filtered_audio(fs*cur_res_row{cn.times}(1):fs*cur_res_row{cn.times}(2));
            if length(cur_res_row{ cn.peak_freqs }) == 2
                tx_freq_range = cur_res_row{ cn.filter_tx };
                echo_freq_range = cur_res_row{ cn.filter_echo };
                filtered_echo = bandpass(data, echo_freq_range, fs,"Steepness",0.99);
                filtered_tx = bandpass(data, tx_freq_range, fs, "Steepness",0.99);

                temp_plot_script
                a = 1;
            end
        end
    end
end


