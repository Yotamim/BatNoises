close all; clear; clc; warning off all
addpath(genpath(pwd))
data_main_path = "C:\Users\yotam\Desktop\ProjectsData\data";
git_info = importdata('C:\Users\yotam\Desktop\MatlabProjects\BatNoises\.git\logs\HEAD');
base_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\";
git_info = git_info{2};
git_info = split(git_info, ' ');
commith_sha = git_info{2};
branch_name = git_info{1};
all_data_folders = dir(data_main_path);

spec_config = GetSpecConfiguration;
phys_config = GetPhysicalConfig;
bat_config = GetBatConfig;
config.spec_config = spec_config;
config.phys_config = phys_config;
config.bat_config = bat_config;
config.other_config.min_duration_from_histogram = 0.045; %sec
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
            SaveSingleAudioRes(git_info, res_cell_per_audio, base_path)
            toc;
        catch
            disp(jth_audio_path)
        end
            
        
    end
end

