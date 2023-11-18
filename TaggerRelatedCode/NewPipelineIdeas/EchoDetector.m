function EchoDetector(mid_pipe_row, tag_row)


filter_spec = mid_pipe_row.filter_spec{1};
call_fft = mid_pipe_row.call_fft{1};
spec_time_res = mid_pipe_row.spec_time_res{1};
spec_freq_res = mid_pipe_row.spec_freq_res{1};

fft_freqs = linspace(-mid_pipe_row.bb_fs{1}/2, mid_pipe_row.bb_fs{1}/2, ceil(diff(tag_row.times)*mid_pipe_row.bb_fs{1}));
fft_freqs = fft_freqs(abs(fft_freqs)<5000);
if length(fft_freqs) < length(call_fft)
    call_fft = call_fft(1:length(fft_freqs));
elseif length(fft_freqs) > length(call_fft)
    fft_freqs = fft_freqs(1:length(call_fft));
end
fft_freqs = fft_freqs+80000;
total_time = size(filter_spec,2)*spec_time_res;
spec_time_vec = spec_time_res/2:spec_time_res:total_time-spec_time_res/2;
spec_freq_vec = 0:spec_freq_res:90000;
spec_freq_vec = spec_freq_vec(spec_freq_vec>60000 & spec_freq_vec<85000);


IsSameFreqEcho(filter_spec, call_fft, fft_freqs, spec_freq_vec)
IsDopplerEcho()


if 0
    figure;
    subplot(2,1,1)
    clims = [max(pow2db(filter_spec(:)))-30, max(pow2db(filter_spec(:)))];
    img = imagesc(spec_time_vec,spec_freq_vec, pow2db(filter_spec), clims);
    colormap jet
    set(gca, "YDir", "normal")
    xlabel("time");
    ylabel("freq");
    title("other")
    ylim([7.5e4,8.3e4])
    hold on

    subplot(2,1,2)
    plot(fft_freqs, call_fft, ".-")
    title("smooth fft")
    hold on
end
spec_background = prctile(abs(mid_pipe_row.filter_spec), 20);





end
