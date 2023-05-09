clear;close all
base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\08-Apr-2023\";
all_res_folders = dir(base_res_path);
config = GetConfig;

cn = ColumnNames2Inds();
colnames = fieldnames(cn);
wanted_inds = [3,4,6,7,8,9,10,13,14,17,18,19,20,21,22,23,24,25];

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
        if ~contains(cur_files(ith_file).name, "var")
            continue
        end
        if contains(cur_files(ith_file).name, "with_var_with")
            continue
        end
        cur_audio_mat = cur_files(ith_file).name;
        res_cell_per_audio = load(cur_folder+cur_audio_mat);
        res_cell_per_audio = res_cell_per_audio.res_cell_per_audio;

        cur_res_table = cell2table(res_cell_per_audio(:,wanted_inds), "VariableNames", colnames(wanted_inds));
        cur_res_table.durations = diff(cur_res_table.times.').';
        cur_res_table.rx_freq = cur_res_table.echo_doppler+cur_res_table.tx_freq_from_filtered_tx_fft;
        bat_num_col = ones(height(cur_res_table),1)*bat_num;
        cur_res_table.bat_num = bat_num_col;
        res_table = [res_table;cur_res_table];
    end
end
res_table = renamevars(res_table,"tx_freq_from_filtered_fft", "raw_tx");
save(base_res_path+"agg_res_table", "res_table")

