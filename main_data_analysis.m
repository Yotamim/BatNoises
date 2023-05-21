close all; clear; clc; warning off all
addpath(genpath(pwd))
% data_main_path = "C:\Users\yotam\Desktop\ProjectsData\bat02";
data_main_path = "C:\Users\yotam\Desktop\ProjectsData\data";
% data_main_path = "C:\Users\yotam\Desktop\ProjectsData\bat04";
git_info = importdata('C:\Users\yotam\Desktop\MatlabProjects\BatNoises\.git\logs\HEAD');
base_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\";
git_info = git_info{2};
git_info = split(git_info, ' ');
commith_sha = git_info{2};
branch_name = git_info{1};
all_data_folders = dir(data_main_path);
if contains(all_data_folders(3).name, "wav")
    single_fold_indicator = true;
else
    single_fold_indicator = false;
end
config = GetConfig;

failed_audio_list = {};
if ~single_fold_indicator
    for ith_folder = 3:length(all_data_folders)
        disp(ith_folder)
        ith_folder_full_path = [all_data_folders(ith_folder).folder,'\', all_data_folders(ith_folder).name];
        all_audios_in_folder = dir(ith_folder_full_path);
        for jth_audio = 3:length(all_audios_in_folder)
            try
                tic;
                jth_audio_path = [ith_folder_full_path, '\', all_audios_in_folder(jth_audio).name];
                if ~contains(jth_audio_path, ".wav")
                    continue
                end
                res_cell_per_audio = MainSingleAudioFile(jth_audio_path, config, true);
%                 SaveSingleAudioRes(git_info, res_cell_per_audio, base_path)
                toc;
            catch
                disp(jth_audio_path)
                failed_audio_list{end+1} = jth_audio_path;
            end
        end
    end
else
    all_audios_in_folder = all_data_folders;
    for jth_audio = 1:length(all_audios_in_folder)
        try
            jth_audio = randi(length(all_audios_in_folder));
            tic;
            jth_audio_path = data_main_path+'\'+ all_audios_in_folder(jth_audio).name;
            if ~contains(jth_audio_path, ".wav")
                continue
            end
            res_cell_per_audio = MainSingleAudioFile(jth_audio_path, config, true);
%             TempFunction(jth_audio_path, config, true)
            SaveSingleAudioRes(git_info, res_cell_per_audio, base_path)
            toc;
        catch
            disp(jth_audio_path)
            failed_audio_list{end+1} = jth_audio_path;
        end

    end
end