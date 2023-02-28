clear;close all
base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\23-Feb-2023\";
all_res_folders = dir(base_res_path);
config.bat_config = GetBatConfig;
config.spec_config = GetSpecConfiguration();

relevant_band = config.bat_config.bat_pulse_freq+config.bat_config.bat_dynamic_range;
bat_pulse_freq = config.bat_config.bat_pulse_freq;
center_freq = mean(relevant_band);



for ith_folder = 3:length(all_res_folders)
    if ~all_res_folders(ith_folder).isdir
        continue
    end
    cur_folder = base_res_path+all_res_folders(ith_folder).name+"\";
    cur_files = dir(cur_folder);
    for ith_file = 3:length(cur_files)
        cur_audio_mat = cur_files(ith_file).name;
        res_cell_per_audio = load(cur_folder+cur_audio_mat);
        res_cell_per_audio = res_cell_per_audio.res_cell_per_audio;

        audio_name = res_cell_per_audio{1,5};
        audio = audioread(audio_name);
        fs = audioinfo(audio_name).SampleRate;
        [bb_data, bb_fs] = ProcessSingleAudio(audio, relevant_band, fs, config);
        filtered_audio = bandpass(audio, relevant_band, fs);


        for ith_row = 1:length(res_cell_per_audio)
            cur_res_row = res_cell_per_audio(ith_row ,:);
            cur_fft = cur_res_row{1};
            cur_bb_data = bb_data(cur_res_row{4}(1)*bb_fs:cur_res_row{4}(2)*bb_fs);
            cur_filtered_data = filtered_audio(cur_res_row{4}(1)*fs:cur_res_row{4}(2)*fs);
            [cur_filter_spec, spec_freq_vec, spec_time_vec] = stft(cur_filtered_data, fs, FFTLength=4*config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
                OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);

            n_points = length(cur_fft);
            cur_freq_axis = center_freq+linspace(-n_points/2, (n_points-1)/2, n_points)*bb_fs/n_points;
            figure;
            subplot(2,3,1)
            imagesc(spec_time_vec,spec_freq_vec, pow2db(abs(cur_filter_spec)))
            colormap jet
            colorbar
            set(gca, "YDir", "normal")
            xlabel("time");
            ylabel("freq");
            title("spectrogram")
            subplot(2,3,4)
            plot(cur_freq_axis , abs(cur_fft));hold on;
            plot(cur_res_row{3}+center_freq, cur_res_row{2});
            title("fft")
            if length(cur_res_row{1,6}) == 2
                half_freq_range = abs(diff(cur_res_row{1,6})*0.4);
                tx_freq_range = [cur_res_row{1,6}(1)-half_freq_range, cur_res_row{1,6}(1)+half_freq_range]+center_freq;
                echo_freq_range = [cur_res_row{1,6}(2)-half_freq_range, cur_res_row{1,6}(2)+half_freq_range]+center_freq;
                Plot_flag = true;
                expand_dop_search = true;
                [time_xcor,time_lags,freq_xcor,freq_lags]= FilterEchoAndCorr(cur_filtered_data, fs, tx_freq_range, ...
                    echo_freq_range,expand_dop_search,Plot_flag);
                [~, delay_ind] = max(time_xcor);
                delay = time_lags(delay_ind)/fs;

                [~, dop_ind] = max(freq_xcor);
                dop = freq_lags(dop_ind)*fs/length(cur_filtered_data);
                subplot(2,3,5)
                plot(time_lags/fs, time_xcor)
                title("filtered time correlation")
                subplot(2,3,6)
                plot(freq_lags*fs/length(cur_filtered_data),freq_xcor)
                title("filtered freq correlation")
                
            end
            close
        end
    end
end

bb_fs = -2*cur_res_row{3}(1);

cur_time_vec = (0:n_points*4-1)/bb_fs;
cur_filtered_data = 2*real(exp(-2*pi*1i*center_freq*cur_time_vec).'.*resample(cur_bb_data,4,1));
[filter_spec, spec_freq_vec, spec_time_vec] = stft(cur_filtered_data, bb_fs*4, FFTLength=4*config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
    OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);
