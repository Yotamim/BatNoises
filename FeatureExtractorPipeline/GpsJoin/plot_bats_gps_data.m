clear;
base_res_path = "C:\Users\yotam\Desktop\ProjectsData\";
all_res_folders = dir(base_res_path);
all_wav_times = {};
all_bat_nums = [];
for ith_folder = 3:length(all_res_folders)
    if contains(all_res_folders(ith_folder).name, "bat")
        cur_folder = base_res_path+all_res_folders(ith_folder).name+"\";
        cur_files = dir(cur_folder);
        bat_num = BatNumFromFolderName(all_res_folders(ith_folder).name);
        for ith_file = 3:length(cur_files)
            if contains(cur_files(ith_file).name, ".wav")
                all_wav_times = [all_wav_times;AudioPathToDatetime(cur_files(ith_file).name)];
                all_bat_nums = [all_bat_nums;bat_num ];
            end
        end
    elseif contains(all_res_folders(ith_folder).name, "data")
        cur_folder = base_res_path+all_res_folders(ith_folder).name+"\";
        cur_files = dir(cur_folder);
        bat_num = BatNumFromFolderName(all_res_folders(ith_folder).name);
        for i = 3:length(cur_files)
            cur_wavs = dir(cur_folder+cur_files(i).name);
            for k = 3:length(cur_wavs)
                if contains(cur_wavs(k).name, ".wav")
                    all_wav_times = [all_wav_times;AudioPathToDatetime(cur_wavs(k).name)];
                    all_bat_nums = [all_bat_nums;bat_num];
                end
            end
        end
    end
end
gps_epoch = datetime("31-Dec--1 00:00:00");
plot_speed_and_loc_over_time_per_bat

base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\08-Apr-2023\";
load(base_res_path + "agg_res_table.mat")
res_table_2_peaks = res_table(res_table.num_peaks == 2,:);
res_table_1_peak = res_table(res_table.num_peaks == 1,:);




