% next tx vs last rx
bats = [2,4,5];
figure;
for i = 1:length(bats)
    subplot(1,3,i)
    tind =  next_tx<80000 & next_tx>75000 & last_dopp>78000 & last_dopp<81000 & res_table_2_peaks(first_cont_inds,:).bat_num == bats(i);
    percent_used_data = sum(tind)/length(tind);
    nbins = [100,100];
    min_color = 1;
    [xy_corr, pval] = Hist2dAsImage(next_tx(tind), last_dopp(tind), nbins, min_color, percent_used_data);
    xlim = get(gca, "XLim");
    ylim = get(gca, "YLim");
    hold on; plot(xlim(1):xlim(2), xlim(1):xlim(2), "m")
    xlabel("next tx")
    ylabel("last rx")
    
    title(sprintf("bat %.0f, per %.2f data \n corr = %.2f  pval= %.2e ", bats(i), percent_used_data, xy_corr, pval))
end
fig = gcf;
linkaxes(fig.Children,"x","y")
sgtitle("next tx vs last rx")

% diff tx vs last rx
figure;
for i = 1:length(bats)
    subplot(1,3,i)
    tind =  last_tx<80000 & last_tx>75000 & last_dopp>78000 & last_dopp<81000 & ... 
            next_tx<80000 & next_tx>75000 & ...    
    res_table_2_peaks(first_cont_inds,:).bat_num == bats(i)  ;
    percent_used_data = sum(tind)/length(tind);
    nbins = [100,100];
    min_color = 1;
    [xy_corr, pval] = Hist2dAsImage( last_dopp(tind), next_tx(tind)-last_tx(tind), nbins, min_color, percent_used_data);
    xlabel("last rx")
    ylabel("diff tx")
    title(sprintf("bat %.0f, per %.2f data \n corr = %.2f  pval= %.2e ", bats(i), percent_used_data, xy_corr, pval))
end
fig = gcf;
linkaxes(fig.Children,"x","y")
sgtitle("diff tx vs last rx")


% diff tx vs last rx scatter
figure;
for i = 1:length(bats)
    subplot(1,3,i)
    tind =  last_tx<80000 & last_tx>75000 & last_dopp>78000 & last_dopp<81000 & ... 
            next_tx<80000 & next_tx>75000 & ...    
    res_table_2_peaks(first_cont_inds,:).bat_num == bats(i)  ;
    percent_used_data = sum(tind)/length(tind);
    nbins = [100,100];
    min_color = 1;
    scatter(last_dopp(tind), next_tx(tind)-last_tx(tind), ".");
    xlabel("last rx")
    ylabel("diff tx")
    title(sprintf("bat %.0f, per %.2f data \n corr = %.2f  pval= %.2e ", bats(i), percent_used_data, xy_corr, pval))
end
fig = gcf;
linkaxes(fig.Children,"x","y")
sgtitle("diff tx vs last rx")

% last dop vs next tx
figure;
for i = 1:length(bats)
    subplot(1,3,i)
    tind =  last_tx<80000 & last_tx>75000 & last_dopp>78000 & last_dopp<81000 & ... 
            next_tx<80000 & next_tx>75000 & ...    
    res_table_2_peaks(first_cont_inds,:).bat_num == bats(i)  ;
    percent_used_data = sum(tind)/length(tind);
    nbins = [100,100];
    min_color = 1;
    [xy_corr, pval] = Hist2dAsImage( last_dopp(tind)-last_tx(tind), next_tx(tind), nbins, min_color, percent_used_data);
    xlabel("last dop")
    ylabel("next tx")
    title(sprintf("bat %.0f, per %.2f data \n corr = %.2f  pval= %.2e ", bats(i), percent_used_data, xy_corr, pval))
end
fig = gcf;
linkaxes(fig.Children,"x","y")
sgtitle("last dop vs next tx")