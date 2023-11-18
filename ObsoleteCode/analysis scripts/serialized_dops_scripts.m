base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\08-Feb-2023\";
all_res_folders = dir(base_res_path);
bat_config = GetBatConfig;

figure;
for ith_folder = 3:length(all_res_folders)
    if ~all_res_folders(ith_folder).isdir
        continue
    end
    cur_folder = base_res_path+all_res_folders(ith_folder).name+"\";
    cur_files = dir(cur_folder);
    for ith_file = 3:length(cur_files)
        cur_audio_name = cur_files(ith_file).name;
        if contains(cur_audio_name, "peaks")
            res_cell_per_audio = load(cur_folder+cur_audio_name);
            res_cell_per_audio = res_cell_per_audio.res_cell_per_audio;
            two_peaks_lines = res_cell_per_audio(cellfun(@(x) x==2, res_cell_per_audio(:,6)), :);
            peak_freqs = [two_peaks_lines{:,5}].';
            tx_start_times = cellfun(@(x) x(1), two_peaks_lines(:,3));
            peak1_inds = cellfun(@(x,y) find(x == y(1)), two_peaks_lines(:,2), two_peaks_lines(:,5), "UniformOutput",false);
            peak2_inds = cellfun(@(x,y) find(x == y(2)), two_peaks_lines(:,2), two_peaks_lines(:,5), "UniformOutput",false);
            peak1_vals = cellfun(@(x,y) x(y), two_peaks_lines(:,1), peak1_inds, "UniformOutput",false);
            peak2_vals = cellfun(@(x,y) x(y), two_peaks_lines(:,1), peak2_inds, "UniformOutput",false);
       end
    end
end
figure; plot(peak_freqs(:,1)+80000+200*rand(length(peak_freqs(:,2))), peak_freqs(:,2)+80000+200*rand(length(peak_freqs(:,2))), "*b")
