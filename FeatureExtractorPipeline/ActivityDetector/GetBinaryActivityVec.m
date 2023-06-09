function activity_vec = GetBinaryActivityVec(wav_stft, PLOT_FLAG)

threshold_cur_spec = prctile(abs(wav_stft(:)),97);
activity_mat = abs(wav_stft)>threshold_cur_spec;

pre_vec = movmean(sum(activity_mat,1),10);
activity_vec = pre_vec>5;


if PLOT_FLAG
    figure; plot(pre_vec); hold on;
    plot(activity_vec*max(pre_vec))

    fig1 = figure; 
    ax1 = subplot(2,1,1);
    imagesc(pow2db(abs(wav_stft)))
    colormap jet
    fig1.Children.YDir = "normal";
    xlabel("time");
    ylabel("freq");
    ax2 = subplot(2,1,2);
    plot(activity_vec)
    linkaxes([ax1, ax2], 'x')
    
    fig1 = figure; 
    ax3 = subplot(2,1,1);
    imagesc( abs(activity_mat))
    fig1.Children.YDir = "normal";
    xlabel("time");
    ylabel("freq");
    
    ax4 = subplot(2,1,2);
    plot(t,activity_vec)
    linkaxes([ax3, ax4], 'x')
    set(gcf, "Position", 1.0e+03 * [0.0010    0.0490    1.5360    0.7408])
end

end