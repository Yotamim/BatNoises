close all; clear; clc
spec_config = GetSpecConfiguration;
jth_audio_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\data\natalya rfer_5_25\Audio_110818000740689_110818000759397_0.wav";

jth_info = audioinfo(jth_audio_path);
fs = jth_info.SampleRate;
jth_wav = audioread(jth_audio_path);
% jth_wav = jth_wav(8*fs:9*fs);
% k = 1000;
% spec_config.fft_length = k;
% spec_config.overlap = 0;
% spec_config.window = hamming(k/5);

[wav_spec, fig_handle] = PlotSpectogram(jth_wav, fs, spec_config.fft_length, ...
    spec_config.freq_range, spec_config.overlap, spec_config.window);


