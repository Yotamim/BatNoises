close all; clear; clc; warning off all

% data_main_path = "C:\Users\yotam\Desktop\ProjectsData\bat02";
% data_main_path = "C:\Users\yotam\Desktop\ProjectsData\data";
data_main_path = "C:\Users\yotam\Desktop\ProjectsData\bat04";
all_files_folds_list = dir(data_main_path);
all_wavs_paths_list = [];
for i = 3:length(all_files_folds_list)
    if all_files_folds_list(i).isdir
        cur_fold_files = dir(fullfile(all_files_folds_list(i).folder,all_files_folds_list(i).name, "*.wav"));
        all_wavs_paths_list = [all_wavs_paths_list;cur_fold_files];
    elseif contains(all_files_folds_list(i).name, ".wav")
        all_wavs_paths_list = [all_wavs_paths_list; all_files_folds_list(i)];
    end
end
all_wavs_paths_list_strings = replace(string({all_wavs_paths_list.folder}.')+string({all_wavs_paths_list.name}.'), "Audio", "\Audio");
all_wavs_paths_list_strings = replace(string({all_wavs_paths_list.folder}.')+string({all_wavs_paths_list.name}.'), "bat04", "bat04\");
config = GetConfig();
marks_of_insects = cell(length(all_wavs_paths_list_strings),2);

for ith_audio = 1:length(all_wavs_paths_list_strings)
    marks_of_insects{ith_audio, 1} = all_wavs_paths_list_strings(ith_audio);
    filter_spec = MarkInsects(all_wavs_paths_list_strings(ith_audio), config);
    filter_spec1 = pow2db(abs(filter_spec));
    
    saveas(gcf, "C:\Users\yotam\Desktop\MarkInstects\bat04\"+extractBefore(extractAfter(all_wavs_paths_list_strings(ith_audio),"bat04\"), ".wav")+".png")
    close
end
% 
% base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\08-Apr-2023\";
% load(base_res_path + "agg_res_table.mat")
% A = res_table(string(res_table.movement_type) == "water" & res_table.num_peaks == 2,:);
