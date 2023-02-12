close all; clear; clc
data_main_path = "C:\Users\yotam\Desktop\ProjectsData\data";
git_info = importdata('C:\Users\yotam\Desktop\MatlabProjects\BatNoises\.git\logs\HEAD');
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
%% folder
ith_folder = 21;
ith_folder_full_path = [all_data_folders(ith_folder).folder,'\', all_data_folders(ith_folder).name];
all_audios_in_folder = dir(ith_folder_full_path);
jth_audio = 6;
jth_audio_path = [ith_folder_full_path, '\', all_audios_in_folder(jth_audio).name];

%% get activity
audio_path = jth_audio_path;
audio_info = audioinfo(audio_path);
fs = audio_info.SampleRate;
wav_data = audioread(audio_path);

relevant_band = config.bat_config.bat_pulse_freq+config.bat_config.bat_dynamic_range;
[baseband_audio, fs_new] = ProcessSingleAudio(wav_data, relevant_band, fs, config);

filtered_audio = bandpass(wav_data, relevant_band, fs);
[wav_spec,spec_freq_vec,spec_time_vec] = stft(filtered_audio, fs, FFTLength=config.spec_config.fft_length,FrequencyRange=config.spec_config.freq_range,...
                        OverlapLength=config.spec_config.overlap, Window=config.spec_config.window);

cur_activity_vec = GetTxRxWindows(wav_spec);
tx_rx_inds_array = ActivityVec2IndsArray(cur_activity_vec, spec_time_vec);
tx_rx_times_array = spec_time_vec(tx_rx_inds_array);

%% Plot
PlotSpectogram(filtered_audio,wav_spec,fs,spec_freq_vec,spec_time_vec)
hold on; plot(tx_rx_times_array(:), zeros(size(tx_rx_times_array(:))), '*')
plot((0:length(wav_data)-1)*1/fs, wav_data/100)
% plot((0:length(proc_audio)-1)*1/fs_new, real(proc_audio)+0.1)
% plot(tx_rx_times_array(:), 0.1+zeros(size(tx_rx_times_array(:))), '*')

%% find time delay
% st = 17.125;
% ft = 17.225;
% single_trx_wav = wav_data(floor(fs*st):ceil(fs*ft));
% figure; plot((floor(fs*st):ceil(fs*ft))/fs,single_trx_wav)
% title("raw")
% aaa = xcorr(single_trx_wav, single_trx_wav);
% aaa = aaa(length(single_trx_wav)+1:end);
% figure; plot((0:length(aaa)-1)/fs, pow2db(abs(aaa)))
% title("raw")
% 
% single_trx_wav_filt = filtered_audio(floor(fs*st):ceil(fs*ft));
% figure; plot((floor(fs*st):ceil(fs*ft))/fs,single_trx_wav_filt )
% title("filt")
% bbb = xcorr(single_trx_wav_filt , single_trx_wav_filt );
% bbb = bbb(length(single_trx_wav_filt )+1:end);
% figure; plot((0:length(aaa)-1)/fs, pow2db(abs(bbb)))
% title("filt")
% 
% single_trx_wav_hilb_filt = hilbert(filtered_audio(floor(fs*st):ceil(fs*ft)));
% figure; plot((floor(fs*st):ceil(fs*ft))/fs,real(single_trx_wav_hilb_filt))
% title("hilb filt")
% ccc = xcorr(single_trx_wav_hilb_filt, single_trx_wav_hilb_filt);
% ccc = ccc(length(single_trx_wav_hilb_filt)+1:end);
% figure; plot((0:length(ccc)-1)/fs, pow2db(abs(ccc)))
% title("hilb filt")

% %% find time delay try 2
% st = 17.125;
% ft = 17.225;
% single_trx_wav = wav_data(floor(fs*st):ceil(fs*ft));
% figure; plot((0:length(single_trx_wav)-1)/fs,single_trx_wav)
% title("raw")
% L = ceil(length(single_trx_wav)/2);
% L_xcorr = xcorr(single_trx_wav, single_trx_wav(1:L));
% L_xcorr = L_xcorr(length(single_trx_wav)+1:end);
% norm_vec_builder = cumsum(abs(single_trx_wav));
% norm_vec = zeros(length(single_trx_wav)-L,1);
% for i = 1:length(norm_vec)
%     norm_vec(i) = norm_vec_builder(L+i)-norm_vec_builder(i);
% end
% 
% figure; plot((0:length(L_xcorr)-1)/fs, pow2db(abs(L_xcorr)))
% title("raw")
% 
% single_trx_wav_filt = filtered_audio(floor(fs*st):ceil(fs*ft));
% figure; plot((floor(fs*st):ceil(fs*ft))/fs,single_trx_wav_filt )
% title("filt")
% bbb = xcorr(single_trx_wav_filt , single_trx_wav_filt );
% bbb = bbb(length(single_trx_wav_filt )+1:end);
% figure; plot((0:length(L_xcorr)-1)/fs, pow2db(abs(bbb)))
% title("filt")
% 
% single_trx_wav_hilb_filt = hilbert(filtered_audio(floor(fs*st):ceil(fs*ft)));
% figure; plot((floor(fs*st):ceil(fs*ft))/fs,real(single_trx_wav_hilb_filt))
% title("hilb filt")
% ccc = xcorr(single_trx_wav_hilb_filt, single_trx_wav_hilb_filt);
% ccc = ccc(length(single_trx_wav_hilb_filt)+1:end);
% figure; plot((0:length(ccc)-1)/fs, pow2db(abs(ccc)))
% title("hilb filt")

%% find time delay try 3
st = 17.125;
ft = 17.265;
L = 0.5;
single_trx_wav_filt = filtered_audio(floor(fs*st):ceil(fs*ft));
figure; plot((floor(fs*st):ceil(fs*ft))/fs,single_trx_wav_filt)

single_trx_wav = wav_data(floor(fs*st):ceil(fs*ft));
L_fac = ceil(length(single_trx_wav)*L);
xcor_vec = norm_cor_yot(single_trx_wav ,L_fac);
figure; plot((0:length(xcor_vec)-1)/fs, abs(xcor_vec))
title("raw")

single_trx_wav_filt = filtered_audio(floor(fs*st):ceil(fs*ft));
L_fac1 = ceil(length(single_trx_wav)*L);
xcor_vec_filt = norm_cor_yot(single_trx_wav_filt , L_fac1);
figure; plot((0:length(xcor_vec_filt)-1)/fs, abs(xcor_vec_filt))
title("filt")

single_trx_wav_hilb_filt = hilbert(filtered_audio(floor(fs*st):ceil(fs*ft)));
L_fac2 = ceil(length(single_trx_wav)*L);
xcor_vec_hilb = norm_cor_yot(single_trx_wav_hilb_filt, L_fac2);
figure; plot((0:length(xcor_vec_hilb)-1)/fs, abs(xcor_vec_hilb))
title("hilb filt")

%% find time delay try 3
st = 17.025;
ft = 17.13;
L = 0.5;
single_trx_wav_filt = filtered_audio(floor(fs*st):ceil(fs*ft));
figure; plot((floor(fs*st):ceil(fs*ft))/fs,single_trx_wav_filt)

single_trx_wav = wav_data(floor(fs*st):ceil(fs*ft));
L_fac = ceil(length(single_trx_wav)*L);
xcor_vec = norm_cor_yot(single_trx_wav ,L_fac);
figure; plot((0:length(xcor_vec)-1)/fs, abs(xcor_vec))
title("raw")

single_trx_wav_filt = filtered_audio(floor(fs*st):ceil(fs*ft));
L_fac1 = ceil(length(single_trx_wav)*L);
xcor_vec_filt = norm_cor_yot(single_trx_wav_filt , L_fac1);
figure; plot((0:length(xcor_vec_filt)-1)/fs, abs(xcor_vec_filt))
title("filt")

single_trx_wav_hilb_filt = hilbert(filtered_audio(floor(fs*st):ceil(fs*ft)));
L_fac2 = ceil(length(single_trx_wav)*L);
xcor_vec_hilb = norm_cor_yot(single_trx_wav_hilb_filt, L_fac2);
figure; plot((0:length(xcor_vec_hilb)-1)/fs, abs(xcor_vec_hilb))
title("hilb filt")
