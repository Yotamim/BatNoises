clear;close all
base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\08-Apr-2023\";
all_res_folders = dir(base_res_path);
cn = ColumnNames2Inds();
config = GetConfig;

gps_data_5 = LoadGpsData("5");

for ith_folder = 3:length(all_res_folders)
    tic
    if ~all_res_folders(ith_folder).isdir
        continue
    end
    cur_folder = base_res_path+all_res_folders(ith_folder).name+"\";
    if contains(cur_folder,"bat")
        temp = char(cur_folder);
        bat_str_num = temp(end-1);
        gps_to_join = LoadGpsData(bat_str_num);
    else
        bat_str_num = "5";
        gps_to_join = gps_data_5;
    end
    cur_files = dir(cur_folder);
    
    for ith_file = 3:length(cur_files)
        if contains(cur_files(ith_file).name, "gps")
           continue
        end
          
        if ~contains(cur_files(ith_file).name, "Audio") & ~contains(cur_files(ith_file).name, "U_U")
            continue
        end
        cur_audio_mat = cur_files(ith_file).name;
        res_cell_per_audio = load(cur_folder+cur_audio_mat);
        res_cell_per_audio = res_cell_per_audio.res_cell_per_audio;
        gps_epoch = datetime("31-Dec--1 00:00:00");
        audio_date = AudioPathToDatetime(res_cell_per_audio{1, cn.audio_path });
        start_time_of_audio = etime(datevec(audio_date), datevec(gps_epoch))/3600/24;
        res_len = size(res_cell_per_audio,2);
        for ith_row = 1:length(res_cell_per_audio)
            cur_res_row = res_cell_per_audio(ith_row ,:);
            tx_time = cur_res_row{cn.times}(1);
            [closest_gps_time,speed,ind] = JoinGpsData2TxTime(start_time_of_audio, cur_res_row{ cn.times }(1), gps_to_join);
            res_cell_per_audio{ith_row,res_len+1} = speed;
            res_cell_per_audio{ith_row,res_len+2} = closest_gps_time;
            res_cell_per_audio{ith_row,res_len+3} = (closest_gps_time - start_time_of_audio-tx_time/3600/24)*24*3600;

        end
        save(cur_folder+cur_audio_mat(1:end-4)+"_with_gps_"+bat_str_num,"res_cell_per_audio")
    end   
    toc
end

% PlotAudioSpec(cur_res_row{cn.audio_path}, config)
% move_fig_to_laptop_screen_home
% tx_times = vertcat(res_cell_per_audio{:,cn.times});
% figure;plot(gps_to_sec(:,1), zeros(size(gps_to_sec(:,1))), "o"); hold on;
% plot(tx_times(:,1), zeros(size(tx_times(:,1)))+0.1, "*"); 
% plot(tx_time,0.1, "sk")
% ylim([0,0.5])

% (closest_gps_time - start_time_of_audio)*24*3600-tx_time
% gps_to_sec = (gps_times-start_time_of_audio)*24*3600;