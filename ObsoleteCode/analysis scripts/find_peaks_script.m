clear;
base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\08-Feb-2023\";
all_res_folders = dir(base_res_path);
% figure;
for ith_folder = 3:length(all_res_folders)
    if ~all_res_folders(ith_folder).isdir
        continue
    end
    cur_folder = base_res_path+all_res_folders(ith_folder).name+"\";
    cur_files = dir(cur_folder);
    for ith_file = 3:length(cur_files)
        cur_audio_name = cur_files(ith_file).name;
        res_cell_per_audio = load(cur_folder+cur_audio_name);
        res_cell_per_audio = res_cell_per_audio.res_cell_per_audio;
        for ith_cell_line = 1:length(res_cell_per_audio)
            cell_line = res_cell_per_audio(ith_cell_line,:);
            if ~isempty(cell_line{1})
                %             plot(cell_line{2}, cell_line{1}/max(cell_line{1})); hold on
                [peaks,peak_inds] = findpeaks(cell_line{2}/max(cell_line{2}),"MinPeakHeight", 0.075 , Annotate="extents");
                res_cell_per_audio{ith_cell_line,6} = cell_line{3}(peak_inds);
                res_cell_per_audio{ith_cell_line,7} = length(peak_inds);
                %             plot(res_cell_per_audio{ith_cell_line,5}, peaks, "*")
                %             hold off
            end
        end
        save(cur_folder+cur_audio_name(1:end-4)+"_peaks" ,"res_cell_per_audio")
    end
end
