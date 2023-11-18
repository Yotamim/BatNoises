clear
join_tag_data_and_res
joined_table(end,:) = [];
a = load("time_oriented_approach.mat");
rx_freqs_table = a.rx_freqs_table;
res_cell = rx_freqs_table.time_oriented_approach;

inds = ~cellfun(@isempty, res_cell) & joined_table.rx_freq_tagged ~= 0 & joined_table.rx_freq_tagged ~= -1;

rx_freqs_measured = cell2mat(rx_freqs_table.time_oriented_approach(inds));
figure; scatter(rx_freqs_measured, joined_table.rx_freq_tagged(inds))
hold on
plot([min(rx_freqs_measured(:)), max(rx_freqs_measured(:))], [min(rx_freqs_measured(:)), max(rx_freqs_measured(:))])
legend

figure; scatter(rx_freqs_measured(:,7), joined_table.rx_freq_tagged(inds))
hold on
plot([min(rx_freqs_measured(:)), max(rx_freqs_measured(:))], [min(rx_freqs_measured(:)), max(rx_freqs_measured(:))])
scatter(joined_table.rx_freq(inds), joined_table.rx_freq_tagged(inds))



