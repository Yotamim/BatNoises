clear;close all
base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\23-Feb-2023\";
all_res_folders = dir(base_res_path);
config.bat_config = GetBatConfig;
config.spec_config = GetSpecConfiguration();

relevant_band = config.bat_config.bat_pulse_freq+config.bat_config.bat_dynamic_range;
bat_pulse_freq = config.bat_config.bat_pulse_freq;
center_freq = mean(relevant_band);

plot_1 = false;
a = [];
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
        filtered_audio = bandpass(audio, relevant_band, fs);


        for ith_row = 1:length(res_cell_per_audio)
            tic
            cur_res_row = res_cell_per_audio(ith_row ,:);
            data = filtered_audio(fs*cur_res_row {4}(1):fs*cur_res_row{4}(2));
            if length(cur_res_row{1,6}) == 2
                cur_fft = cur_res_row{1};
                freq_axis = cur_res_row{12};
                freq_corr = cur_res_row{11};
                half_freq_range = abs(diff(cur_res_row{1,6})*0.4);
                tx_freq_range = [cur_res_row{1,6}(1)-half_freq_range, cur_res_row{1,6}(1)+half_freq_range]+center_freq;
                echo_freq_range = [cur_res_row{1,6}(2)-half_freq_range+center_freq, fs/2.1];

                [filtered_echo, filt1]= bandpass(data, echo_freq_range, fs,"Steepness",0.99);
                [filtered_tx,filt2] = bandpass(data, tx_freq_range, fs, "Steepness",0.99);
                if filt1.FrequencyResponse == "bandpass"
                    filter_echo = [filt1.StopbandFrequency1,filt1.StopbandFrequency2];
                else
                    filter_echo = [filt1.StopbandFrequency];
                end
                filter_tx = [filt2.StopbandFrequency1,filt2.StopbandFrequency2];
                n_points = length(filtered_tx);
                [~,dop_inds] = findpeaks(freq_corr/max(freq_corr),"MinPeakHeight", 0.15 , "MinPeakDistance",1500*n_points/fs, "MinPeakProminence", 0.05 ,Annotate="extents");
                [~,first_echo_ind] = max(freq_corr(dop_inds));
                peaks_beyond_max_peak = freq_axis(dop_inds(first_echo_ind:end))*fs/n_points;
                if filter_echo(1) > filter_tx(2)
                    res_cell_per_audio{ith_row, 13} = peaks_beyond_max_peak;
                    res_cell_per_audio{ith_row, 14} = freq_corr(dop_inds)/max(freq_corr);
                    res_cell_per_audio{ith_row, 15} = filter_echo;
                    res_cell_per_audio{ith_row, 16} = filter_tx;
                end
                if filter_echo(1) < filter_tx(2)
                    disp(filter_echo(1) - filter_tx(2))
                    a = [a,filter_echo(1) - filter_tx(2)];
                    smooth_echo_fft = movmean(abs(fftshift(fft(hilbert(filtered_echo)))), 5);
                    smooth_tx_fft = movmean(abs(fftshift(fft(hilbert(filtered_tx)))), 5);
                    f_vec = linspace(-n_points/2, (n_points-1)/2, n_points).'*fs/n_points;

                    %                     figure; subplot(1,2,1)
                    %                     hold on; plot(f_vec, smooth_echo_fft); plot(f_vec, smooth_tx_fft)
                    %                     plot(f_vec,abs(cur_fft))
                    %                     subplot(1,2,2)
                    %                     plot(freq_axis*fs/n_points,freq_corr/max(freq_corr)); hold on
                    %                     plot(peaks_beyond_max_peak, freq_corr(dop_inds(first_echo_ind:end))/max(freq_corr), "*")
                    %                     subplot(1,2,3)
                    %
                    %                     set(gcf, "Position", 1.0e+03 *[-1.5350    0.0530    1.5360    0.7408])
                    %
                    %                     close all
                end
            end
            toc
            if toc < 0.01 && length(cur_res_row{1,6}) == 2
                c = 1;
            end
        end
        %         new_name = cur_folder+cur_audio_mat(1:end-4)+"_with_further_dops";
        %         save(new_name , "res_cell_per_audio")
    end
end


