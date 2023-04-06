clear;close all
base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\03-Mar-2023\";
all_res_folders = dir(base_res_path);
cn = ColumnNames2Inds();
config = GetConfig;

gps_data = LoadGpsData();
for ith_folder = 3:length(all_res_folders)
    tic
    if ~all_res_folders(ith_folder).isdir
        continue
    end
    cur_folder = base_res_path+all_res_folders(ith_folder).name+"\";
    cur_files = dir(cur_folder);
    for ith_file = 3:length(cur_files)
        if ~contains(cur_files(ith_file).name, "Audio") || contains(cur_files(ith_file).name, "gps")
            continue
        end
        cur_audio_mat = cur_files(ith_file).name;
        res_cell_per_audio = load(cur_folder+cur_audio_mat);
        res_cell_per_audio = res_cell_per_audio.res_cell_per_audio;
        gps_epoch = datetime("31-Dec--1 00:00:00");
        audio_date = AudioPathToDatetime(res_cell_per_audio{1, cn.audio_path });
        start_time_of_audio = etime(datevec(audio_date), datevec(gps_epoch))/3600/24;
        for ith_row = 1:length(res_cell_per_audio)
            cur_res_row = res_cell_per_audio(ith_row ,:);
            [closest_gps_time,speed,ind] = JoinGpsData2TxTime(start_time_of_audio, cur_res_row{ cn.times }(1), gps_data);
            res_cell_per_audio{ith_row,18} = speed;
            res_cell_per_audio{ith_row,19} = closest_gps_time;
            res_cell_per_audio{ith_row,20} = (closest_gps_time - start_time_of_audio+tx_time/3600/24)*24*3600;
;
        end
        save(cur_folder+cur_audio_mat(1:end-4)+"_with_gps_5","res_cell_per_audio")
    end   
    toc
end


