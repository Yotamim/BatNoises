clear;close all
base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\08-Apr-2023\";
all_res_folders = dir(base_res_path);
config = GetConfig;

cn = ColumnNames2Inds();
colnames = fieldnames(cn);
wanted_inds = [3,4,6,7,8,9,10,14,17,18,19];

relevant_band = config.bat_config.bat_pulse_freq+config.bat_config.bat_dynamic_range;
bat_pulse_freq = config.bat_config.bat_pulse_freq;
center_freq = mean(relevant_band);

res_table = [];

for ith_folder = 3:length(all_res_folders)
    if ~all_res_folders(ith_folder).isdir
        continue
    end
    cur_folder = base_res_path+all_res_folders(ith_folder).name+"\";
    cur_files = dir(cur_folder);
    bat_num = BatNumFromFolderName(all_res_folders(ith_folder).name);
    for ith_file = 3:length(cur_files)
        if ~contains(cur_files(ith_file).name, "gps")
            continue
        end
        cur_audio_mat = cur_files(ith_file).name;
        res_cell_per_audio = load(cur_folder+cur_audio_mat);
        res_cell_per_audio = res_cell_per_audio.res_cell_per_audio;
        res_cell_len = size(res_cell_per_audio,2);
        for i = 1:size(res_cell_per_audio,1)
            ith_row = res_cell_per_audio(i,:);
            if isnan(ith_row{ cn.filtered_tx })
                tx_var = NaN;
                rx_var = NaN;
                min_tx = NaN;
                max_tx = NaN;
                min_rx = NaN;
                max_rx = NaN;
            else
                fs = ith_row{ cn.fs };
                filt_tx = ith_row{ cn.filtered_tx };
                filt_rx = ith_row{ cn.filtered_echo };
                tx_var = GetSpecVarFromWave(filt_tx,fs, false);
                rx_var = GetSpecVarFromWave(filt_rx,fs, true);
                
                [min_tx, max_tx] = GetWidthFromWave(filt_tx,fs);
                [min_rx, max_rx] = GetWidthFromWave(filt_rx,fs);
            end
            res_cell_per_audio{i,res_cell_len+1} = tx_var;
            res_cell_per_audio{i,res_cell_len+2} = rx_var;
            res_cell_per_audio{i,res_cell_len+3} = min_tx;
            res_cell_per_audio{i,res_cell_len+4} = max_tx;
            res_cell_per_audio{i,res_cell_len+5} = min_rx;
            res_cell_per_audio{i,res_cell_len+6} = max_rx;
        end
%         save(cur_folder+cur_audio_mat(1:end-4)+"_with_var", "res_cell_per_audio")
    end
end


