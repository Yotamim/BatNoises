clear;close all
base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\03-Mar-2023\";
all_res_folders = dir(base_res_path);
config = GetConfig;

cn = ColumnNames2Inds();
relevant_band = config.bat_config.bat_pulse_freq+config.bat_config.bat_dynamic_range;
bat_pulse_freq = config.bat_config.bat_pulse_freq;
center_freq = mean(relevant_band);

all_dops_mat = [];
all_tx_freq = [];
all_delays = [];
all_tx_time = [];
all_wav_ind = [];
all_gps_times = [];
all_speeds = [];
all_durations = [];
map_wav_ind_to_path = {};
wav_ind = 1;
for ith_folder = 3:length(all_res_folders)
    if ~all_res_folders(ith_folder).isdir
        continue
    end
    cur_folder = base_res_path+all_res_folders(ith_folder).name+"\";
    cur_files = dir(cur_folder);
    for ith_file = 3:length(cur_files)
        if ~contains(cur_files(ith_file).name, "gps")
            continue
        end
        tic
        cur_audio_mat = cur_files(ith_file).name;
        res_cell_per_audio = load(cur_folder+cur_audio_mat);
        res_cell_per_audio = res_cell_per_audio.res_cell_per_audio;

        audio_name = res_cell_per_audio{1,cn.audio_path};
        audio_dops_mat = zeros(length(res_cell_per_audio), 3);
        audio_rx_delays_mat = zeros(length(res_cell_per_audio), 1);
        audio_tx_time = zeros(length(res_cell_per_audio), 1);
        audio_tx_freq = zeros(length(res_cell_per_audio), 1);
        gps_time = zeros(length(res_cell_per_audio), 1);
        speeds = zeros(length(res_cell_per_audio), 1);
        durations = zeros(length(res_cell_per_audio), 1);
        audio_ind = zeros(length(res_cell_per_audio), 1);
        for ith_row = 1:length(res_cell_per_audio)
            cur_res_row = res_cell_per_audio(ith_row ,:);
            if length(cur_res_row{ cn.peak_freqs }) == 2
                cur_echo_dops                = cur_res_row{ cn.peaks_beyond_max_peak };
                audio_rx_delays_mat(ith_row) = cur_res_row{ cn.delay };
                audio_tx_time(ith_row)       = cur_res_row{ cn.times }(1);
                audio_tx_freq(ith_row)       = cur_res_row{ cn.tx_freq_from_filtered_tx_fft };
                gps_time(ith_row)            = cur_res_row{ cn.gps_time_days};
                speeds(ith_row)              = cur_res_row{ cn.speed};
                durations(ith_row)           = diff(cur_res_row{ cn.times});
                audio_ind(ith_row)           = wav_ind;
                switch length(cur_echo_dops)
                    case 1
                        audio_dops_mat(ith_row,1) = cur_echo_dops(1);
                        audio_dops_mat(ith_row,2) = NaN;
                        audio_dops_mat(ith_row,3) = NaN;
                    case 2
                        audio_dops_mat(ith_row,1) = cur_echo_dops(1);
                        audio_dops_mat(ith_row,2) = cur_echo_dops(2);
                        audio_dops_mat(ith_row,3) = NaN;
                    case 3
                        audio_dops_mat(ith_row,1) = cur_echo_dops(1);
                        audio_dops_mat(ith_row,2) = cur_echo_dops(2);
                        audio_dops_mat(ith_row,3) = cur_echo_dops(3);
                end
            end
        end
        relevant_inds = audio_dops_mat(:,1)~=0;
        
        dops_mat_relv = audio_dops_mat(relevant_inds, :);
        tx_freq = audio_tx_freq(relevant_inds, :);
        delays = audio_rx_delays_mat(relevant_inds, :);
        tx_time = audio_tx_time(relevant_inds, :);
        gps_time_relv = gps_time(relevant_inds, :);
        speeds_relv = speeds(relevant_inds, :);
        audio_ind = audio_ind(relevant_inds);
        
        all_dops_mat = [all_dops_mat; dops_mat_relv];
        all_tx_freq = [all_tx_freq; tx_freq];
        all_delays = [all_delays; delays];
        all_tx_time = [all_tx_time; tx_time];
        all_gps_times = [all_gps_times; gps_time_relv];
        all_speeds = [all_speeds; speeds_relv];
        all_wav_ind = [all_wav_ind; audio_ind];
        all_durations = [all_durations; durations];
        map_wav_ind_to_path{wav_ind} = cur_folder+cur_audio_mat;
        wav_ind = wav_ind +1;
        
        toc
    end
end

all_rx_freqs = all_dops_mat+all_tx_freq;
save(base_res_path+"aggregate_results","all_rx_freqs","all_tx_freq", "all_delays", "all_tx_time","all_wav_ind", ...
    "map_wav_ind_to_path", "all_gps_times",  "all_speeds", "all_durations")

